@def title = "2.2. Hands on: Linux, Vim and Git"
# A Minimum Introduction to Linux, Vim and Git
## A cheatsheet for Bash scripting
Bash is a Unix shell and command language written by Brian Fox for the GNU Project.
in Ubuntu, one can use `Ctrl` + `Alt` + `T` to open a bash shell.
In a bash shell, we use `man command_name` to get help information related to a command,
use `CTRL-C` to break a program and `CTRL-D` to exit a shell or an REPL.

The bash grammar is well summarized in [this cheatsheet](https://devhints.io/bash).
The following is a short list for commands that will be used in this course.

```
man     # an interface to the system reference manuals

ls      # list directory contents
cd      # change directory
mkdir   # make directories
rm      # remove files or directories
pwd     # print name of current/working directory

echo    # display a line of text
cat     # concatenate files and print on the standard output

alias   # create an alias for a command

lscpu   # display information about the CPU architecture
lsmem   # list the ranges of available memory with their online status

top     # display Linux processes
ssh     # the OpenSSH remote login client
vim     # Vi IMproved, a programmer's text editor
git     # the stupid content tracker

useradd # create a new user or update default new user information
passwd  # change user password

tar     # an archiving utility
```

A more detailed [cheat sheet](https://cheatography.com/davechild/cheat-sheets/linux-command-line/) and a [lecture](https://missing.csail.mit.edu/2020/shell-tools/) are available online.

### SSH
[SSH](https://en.wikipedia.org/wiki/Secure_Shell) is a cryptographic network protocol for operating network services securely over an unsecured network. Its most notable applications are remote login and command-line execution.
To learn more about SSH and two factor authentication, please check [this lecture](https://missing.csail.mit.edu/2020/security/).

With a host name (the IP of the target machine to login) and a user name, one can use the following command to login,
```bash
ssh <username>@<hostname>
```
You will get logged in after inputting the password.

### Vim editor
A vim editor can be found in any Linux distribution, with or without a graphical user interface. To edit a file, just type `vim file_name`.

```
i       # input
:w      # write
:q      # quit
:q!     # force quit without saving

u       # undo
CTRL-R  # redo
```
All the commands must be executed in the command mode (the default mode when you start a vim editor),
If you are currently in the input mode, you can alway type `ESC` to go back to the command mode.

To learn more about Vim, please check this [lecture](https://missing.csail.mit.edu/2020/editors/).

## A cheatsheet for Git and Github

Git is a tool for version control.
It is an important tool for programmers to keep track of the different versions of a program and collaborate with others.
GitHub is a website and cloud-based service that helps developers store and manage their code, as well as track and control changes to their code.
There are more than 100 git sub-commands, and the following is a short list to keep in mind.

```
# global config
git config  # Get and set repository or global options

# initialize a repo
git init    # Create an empty Git repo or reinitialize an existing one
git clone   # Clone repository into new directory

# info
git status  # Show the working tree status
git log     # Show commit logs
git diff    # Show changes between commits, commit and working tree, etc

# work on a branch
git add     # Add file contents to the index
git rm      # Remove files from the working tree and from the index
git commit  # Record changes to the repository
git reset   # Reset current HEAD to the specified state

# branch manipulation
git checkout # Switch branches or restore working tree files
git branch  # List, create, or delete branches
git merge   # Join two or more development histories together

# remote synchronization
git remote  # Manage set of tracked repositories
git pull  # Fetch from and integrate with another repo or a local branch
git fetch   # Download objects and refs from another repository
git push    # Update remote refs along with associated objects
```

A more detailed introduction could be found in this [lecture](https://missing.csail.mit.edu/2020/version-control/).

## Resources
* [Learn Bash Shell](https://www.learnshell.org/)
* [Learn Git](https://learngitbranching.js.org/)
* [Github Manual](https://githubtraining.github.io/training-manual/book.pdf)
* [How to create a new github repo](https://docs.github.com/en/get-started/quickstart/create-a-repo)
* [How to create a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)
* [Markdown Tutorial](https://www.markdowntutorial.com/)
* MIT online course [missing semester](https://missing.csail.mit.edu/2020/).
