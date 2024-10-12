# https://git-scm.com
# https://git-scm.com/docs/gitcredentials
# https://git-scm.com/doc/credential-helpers
# https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things
# https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
# https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository

Debian/Ubuntu
~For the latest stable version for your release of Debian/Ubuntu
apt-get install git
~For Ubuntu, this PPA provides the latest stable upstream Git version
add-apt-repository ppa:git-core/ppa
apt update; apt install git

git config credential.https://example.com.username myusername
git config credential.helper "[helper] [options]"
#If you want to check your configuration settings, you can use the git config --list command to
# list all the settings Git can find at that point:
$ git config --list
#You can view all of your settings and where they are coming from using:
$ git config --list --show-origin
git config --global --list
git config --global user.name=["name"]
git config --global user.email=["email"]
git config --global --add safe.directory dir-path
#If you want to use a different text editor, such as Emacs, you can do the following:
$ git config --global core.editor emacs
#To set main as the default branch name do:
$ git config --global init.defaultBranch main
#You can also check what Git thinks a specific key’s value is by typing git config <key>:
$ git config user.name

#--
#Start a new Git repository for an existing code base
$ cd /path/to/my/codebase
#Initial branch configuration: git init also sets up an initial branch ~traditionally main~. However, this
# branch doesn't have any commits until you make your first commit.
$ git init                        #~1~ Create a /path/to/my/codebase/.git directory.
$ git add .                       #~2~ Add all existing files to the index.
$ git commit -m "commit_message"  #~3~ Record the pristine state as the first commit in the history.
git init -b ["main"] #creates or re-initializes local git repository as main branch

#You clone a repository with git clone <url>. For example, if you want to clone the
# Git linkable library called lib-git2, you can do so like this:
git clone URL #clones remote git repository
$ git clone https://github.com/libgit2/libgit2
#If you want to clone the repository into a directory named something other than lib-git2, you can
# specify the new directory name as an additional argument:
git clone URL directory_name #clones a remote repository
$ git clone https://github.com/libgit2/libgit2 mylibgit
#Git has a number of different transfer protocols you can use. The previous example uses the https:// protocol, but
# you may also see git:// or user@server:path/to/repo.git, which uses the SSH transfer protocol.

#The .git folder manages your project's repo. Git doesn't run as a server*. Instead the .git folder acts as your
# local 'server' that all the git commands communicate with. Basically, running a git command edits the contents of the .git folder.

git clone vs. git init
#--
#While git init is used to create a new repository, git clone is used to copy an existing repository. If you're
# starting a new project from scratch use git init. If you're contributing to an existing project or want to create a
# local copy of a project, you'll use git clone followed by the repository's URL.

#The git clone command automatically sets up the necessary config for your repo to connect back to a remote.
# But you can also manually configure a repo set up with git init to connect to a remote.

Best practices for Using git init
#--
#One project per repository: It's a best practice to keep each Git repository limited to a single project or
# logical grouping of files to maintain clarity and organization.
#Immediate .gitignore creation: After initializing your repository, create a .gitignore file to specify
# intentionally untracked files that Git should ignore. Common examples include compiled code, system files, and editor configuration.

git status #shows modified, unmodified files

git remote #List the remote repository connections stored in the local repository by shortname
git remote -v #List the remote repository connections in the local repository with shortnames and URLs
git remote add shortname URL #adds a connection to a remote repository named <shortname> at <URL>
#remove the old 'origin' remote and add new origin remote
git remote remove origin
git remote add origin new_repo_path.git

git add filename #adds files to staging
git add -A #adds all files from working directory to staging, tracking on
git restore filename #discards changes in working directory
git restore --staged filename #unstage, restores a file to another version of the file in the staging area

git commit -m ["init commit"] #commits all files in staging 

git log #shows commit history of current branch
git cat-file -p ["commit-hash"] #first 7 digits of hash is ok, view parent of commit 

git branch #shows all local branches
git branch branch_name #creates local branch
git branch -d branch_name #deletes a local branch

git checkout ["commit-hash"] #checks out a commit
git checkout branch_name #switches to branch
git checkout -b new-branch-name #creates new branch and switches on to it
git switch -c new-branch-name #creates new branch and switches on to it
git switch branch_name #switches to branch

git merge branch_name #integrates changes from branch to target[current] branch
git merge --abort #stops the merge process and go back to the state before the merge

git rebase branch_name #Reapply commits on top of another branch
git rebase --continue #continues with the rebase process after having resolved merge conflicts
git rebase --abort #stops the rebase process and go back to the state before the rebase

git reset --hard HEAD~1
git switch -

#--
git log --all #shows commit history for all branches in local repository
git branch --all #lists local branches and remote-tracking branches
git branch -vv #lists the local branches and their upstream branches, if they have any
git branch -u shortname/branch_name #defines an upstream branch for the current local branch

