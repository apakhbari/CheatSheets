This is a complex synchronization task involving file introspection (looking inside tarballs), strict date filtering, multithreading, and safety mechanisms (locking/logging).

While you provided a Bash template, **Bash is not suitable for this specific task** because:

1. **Parsing Tarballs:** Running `tar -tvzf` thousands of times in a loop is extremely slow and hard to parse reliably in Bash.
2. **Thread Safety:** Managing shared counters (the "Processed X/Y" log) and file locking across multiple threads in Bash is prone to race conditions.
3. **Date Math:** Comparing integers like `040318` vs `040701` is much cleaner in Python.

Below is a robust **Python** script that replicates your requested logic, logging style, and directory structure exactly, but handles the heavy lifting safely and efficiently.

### The Solution (Python)

Save this as `sync_cashless.py`.

```python
#!/usr/bin/env python3
# Archive/Sync directories under /export/archive_s3/cashless/
# Version: 2026-01-05
# Author: Gemini/APA

import os
import sys
import time
import shutil
import tarfile
import logging
import fcntl
import threading
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime

# ================= CONFIGURATION =================
CODE_VERSION = "2.0-Python"
DRYRUN = False  # Set to True to test without writing
MAX_THREADS = 8 # Adjust based on CPU cores

# Date Range (Jalali YYMMDD) - EXCLUSIVE based on prompt
# "040318 and 040701 must not proceed" -> 040318 < DATE < 040701
DATE_MIN = 40318
DATE_MAX = 40701

SOURCE_DIR = "/export/archive_s3/cashless"
DEST_DIR = "/mnt/external-hdd/cashless"
LOG_DIR = "./logs/"
LOCKFILE_PATH = "/var/run/archive_cashless.lock"

# ================= LOGGING SETUP =================
os.makedirs(LOG_DIR, exist_ok=True)
timestamp = datetime.now().strftime("%y%m%d_%H%M")
base_logfile = os.path.join(LOG_DIR, f"archive_cashless_{timestamp}.log")

# Logic to handle rotating logs if filename exists (like your bash script)
logfile = base_logfile
count = 2
while os.path.exists(logfile):
    logfile = os.path.join(LOG_DIR, f"archive_cashless_{timestamp}_{count}.log")
    count += 1

# Setup Logger
logging.basicConfig(
    filename=logfile,
    level=logging.INFO,
    format='%(asctime)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

# Console handler to see output in real-time
console = logging.StreamHandler()
console.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
console.setFormatter(formatter)
logging.getLogger('').addHandler(console)

# Global counters for progress
progress_lock = threading.Lock()
processed_terminals_count = 0
total_terminals_count = 0

# ================= FUNCTIONS =================

def log(message):
    """Wrapper to match the requested logging style."""
    logging.info(message)

def acquire_lock():
    """Ensures only one instance runs using a file lock."""
    global lock_handle
    lock_handle = open(LOCKFILE_PATH, 'w')
    try:
        fcntl.flock(lock_handle, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except IOError:
        print(f"Another instance is running. Check {LOCKFILE_PATH}")
        sys.exit(1)

def is_valid_date(filename):
    """
    Checks if filename matches YYMMDD and is strictly between MIN and MAX.
    Example: 030529.tar.gz -> 30529. Check if > 40318 and < 40701.
    """
    try:
        name_part = filename.split('.')[0] # Remove .tar.gz
        if not name_part.isdigit() or len(name_part) != 6:
            return False
        
        date_num = int(name_part)
        
        # EXCLUSIVE RANGE: "from 040318 to 040701... both must not proceed"
        if DATE_MIN < date_num < DATE_MAX:
            return True
        return False
    except ValueError:
        return False

def get_tar_members(filepath):
    """Returns a set of filenames inside a tar.gz without extracting."""
    try:
        if os.path.getsize(filepath) == 0:
            return set()
        with tarfile.open(filepath, "r:gz") as tar:
            # We only care about names to check existence
            return set(tar.getnames())
    except Exception as e:
        log(f"ERROR reading tar {filepath}: {e}")
        return None

def sync_file(terminal_name, filename):
    """
    Compares Source .tar.gz vs Dest .tar.gz.
    If Dest missing or contents different (missing JPGs), copies Source to Dest.
    """
    src_path = os.path.join(SOURCE_DIR, terminal_name, filename)
    dest_term_dir = os.path.join(DEST_DIR, terminal_name)
    dest_path = os.path.join(dest_term_dir, filename)
    
    thread_id = threading.get_ident()

    # 1. Check Source Validity
    if os.path.getsize(src_path) == 0:
        return # Skip empty source files

    # 2. Check Destination Existence
    if not os.path.exists(dest_path):
        if DRYRUN:
            log(f"[PID:{thread_id}] DRYRUN: Copying NEW {src_path} -> {dest_path}")
        else:
            try:
                os.makedirs(dest_term_dir, exist_ok=True)
                shutil.copy2(src_path, dest_path)
                log(f"[PID:{thread_id}] COPIED: {terminal_name}/{filename}")
            except Exception as e:
                log(f"[PID:{thread_id}] ERROR Copying: {e}")
        return

    # 3. Deep Inspection (Content Check)
    # The user wants to ensure all JPGs in Source are in Dest.
    # Since we cannot easily "append" to a .tar.gz efficiently without rewriting,
    # if Source has content that Dest misses, we overwrite Dest with Source.
    
    src_members = get_tar_members(src_path)
    dest_members = get_tar_members(dest_path)

    if src_members is None:
        return # Source corrupted

    if dest_members is None:
        # Destination corrupted, overwrite it
        needs_sync = True
    else:
        # Check if Source has any files NOT in Destination
        # Difference = Files in Source but NOT in Dest
        missing_in_dest = src_members - dest_members
        needs_sync = len(missing_in_dest) > 0

    if needs_sync:
        if DRYRUN:
            log(f"[PID:{thread_id}] DRYRUN: Syncing (Content Mismatch) {src_path} -> {dest_path}")
        else:
            try:
                shutil.copy2(src_path, dest_path) # Overwrite
                log(f"[PID:{thread_id}] UPDATED: {terminal_name}/{filename} (Source had {len(src_members)} files, Dest missing items)")
            except Exception as e:
                log(f"[PID:{thread_id}] ERROR Updating: {e}")

def process_terminal(terminal_name):
    """Worker function to process one terminal directory."""
    global processed_terminals_count
    
    src_term_path = os.path.join(SOURCE_DIR, terminal_name)
    
    if not os.path.isdir(src_term_path):
        return

    try:
        files = os.listdir(src_term_path)
        for f in files:
            if f.endswith(".tar.gz") and is_valid_date(f):
                sync_file(terminal_name, f)
    except Exception as e:
        log(f"ERROR processing terminal {terminal_name}: {e}")

    # Update Progress
    with progress_lock:
        processed_terminals_count += 1
        if processed_terminals_count % 100 == 0:
            log(f"PROGRESS: Processed {processed_terminals_count} / {total_terminals_count} terminals")

def main():
    global total_terminals_count
    
    acquire_lock()
    
    start_time = time.time()
    divider = "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    
    log(divider)
    log("==== Archive process started ====")
    log(f"==== {datetime.now().strftime('%F %T')} ====")
    log(f"CODE_VERSION: {CODE_VERSION}")
    log(f"THREADS: {MAX_THREADS}")
    log(f"DRYRUN: {DRYRUN}")
    log(f"RANGE: {DATE_MIN} < DATE < {DATE_MAX}")
    log("\n")

    # 1. Get List of Terminals (Directories) in Source
    log("Scanning source directory...")
    try:
        all_items = os.listdir(SOURCE_DIR)
        terminals = [d for d in all_items if os.path.isdir(os.path.join(SOURCE_DIR, d))]
        total_terminals_count = len(terminals)
        log(f"Found {total_terminals_count} terminals to process.")
    except FileNotFoundError:
        log(f"CRITICAL: Source directory {SOURCE_DIR} not found.")
        sys.exit(1)

    # 2. ThreadPool Execution
    log("Starting threads...")
    with ThreadPoolExecutor(max_workers=MAX_THREADS) as executor:
        executor.map(process_terminal, terminals)

    # 3. Summary
    duration = int(time.time() - start_time)
    log("\n")
    log(f"Process took {duration} seconds.")
    log("==== Archive process finished ====")
    log(divider)

if __name__ == "__main__":
    main()

```

