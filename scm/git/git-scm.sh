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
Recording Changes to the Repository
At this point, you should have a bona fide Git repository on your local machine, and a checkout or working copy of all of its
 files in front of you. Typically, youll want to start making changes and committing snapshots of those changes into your
repository each time the project reaches a state you want to record.
Remember that each file in your working directory can be in one of two states:
 tracked or untracked.
Tracked files are files that were in the last snapshot, as well as any newly staged files;
 they can be unmodified, modified, or staged.
In short, tracked files are files that Git knows about.
Untracked files are everything else — any files in your working directory that were not in
 your last snapshot and are not in your staging area. When you first clone a repository, all of your files will be
tracked and unmodified because Git just checked them out and you havent edited anything.
As you edit files, Git sees them as modified, because youve changed them since your last commit. As you work, you
 selectively stage these modified files and ~then commit all those staged changes, and the cycle repeats.

Checking the Status of Your Files
The main tool you use to determine which files are in which state is the git status command. If you run this command
 directly after a clone, you should see something like this:
$ git status

Tracking New Files
In order to begin tracking a new file, you use the command git add. To begin tracking the README file, you can run this:
$ git add README

To stage it, you run the git add command. git add is a multipurpose command — you use it to begin tracking new files,
 to stage files, and to ~do other things like marking merge-conflicted files as resolved. It may be helpful to think of it
  more as ~add precisely this content to the next commit~ rather than ~add this file to the project~.

Short Status
~While the git status output is pretty comprehensive, its also quite wordy. Git also has a short status flag so you can
 see your changes in a more compact way. If you run git status -s or git status --short you get a far more simplified output from the command:
$ git status -s

Ignoring Files
https://github.com/github/gitignore
youll have a class of files that you dont want Git to automatically add or even show you as being untracked. These are
 generally automatically generated files such as log files or files produced by your build system. In such cases, you can
create a file listing patterns to match them named .gitignore. Here is an example .gitignore file:
$ cat .gitignore
#*.[oa]
#*~
Here is another example
.gitignore file:
# ignore all .a files
#*.a
# but do track lib.a, even though you're ignoring .a files above
#!lib.a
# only ignore the TODO file in the current directory, not subdir/TODO
#/TODO
# ignore all files in any directory named build
#build/
# ignore doc/notes.txt, but not doc/server/arch.txt
#doc/*.txt
# ignore all .pdf files in the doc/ directory and any of its subdirectories
#doc/**/*.pdf
In the simple case, a repository might have a single .gitignore file in its root directory, which applies recursively to the
 entire repository. However, it is also possible to have additional .gitignore files in subdirectories. The rules in these
nested .gitignore files apply only to the files under the directory where they are located. The Linux kernel source repository has 206 .gitignore files.

Viewing Your Staged and Unstaged Changes
~If the git status command is too vague for you — you want to know exactly what you changed, not just which files were
 changed — you can use the git diff command.
$ git diff
~If you want to see what youve staged that will go into your next commit, you can use git diff --staged. This command compares your
 staged changes to your last commit:
$ git diff --staged
Its important to note that git diff by itself doesnt show all changes made since your last commit — only changes that
 are still unstaged. If youve staged all of your changes, git diff will give you no output.
you can use
 ~git diff~ to see what is still unstaged and
 ~git diff --cached~ to see what youve staged so far ~--staged and --cached are synonyms~

Committing Your Changes
Now that your staging area is set up the way you want it, you can commit your changes. Remember that anything that is
 still unstaged — any files you have created or modified that you havent run git add on since you edited them — wont go
into this commit. They will stay as modified files on your disk. In this case, lets say that the last time you ran
 git status, you saw that everything was staged, so youre ready to commit your changes. The simplest way to commit is to type git commit:
$ git commit
Alternatively- you can type your commit message inline with the commit command by specifying it after a -m flag, like this:
$ git commit -m "Story 182: fix benchmarks for speed"

Skipping the Staging Area
Although it can be amazingly useful for crafting commits exactly how you want them, the staging area is sometimes a
 bit more complex than you need in your workflow. If you want to skip the staging area, Git provides a simple shortcut.
Adding the -a option to the git commit command makes Git automatically stage every file that is already tracked before doing the
 commit- letting you skip the git add part:
$ git commit -a -m 'Add new benchmarks'

Removing Files
To remove a file from Git, you have to remove it from your tracked files ~more accurately, remove it from your staging area~ and ~then commit.
 The git rm command does that, and also removes the file from your working directory so you dont see it as an
untracked file the next time around. If you simply remove the file from your working directory, it shows up under the
 'Changes not staged for commit' ~that is, unstaged~ area of your git status output:
$ rm PROJECTS.md
$ git rm PROJECTS.md
$ git rm log/\*.log
$ git rm \*~
Another useful thing you may want to ~do is to keep the file in your working tree but remove it from your staging area.
 In other words, you may want to keep the file on your hard drive but not have Git track it anymore. This is