git push --set-upstream shortname branch_name
git push shortname branch_name #uploads content from <branch_name> to the <shortname> remote repository
git push shortname -d branch_name #deletes a remote branch and the associated remote-tracking branch

git fetch shortname #downloads data from the <shortname> remote repository
git fetch #downloads data from the remote repository with shortname origin
git fetch -p #removes remote-tracking branches that correspond to deleted remote branches and download data from the remote repository

#git fetch + [git merge OR git rebase] = git pull
#--
git pull #if an upstream branch is defined for the current branch, fetch and integrate changes from the defined upstream branch
git pull shortname branch_name #fetches and integrates changes from the <shortname> remote repository for the specified <branch_name>
git pull -p #removes remote-tracking branches that correspond to deleted remote branches and fetches and integrates changes from the <shortname> remote repository for the specified <branch_name>

#master is now named main
#The default branch has been renamed!
#If you have a local clone, you can update it by running the following commands.
git branch -m master main
git fetch origin
git branch -u origin/main main
git remote set-head origin -a

# https://git-scm.com/docs/git-init
#Start a new Git repository for an existing code base
cd /path/to/my/codebase || exit

## Git commands
git init      #~1~ Create a /path/to/my/codebase/.git directory.
git add .     #~2~ Add all existing files to the index.
git commit    #~3~ Record the pristine state as the first commit in the history.
git clone
git add
git commit -m
git status
git pull
git push
git branch -a

#The .git directory structure
HEAD:
#--
#The HEAD file is a reference to the current branch that's checked out. By default, it points to the master or
# main branch, but it won't actually refer to a valid branch until you make your first commit. It can also point to a
# commit if you're in a 'detached HEAD' state.
config:
#--
#This file contains repository-specific configuration settings. These settings can include user information, remote
# repository URLs, and branch configurations. The settings here override the global Git configuration settings for
# this specific repository.
objects/:
#--
#The objects directory stores all the data for your commits, including files and the structure of the commit tree. This
# data is stored in a compressed format, making Git very efficient. The objects are identified by a SHA-1 hash of their content.
refs/:
#--
#The refs directory contains references to commit objects in the repository, organized into subdirectories such as
# heads/ for branch heads and tags/ for tag objects. These references are updated as you commit and branch within your repository.
hooks/:
#--
#This directory contains client-side or server-side scripts that are invoked at different phases of the Git workflow, such as
# before a commit is finalized ~pre-commit~ or before pushing to a remote repository ~pre-push~. By default, Git populates this
# directory with example scripts. These scripts are not active until renamed ~removing the .sample extension~.
info/:
#--
#Inside, you'll find the exclude file, which works like a .gitignore file but is specific to this repository. The patterns listed in
# the exclude file will be ignored by Git, similar to how .gitignore works, but without the need to commit this file into the repository.
description:
#--
#This file is only used by the GitWeb program, which is a Git web interface. By default, it contains a placeholder text
# ~"Unnamed repository; edit this file 'description' to name the repository."~, which can be changed to provide a
# meaningful description of your repository for viewers on GitWeb.
index:
#--
#The index file ~not present immediately after git init but created upon first adding files to the staging area~
# acts as the staging area ~"index"~ for Git. It tracks which files will be included in the next commit.

cat .gitignore
#*.[oa]
#*~

https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control
In a DVCS ~such as Git, Mercurial or Darcs~, clients dont just check out the latest snapshot of the files, rather, they
 fully mirror the repository, including its full history. Thus, if any server dies, and these systems were
  collaborating via that server, any of the client repositories can be copied back up to the server to
   restore it. Every clone is really a full backup of all the data.

https://git-scm.com/book/en/v2/Getting-Started-What-is-Git%3F
The Three States - Pay attention now —  here is the main thing to remember about Git if you want the rest of your
 learning process to go smoothly. Git has three main states that your files can reside in:
modified: Modified means that you have changed the file but have not committed it to your database yet.
staged: Staged means that you have marked a modified file in its current version to go into your next commit snapshot. ,and
committed: Committed means that the data is safely stored in your local database.
This leads us to the three main sections of a Git project: the
 "working tree" ~Working Directory~, the
"staging area" ~Index~, and the
"Git directory" ~Repository~.
The Git directory is where Git stores the metadata and object database for your project. This is the
 most important part of Git, and it is what is copied when you clone a repository from another computer.
The basic Git workflow goes something like this:
 You modify files in your working tree.
You selectively stage just those changes you want to be part of your next commit, which adds only those changes to the staging area.
You ~do a commit, which takes the files as they are in the staging area and stores that snapshot permanently to
 your Git directory. If a particular version of a file is in the Git directory, its considered committed. If it has
been modified and was added to the staging area, it is staged. And if it was changed since it was checked out but has
not been staged, it is modified. In Git Basics, you will learn more about these states and how you can
either take advantage of them or skip the staged part entirely.

