how to do chmod for directories 750 and for files 640 recursively?
ChatGPT said:
ChatGPT

To recursively set permissions for directories to 750 and files to 640, you can use find in combination with chmod. Here's how you can do it:

bash

# Set directory permissions to 750
find /path/to/directory -type d -exec chmod 750 {} \;

# Set file permissions to 640
find /path/to/directory -type f -exec chmod 640 {} \;

Explanation:

    find /path/to/directory: This starts the search from the specified directory.
    -type d: Limits the search to directories.
    -type f: Limits the search to files.
    -exec chmod 750 {}: For directories, applies chmod 750 to each result found.
    -exec chmod 640 {}: For files, applies chmod 640 to each result found.
    \;: Terminates the -exec command.