particularly useful if you forgot to add something to your .gitignore file and accidentally staged it, like a
large log file or a bunch of .a compiled files. To ~do this, use the --cached option:
$ git rm --cached README

Moving Files
Unlike many other VCSs, Git doesnt explicitly track file movement. If you rename a file in Git, no metadata is stored in Git that
 tells it you renamed the file. However, Git is pretty smart about figuring that out after the fact — well deal with
detecting file movement a bit later.
Thus its a bit confusing that Git has a mv command. If you want to rename a file in Git, you can run something like:
$ git mv file_from file_to
and it works fine. In fact, if you run something like this and look at the status, youll see that Git considers it a renamed file:
$ git mv README.md README
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
    renamed:    README.md -> README
However- this is equivalent to running something like this:
$ mv README.md README
$ git rm README.md
$ git add README
Git figures out that its a rename implicitly, so it doesnt matter if you rename a file that way or with the mv command.
 The only real difference is that git mv is one command instead of three — its a convenience function.
More importantly, you can use any tool you like to rename a file, and address the add/rm later, before you commit.

https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History
Viewing the Commit History
After you have created several commits, or if you have cloned a repository with an existing commit history, youll probably want to
 look back to see what has happened. The most basic and powerful tool to ~do this is the git log command.
$ git log
One of the more helpful options is -p or --patch, which shows the difference ~the patch output~ introduced in each commit.
 You can also limit the number of log entries displayed, such as using -2 to show only the last two entries.
$ git log -p -2
~if you want to see some abbreviated stats for each commit, you can use the --stat option:
$ git log --stat
$ git log --pretty=oneline
$ git log --pretty=format:"%h - %an, %ar : %s"
$ git log --pretty=format:"%h %s" --graph
$ git log --since=2.weeks
$ git log -S function_name
$ git log -- path/to/file
Preventing the display of merge commits
Depending on the workflow used in your repository, its possible that a sizable percentage of the commits in your
 log history are just merge commits, which typically arent very informative. To prevent the display of merge commits
cluttering up your log history, simply add the log option --no-merges.
~For example, if you want to see which commits modifying test files in the Git source code history were committed by
 Junio Hamano in the month of October 2008 and are not merge commits, you can run something like this:
$ git log --pretty="%h - %s" --author='Junio C Hamano' --since="2008-10-01" \
   --before="2008-11-01" --no-merges -- t/

https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things
One of the common undos takes place when you commit too early and possibly forget to add some files, or you mess up your
 commit message. If you want to redo that commit, make the additional changes you forgot, stage them, and commit again using the --amend option:
$ git commit --amend
As an example, if you commit and ~then realize you forgot to stage the changes in a file you wanted to add to this commit,
 you can ~do something like this:
$ git commit -m 'Initial commit'
$ git add forgotten_file
$ git commit --amend
You end up with a single commit — the second commit replaces the results of the first.
Only amend commits that are still local and have not been pushed somewhere. Amending previously pushed commits and
 force pushing the branch will cause problems for your collaborators. For more on what happens when you ~do this and
how to recover if youre on the receiving end read The Perils of Rebasing.
https://git-scm.com/book/en/v2/ch00/_rebase_peril
Its important to understand that when youre amending your last commit, youre not so much fixing it as replacing it
 entirely with a new, improved commit that pushes the old commit out of the way and puts the new commit in its place.
Effectively- its as if the previous commit never happened, and it wont show up in your repository history.
The obvious value to amending commits is to make minor improvements to your last commit, without cluttering your
 repository history with commit messages of the form, 'Oops, forgot to add a file' or 'Darn, fixing a typo in last commit'.

Unstaging a Staged File
$ git reset HEAD CONTRIBUTING.md
https://git-scm.com/book/en/v2/ch00/_git_reset
Its true that git reset can be a dangerous command, especially if you provide the --hard flag. However, in the
 scenario described above, the file in your working directory is not touched, so its relatively safe.

Unmodifying a Modified File
$ git checkout -- CONTRIBUTING.md
Its important to understand that git checkout -- <file> is a dangerous command. Any local changes you made to that
 file are gone — Git just replaced that file with the last staged or committed version. Dont ever use this command unless you
absolutely know that you dont want those unsaved local changes
~If you would like to keep the changes youve made to that file but still need to get it out of the way for now, well go
 over stashing and branching in Git Branching; these are generally better ways to go.
https://git-scm.com/book/en/v2/ch00/ch03-git-branching
Remember- anything that is committed in Git can almost always be recovered. Even commits that were on branches that
 were deleted or commits that were overwritten with an --amend commit can be recovered ~see Data Recovery for data recovery~.
https://git-scm.com/book/en/v2/ch00/_data_recovery
However- anything you lose that was never committed is likely never to be seen again.

Undoing things with git restore
Git version 2.23.0 introduced a new command: git restore. Its basically an alternative to git reset which we just covered.
 From Git version 2.23.0 onwards, Git will use git restore instead of git reset for many undo operations.
