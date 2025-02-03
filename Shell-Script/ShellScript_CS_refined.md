# Shell Script

- Bash shell uses a feature called environment variables to store information about the shell session and the working environment (thus the name environment variables). This feature stores the data in memory so that any program or script running from the shell can easily access it.  
- There are two types of environment variables in the Bash shell:

  - Global variables
  - Local variables

## Global Environment Variables

- are visible from the shell session and from any child processes that the shell spawns.
- The system environment variables always use all capital letters to differentiate them from normal user environment variables.
- `$ printenv` → view the global environment variables

## Local Environment Variables

- are available only in the shell that creates them
- Unfortunately, there isn’t a command that displays only local environment variables.
- a standard convention in the Bash shell → lowercase letters for variables
- `$ set` → displays all environment variables set for a specific process. However, this also includes the global environment variables.

## Setting Local Environment Variables

```bash
$ test=testing
$ test='testing a long string'
```

Any time you need to reference the value of the test environment variable, just reference it by the name `$test`.

## Setting Global Environment Variables

To create a global environment variable, create a local environment variable and then export it to the global environment.

```bash
$ test=testing
$ export test
```

## Startup Files

When you start a Bash shell by logging into the Linux system, by default Bash checks several files for commands. The startup files Bash processes depend on the method you use to start the Bash shell.

### Three ways of starting a Bash shell:

- Default login shell at login time
- Interactive shell that is not the login shell
- Noninteractive shell to run a script

### Login Shell

When you log into the Linux system, the login shell looks for four different startup files to process commands from:

```bash
/etc/profile
$HOME/.bash_profile
$HOME/.bash_login
$HOME/.profile
```

`/etc/profile` → is the main default startup file for the Bash shell. Whenever you log into the Linux system, Bash executes the commands in the `/etc/profile` startup file.

Those three other startup files are all used for the same function, to provide a user-specific startup file for defining user-specific environment variables. Most Linux distributions use only one of these three.

### Interactive Shell

- If Bash is started as an interactive shell, it doesn’t process the `/etc/profile` file.
- `.bashrc` file in the user’s HOME directory (`~/.bashrc`) does two things:

  - checks for a common `/etc/bash.bashrc` file. The common `bash.bashrc` file provides a way for you to set scripts and variables used by all users who start an interactive shell.
  - provides a place for the user to enter personal aliases and private script functions.

### Noninteractive Shell

- shell that the system starts to execute a shell script. there isn’t a CLI prompt to worry about.
- there may still be specific startup commands you want to run each time you start a script on your system. Bash shell provides the `BASH_ENV` environment variable.
- When the shell starts a noninteractive shell process, it checks this environment variable for the name of a startup file to execute. If one is present, the shell executes the commands in the file. On most Linux distributions, this environment value is not set by default.

## Shell Script

- The first line in the file must specify the Linux shell required to run the script:

  ```bash
  #!/bin/bash
  ```

- `#` → comment
- `$ exec` → will execute a command in place of the current shell, that is, it terminates the current shell and starts a new process in its place.
- If you want to make any local environment variables available for use in the shell script, launch the script using the exec command:

  ```bash
  $ exec ./test1.sh
  ```

## Running in the Background

To run a shell script in background mode from the command-line interface, just place an ampersand symbol after the command:

```bash
$ ./test18.sh &
```

When the background process finishes, it displays a message on the terminal:

```bash
[1]+ Done ./test18.sh
```

You can see that all of the scripts are running by using the `ps` command:

```bash
$ ps au
```

There will be times when you want to start a shell script from a terminal session and then let the script run in background mode until it finishes, even if you exit the terminal session. You can do this by using the `$ nohup` command.

You can combine the `nohup` command with the ampersand to run a script in background and not allow it to be interrupted:

```bash
$ nohup ./test18.sh &
[1] 19831
$ nohup: appending output to 'nohup.out'
```

## Sending Signals

- The Bash shell can send control signals to processes running on the system.
- The `Ctrl+C` key combination generates a `SIGINT` signal and sends it to any processes currently running in the shell. `SIGINT` signal interrupts the running process, which for most processes causes them to stop.
- The `Ctrl+Z` key combination generates a `SIGTSTP` signal, stopping any processes running in the shell.
- You can view the stopped job by using the `ps` command. The `$ ps` command shows the status of the stopped job as `T`, which indicates the command is either being traced or is stopped.

```bash
$ ps au
```

## Viewing Jobs

```bash
$ jobs
```

- `-l` → List the PID of the process along with the job number.
- `-n` → List only jobs that have changed their status since the last notification from the shell.
- `-p` → List only the PIDs of the jobs.
- `-r` → List only the running jobs.
- `-s` → List only stopped jobs.

## Running Like Clockwork

```bash
$ at
```

- allows you to specify a time when the Linux system will run a script. It submits a job to a queue with directions on when the shell should run the job.

```bash
$ atd
```

- runs in the background and checks the job queue for jobs to run. Most Linux distributions start this automatically at boot time.
- The `atd` command checks a special directory on the system (usually `/var/spool/at`) for jobs submitted using the `at` command. By default, the `atd` command checks this directory every 60 seconds. When a job is present, the `atd` command checks the time the job is set to be run. If the time matches the current time, the `atd` command runs the job.
- Any output destined to `STDOUT` or `STDERR` is mailed to the user via the mail system.
- If the script doesn’t produce any output, it won’t generate an email message, by default.

```bash
$ at -f test3.sh 18:49

job 2 at Thu Feb 28 18:49:00 2019

$ mail
```

```bash
$ atq
```

- allows you to view what jobs are pending on the system for execution using the `at` command.

```bash
$ atrm
```

- remove a pending job.

```bash
$ cron
```

- All system users can have their own cron table (including the root user) for running scheduled jobs.

```bash
$ crontab -l
```

- To list an existing cron table. By default, each user’s cron table file doesn’t exist.
- To add entries to your cron table, use the `-e` parameter.
- The format for the cron table is:

  ```bash
  min hour dayofmonth month dayofweek command
  ```