### How to use this script

1. **Mount your drive:** Ensure `/mnt/external-hdd` is mounted.
2. **Save the file:** Create `sync_cashless.py` inside `/home/etlocal/apa/` (or your preferred location).
3. **Permissions:** Make it executable.
```bash
chmod +x sync_cashless.py

```


4. **Dry Run (Safety Check):**
Open the script and ensure `DRYRUN = True`. Run it. It will create logs showing exactly what it *would* do without touching your data.
```bash
./sync_cashless.py

```


5. **Production Run:**
Edit the file, set `DRYRUN = False`, and run it. You can run it in the background using `nohup` or `screen` if it takes a long time.

### Key Logic Explanations

1. **Date Filtering (`is_valid_date`):**
The script converts filenames (e.g., `040520`) into integers (`40520`). It checks if `40318 < 40520 < 40701`. This strictly adheres to your requirement that start and end dates "must not proceed".
2. **Introspection (`get_tar_members`):**
Instead of just checking if the file exists, the script uses Python's `tarfile` library to read the header of the Source `.tar.gz` and the Destination `.tar.gz`.
* It creates a set of filenames (JPGs) for both.
* If `Source_Set` contains items not found in `Dest_Set`, it flags the file for update.


3. **Update Strategy (Overwrite vs Append):**
* *Technical Constraint:* You cannot simply "inject" a file into a compressed `.tar.gz` on the hard drive efficiently. You have to decompress the whole thing and recompress it.
* *Script Logic:* If the Source is the "master" and has more files than the Destination, the script simply copies the **Source file over the Destination file**. This guarantees they are identical and is much faster/safer than trying to merge tar streams manually.


4. **Threading:**
It uses `ThreadPoolExecutor`. This allows 8 (or more) terminals to be processed simultaneously. Each thread logs its own PID (`threading.get_ident()`) so you can debug specific workers.
5. **Progress Indicator:**
A shared counter protected by a Lock updates every time a terminal finishes. Every 100 terminals, it prints the status to the log.