Lets retrace our steps, and undo things with git restore instead of git reset.
Unstaging a Staged File with git restore
$ git restore --staged CONTRIBUTING.md
Unmodifying a Modified File with git restore
$ git restore CONTRIBUTING.md
Its important to understand that git restore ~file~ is a dangerous command. Any local changes you made to that file are
 gone — Git just replaced that file with the last staged or committed version. Dont ever use this command unless you
absolutely know that you dont want those unsaved local changes.

https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes
Working with Remotes
To be able to collaborate on any Git project, you need to know how to manage your remote repositories. Remote repositories are
 versions of your project that are hosted on the Internet or network somewhere. You can have several of them, each of which
generally is either read-only or read/write for you. Collaborating with others involves managing these remote repositories and
pushing and pulling data to and from them when you need to share work. Managing remote repositories includes knowing how to
add remote repositories, remove remotes that are no longer valid, manage various remote branches and define them as
being tracked or not, and more.
Remote repositories can be on your local machine.
It is entirely possible that you can be working with a 'remote' repository that is, in fact, on the same host you are.
 The word 'remote' does not necessarily imply that the repository is somewhere else on the network or Internet, only that
it is elsewhere. Working with such a remote repository would still involve all the standard pushing, pulling and
fetching operations as with any other remote.

Showing Your Remotes
To see which remote servers you have configured, you can run the git remote command. It lists the shortnames of each
 remote handle youve specified. If youve cloned your repository, you should at least see origin — that is the
default name Git gives to the server you cloned from:
$ git remote
$ git remote -v

Adding Remote Repositories
Weve mentioned and given some demonstrations of how the git clone command implicitly adds the origin remote for you.
 Heres how to add a new remote explicitly. To add a new remote Git repository as a shortname you can reference easily, run
git remote add ~shortname~ ~url~
$ git remote
origin
$ git remote add pb https://github.com/paulboone/ticgit
$ git remote -v
Now you can use the string pb on the command line instead of the whole URL.
$ git fetch pb

Fetching and Pulling from Your Remotes
As you just saw, to get data from your remote projects, you can run:
$ git fetch ~remote~
The command goes out to that remote project and pulls down all the data from that remote project that you dont have yet.
 After you ~do this, you should have references to all the branches from that remote, which you can merge in or inspect at any time.
~If you clone a repository, the command automatically adds that remote repository under the name 'origin'. So,
 git fetch origin fetches any new work that has been pushed to that server since you cloned ~or last fetched from~ it.
Its important to note that the git fetch command only downloads the data to your local repository — it doesnt automatically
 merge it with any of your work or modify what youre currently working on. You have to merge it manually into your work when youre ready.
~If your current branch is set up to track a remote branch ~see the next section and Git Branching for more information~,
 you can use the git pull command to automatically fetch and ~then merge that remote branch into your current branch.
This may be an easier or more comfortable workflow for you; and by default, the git clone command automatically sets up
 your local master branch to track the remote master branch ~or whatever the default branch is called~ on the
server you cloned from. Running git pull generally fetches data from the server you originally cloned from and
automatically tries to merge it into the code youre currently working on.
Note
From Git version 2.27 onward, git pull will give a warning if the pull.rebase variable is not set.
Git will keep warning you until you set the variable.
~If you want the default behavior of Git ~fast-forward if possible, else create a merge commit~:
git config --global pull.rebase "false"
~If you want to rebase when pulling:
git config --global pull.rebase "true"

Pushing to Your Remotes
When you have your project at a point that you want to share, you have to push it upstream. The command for this is simple:
 git push ~remote~ ~branch~. If you want to push your master branch to your origin server ~again, cloning generally sets up
both of those names for you automatically~, ~then you can run this to push any commits youve ~done back up to the server:
$ git push origin master
This command works only if you cloned from a server to which you have write access and if nobody has pushed in the meantime.
~If you and someone else clone at the same time and they push upstream and ~then you push upstream, your push will
rightly be rejected. Youll have to fetch their work first and incorporate it into yours before youll be allowed to push.
 See Git Branching for more detailed information on how to push to remote servers.

Inspecting a Remote
~If you want to see more information about a particular remote, you can use the git remote show ~remote~ command.
~If you run this command with a particular shortname, such as origin, you get something like this:
$ git remote show origin

Renaming and Removing Remotes
You can run git remote rename to change a remotes shortname. For instance, if you want to rename pb to paul, you can ~do so with git remote rename:
$ git remote rename pb paul
$ git remote

~If you want to remove a remote for some reason — youve moved the server or are no longer using a particular mirror, or
 perhaps a contributor isnt contributing anymore — you can either use git remote remove or git remote rm:
$ git remote remove paul
$ git remote
origin
Once you delete the reference to a remote this way, all remote-tracking branches and configuration settings associated with that remote are also deleted.