https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
Git comes with a tool called git config that lets you get and set configuration variables that control all aspects of
 how Git looks and operates. These variables can be stored in three different places:
/etc/gitconfig file: Contains values applied to every user on the system and all their repositories. If you
 pass the option --system to git config, it reads and writes from this file specifically. Because this is a
system configuration file, you would need administrative or superuser privilege to make changes to it.
~/.gitconfig or ~/.config/git/config file: Values specific personally to you, the user. You can make Git read and write to
 this file specifically by passing the --global option, and this affects all of the repositories you work with on your system.
config file in the Git directory ~that is, .git/config~ of whatever repository youre currently using: Specific to
 that single repository. You can force Git to read from and write to this file with the --local option, but that is in
fact the default. Unsurprisingly, you need to be located somewhere in a Git repository for this option to work properly.
Each level overrides values in the previous level, so values in .git/config trump those in [path]/etc/gitconfig.
On Windows systems, Git looks for the .gitconfig file in the "$HOME" directory ~C:/Users\$USER for most people~. It also
 still looks for [path]/etc/gitconfig, although its relative to the MSys root, which is wherever you decide to
install Git on your Windows system when you run the installer. If you are using version 2.x or later of Git for Windows,
there is also a system-level config file at C:/Documents and Settings/All Users/Application Data/Git/config on Windows XP, and
in C:/ProgramData/Git/config on Windows Vista and newer. This config ~file can only be changed by git config -f <file> as an admin.
You can view all of your settings and where they are coming from using:
$ git config --list --show-origin

$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
$ git config --global core.editor emacs
$ git config --global init.defaultBranch main

https://git-scm.com/book/en/v2/Getting-Started-Getting-Help
$ git help ~verb~
$ git <verb> --help
$ man git-~verb~
~For example, you can get the manpage help for the git config command by running this:

$ git help config

In addition, if you dont need the full-blown manpage help, but just need a quick refresher on the available options for a
Git command, you can ask for the more concise help output with the -h option, as in:
$ git add -h
~If the manpages and this book arent enough and you need in-person help, you can try the
 #git, #github, or #gitlab channels on the Libera Chat IRC server, which can be found at https://libera.chat/.

https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository
Getting a Git Repository
You typically obtain a Git repository in one of two ways:
You can take a local directory that is currently not under version control, and turn it into a Git repository, or
You can clone an existing Git repository from elsewhere.
In either case, you end up with a Git repository on your local machine, ready for work.

Initializing a Repository in an Existing Directory
~If you have a project directory that is currently not under version control and you want to start controlling it
 with Git, you first need to go to that projects directory. If youve never ~done this, it looks a
little different depending on which system youre running:
~for Linux:
$ cd /home/user/my_project
and type:

$ git init

This creates a new subdirectory named .git that contains all of your necessary repository files — a Git repository skeleton.
 At this point, nothing in your project is tracked yet. See Git Internals for more information about exactly what
files are contained in the .git directory you just created.
~If you want to start version-controlling existing files ~as opposed to an empty directory~, you should probably begin
 tracking those files and ~do an initial commit. You can accomplish that with a few git add commands that specify the
files you want to track, followed by a git commit:
$ git add "*.c"
$ git add LICENSE
$ git commit -m 'Initial project version'
We will go over what these commands ~do in just a minute. At this point, you have a Git repository with tracked files and an initial commit.

Cloning an Existing Repository
~If you want to get a copy of an existing Git repository — for example, a project youd like to
 contribute to — the command you need is git clone. If youre familiar with other VCSs such as Subversion, youll notice that the
command is "clone" and not "checkout". This is an important distinction — instead of getting just a working copy, Git receives a
full copy of nearly all data that the server has. Every version of every file for the history of the project is pulled down
by default when you run git clone. In fact, if your server disk gets corrupted, you can often use nearly any of the
clones on any client to set the server back to the state it was in when it was cloned ~you may lose some server-side hooks and such,
but all the versioned data would be there — see Getting Git on a Server for more details~.
You clone a repository with git clone <url>. For example, if you want to clone the Git linkable library called libgit2, you can ~do so like this:

$ git clone https://github.com/libgit2/libgit2

That creates a directory named libgit2, initializes a .git directory inside it, pulls down all the data for that repository,
 and checks out a working copy of the latest version. If you go into the new libgit2 directory that was
just created, youll see the project files in there, ready to be worked on or used.
~If you want to clone the repository into a directory named something other than libgit2, you can specify the
 new directory name as an additional argument:

$ git clone https://github.com/libgit2/libgit2 mylibgit

That command does the same thing as the previous one, but the target directory is called mylibgit.
Git has a number of different transfer protocols you can use. The previous example uses the https:// protocol, but you may also
 see git:// or user@server:path/to/repo.git, which uses the SSH transfer protocol. Getting Git on a Server will introduce all of the
available options the server can set up to access your Git repository and the pros and cons of each.

https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository

