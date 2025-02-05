# Shell Script
```
 _______  __   __  _______  ___      ___          _______  _______  ______    ___   _______  _______ 
|       ||  | |  ||       ||   |    |   |        |       ||       ||    _ |  |   | |       ||       |
|  _____||  |_|  ||    ___||   |    |   |        |  _____||       ||   | ||  |   | |    _  ||_     _|
| |_____ |       ||   |___ |   |    |   |        | |_____ |       ||   |_||_ |   | |   |_| |  |   |  
|_____  ||       ||    ___||   |___ |   |___     |_____  ||      _||    __  ||   | |    ___|  |   |  
 _____| ||   _   ||   |___ |       ||       |     _____| ||     |_ |   |  | ||   | |   |      |   |  
|_______||__| |__||_______||_______||_______|    |_______||_______||___|  |_||___| |___|      |___|  
```

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

# Define Variables

```bash
var1=10
var2=23.45
var3=testing
var4="Still more testing"
```

---

# Command-line Arguments

```bash
$ cat test4.sh

#!/bin/bash
# Testing command line arguments

echo $1 checked in $2 days ago

$ chmod u+x test4.sh
$ ./test4.sh Anisa 4

Barbara checked in 4 days ago

$ ./test4.sh Mohsen 5

Jessica checked in 5 days ago

$ ./test4.sh Mohammad

rich checked in days ago
```

---

# Basic Reading

```bash
$ cat test5.sh

#!/bin/bash
# testing the read command

echo -n "Enter your name: "
read name
echo "Hello $name, welcome to my program."

$ ./test5.sh

Enter your name: Moshen Mohammad Amini

Hello Moshen Mohammad Amini, welcome to my program.
```

---

# Basic Reading with Prompt

```bash
$ cat test6.sh

#!/bin/bash
# testing the read -p option

read -p "Please enter your age:" age
days=$[ $age * 365 ]

echo "That makes you over $days days old!"

$ ./test6.sh

Please enter your age:23

That makes you over 8395 days old!
```

---

# Basic Reading with Multiple Variables

Each data value entered is assigned to the next variable in the list.

```bash
$ cat test7.sh

#!/bin/bash
# entering multiple variables

read -p "Enter your name: " first last
echo "Checking data for $last, $first…"

$ ./test7.sh

Enter your name: Rich Blum

Checking data for Blum, Rich…
```

---

# Basic Reading Without Specifying Variables

You can also specify no variables on the read command line. The read command places any data it receives in the special environment variable `REPLY`.

```bash
$ cat test8.sh

#!/bin/bash
# testing the REPLY environment variable

read -p "Enter a number: "

factorial=1
for (( count=1; count <= $REPLY; count++ ))
do
    factorial=$[ $factorial * $count ]
done

echo "The factorial of $REPLY is $factorial"

$ ./test8.sh

Enter a number: 5

The factorial of 5 is 120
```

---

# Reading With Timing Out and Counting Input Characters

The `-t` option specifies the number of seconds for the read command to wait for input.

You can also set the read command to count the input characters with `-n` option. When a preset number of characters has been entered, it automatically exits, assigning the entered data to the variable. As soon as you press the single character to answer, the read command accepts the input and passes it to the variable. There’s no need to press the Enter key.

```bash
$ cat test9.sh

#!/bin/bash
# timing the data entry

if read -t 5 -p "Please enter your name: " name
then
    echo "Hello $name, welcome to my script"
else
    echo
    echo "Sorry, too slow!"
fi

$ ./test9.sh

Please enter your name: Mohsen

Hello Mohsen, welcome to my script

$ ./test9.sh

Please enter your name:

Sorry, too slow!
```

---

```bash
$ cat test10.sh

#!/bin/bash
# getting just one character of input

read -n1 -p "Do you want to continue [Y/N]? " answer

case $answer in
    Y | y) echo
           echo "fine, continue on…";;
    N | n) echo
           echo OK, goodbye
           exit;;
esac

echo "This is the end of the script"

$ ./test10.sh

Do you want to continue [Y/N]? Y

fine, continue on…

This is the end of the script

$ ./test10.sh

Do you want to
```

---

# Silent Reading with `-s`

```bash
$ cat test11.sh

#!/bin/bash
# hiding input data from the monitor

read -s -p "Enter your password: " pass
echo
echo "Is your password really $pass?"

$ ./test11.sh

Enter your password:

Is your password really T3st1ng?
```

---

# Exit Status

```bash
$ /bin/bash

$ exit 120

exit

$ echo $?

120
```

---

# Command Substitution

```bash
$ var1=`date`
$ echo $var1

Fri Feb 21 18:05:38 EST 2019

$ var2=$(whoami)
$ echo $var2

anisa
```

---

# Performing Math

The `$[]` format allows you to use integers only:

```bash
result=$[ 25 * 5 ]
```

Floating point using `bc`. The basic format you need to use is:

```bash
variable=$(echo "options; expression" | bc)
```

Example:

```bash
$ var1=$(echo "scale=4; 3.44 / 5" | bc)
$ echo $var1

.6880
```

---

# The `IF` Statement

```bash
if [ condition ]
then
    commands
else
    other commands
fi
```

You can combine tests by using the Boolean `AND` (`&&`) and `OR` (`||`) symbols.

Example:

```bash
if [ -s /tmp/tempstuff ]
then
    echo "/tmp/tempstuff found; aborting!"
    exit
fi
```

# Comparison Operators in Bash

| Test | Type | Description |
|------|------|-------------|
| n1 -eq n2 | Numeric | Checks if n1 is equal to n2 |
| n1 -ge n2 | Numeric | Checks if n1 is greater than or equal to n2 |
| n1 -gt n2 | Numeric | Checks if n1 is greater than n2 |
| n1 -le n2 | Numeric | Checks if n1 is less than or equal to n2 |
| n1 -lt n2 | Numeric | Checks if n1 is less than n2 |
| n1 -ne n2 | Numeric | Checks if n1 is not equal to n2 |
| str1 = str2 | String | Checks if str1 is the same as str2 |
| str1 != str2 | String | Checks if str1 is not the same as str2 |
| str1 < str2 | String | Checks if str1 is less than str2 |
| -n str1 | String | Checks if str1 has a length greater than zero |
| -z str1 | String | Checks if str1 has a length of zero |
| -d file | File | Checks if file exists and is a directory |
| -e file | File | Checks if file exists |
| -f file | File | Checks if file exists and is a file |
| -r file | File | Checks if file exists and is readable |
| -s file | File | Checks if file exists and is not empty |
| -w file | File | Checks if file exists and is writable |
| -x file | File | Checks if file exists and is executable |
| -O file | File | Checks if file exists and is owned by the current user |
| -G file | File | Checks if file exists and the default group is the same as the current user |
| file1 -nt file2 | File | Checks if file1 is newer than file2 |
| file1 -ot file2 | File | Checks if file1 is older than file2 |


# Bash Script Examples

## If Condition

```bash
#!/bin/bash

# testing the if condition

if [ $1 -eq $2 ]
then
    echo "Both values are equal!"
    exit
fi

if [ $1 -gt $2 ]
then
    echo "The first value is greater than the second"
    exit
fi

if [ $1 -lt $2 ]
then
    echo "The first value is less than the second"
    exit
fi
```

```bash
$ chmod u+x test12.sh
$ ./test12.sh 10 5

The first value is greater than the second
```

---

## The Case Statement

```bash
case variable in
    pattern1) commands1;;
    pattern2 | pattern3) commands2;;
    *) default commands;;
esac
```

```bash
$ cat test13.sh

#!/bin/bash

# using the case statement

case $USER in
    anisa | root)
        echo "Welcome, $USER"
        echo "Please enjoy your visit";;
    testing)
        echo "Special testing account";;
    mohsen)
        echo "Don't forget to log off when you're done";;
    *)
        echo "Sorry, you're not allowed here";;
esac

$ chmod u+x test6.sh
$ ./test13.sh

Welcome, anisa
Please enjoy your visit
```

---

## The `for` Loop

```bash
for variable in series ; do
    commands
done
```

Instead of having to list all of the numbers individually, you can use the `seq` command.

```bash
for x in `seq 1 10` ; do
    commands
done
```

```bash
$ cat test14.sh

#!/bin/bash

# iterate through the files in the Home folder

for file in $(ls | sort) ; do
    if [ -d $file ]
    then
        echo "$file is a directory"
    fi
    if [ -f $file ]
    then
        echo "$file is a file"
    fi
done

$ ./test14.sh

Desktop is a directory
Documents is a directory
...
test1.sh is a file
test2.sh
```

---

## The `while` Loop

The opposite of the `while` command is the `until` command.

```bash
while [ condition ] ; do
    commands
done
```

```bash
$ cat test15.sh

#!/bin/bash

number=$1
factorial=1

while [ $number -gt 0 ] ; do
    factorial=$[ $factorial * $number ]
    number=$[ $number - 1 ]
done

echo The factorial of $1 is $factorial
```

```bash
$ ./test15.sh 5

The factorial of 5 is 120

$ ./test15.sh 6

The factorial of 6 is 720
```

---

## Functions

There are two formats:

```bash
function name {
    commands
}
```

or

```bash
name() {
    commands
}
```

```bash
$ cat test17.sh

#!/bin/bash

# using the return command in a function

function dbl {
    read -p "Enter a value: " value
    echo "doubling the value"
    return $[ $value * 2 ]
}

dbl

echo "The new value is $?"
```