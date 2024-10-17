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
git log --oneline --decorate --graph --all
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
git pull --allow-unrelated-histories origin main

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

https://git-scm.com/book/en/v2/Git-Basics-Tagging
Listing Your Tags - Listing the existing tags in Git is straightforward. Just type git tag ~with optional -l or --list~:
$ git tag
Listing tag wildcards requires -l or --list option
~If you want just the entire list of tags, running the command git tag implicitly assumes you want a listing and
 provides one; the use of -l or --list in this case is optional.
~If- however, youre supplying a wildcard pattern to match tag names, the use of -l or --list is mandatory.

Creating Tags
Git supports two types of tags: lightweight and annotated.
A lightweight tag is very much like a branch that doesnt change — its just a pointer to a specific commit.
Annotated tags, however, are stored as full objects in the Git database. Theyre checksummed; contain the
 tagger name, email, and date; have a tagging message; and can be signed and verified with GNU Privacy Guard ~GPG~.
Its generally recommended that you create annotated tags so you can have all this information; but if you want a
 temporary tag or for some reason dont want to keep the other information, lightweight tags are available too.

Annotated Tags
Creating an annotated tag in Git is simple. The easiest way is to specify -a when you run the tag command:
$ git tag -a v1.4 -m "my version 1.4"
You can see the tag data along with the commit that was tagged by using the git show command:
$ git show v1.4

Lightweight Tags
Another way to tag commits is with a lightweight tag. This is basically the commit checksum stored in a file — no other
 information is kept. To create a lightweight tag, dont supply any of the -a, -s, or -m options, just provide a tag name:
$ git tag v1.4-lw
This time, if you run git show on the tag, you dont see the extra tag information. The command just shows the commit:
$ git show v1.4-lw

Tagging Later
You can also tag commits after youve moved past them.
$ git tag -a v1.2 9fceb02

Sharing Tags
By default, the git push command doesnt transfer tags to remote servers. You will have to explicitly push tags to a
 shared server after you have created them. This process is just like sharing remote branches — you can run git push origin <tagname>.
$ git push origin v1.5
~If you have a lot of tags that you want to push up at once, you can also use the --tags option to the git push command.
 This will transfer all of your tags to the remote server that are not already there.
$ git push origin --tags
git push pushes both types of tags
git push ~remote~ --tags will push both lightweight and annotated tags. There is currently no option to push only
 lightweight tags, but if you use git push <remote> --follow-tags only annotated tags will be pushed to the remote.

Deleting Tags
To delete a tag on your local repository, you can use git tag -d <tagname>. For example, we could remove our lightweight tag above as follows:
$ git tag -d v1.4-lw
Note that this does not remove the tag from any remote servers. There are two common variations for deleting a tag from a remote server.
The first variation is git push ~remote~ :refs/tags/<tagname>:
$ git push origin :refs/tags/v1.4-lw
The way to interpret the above is to read it as the null value before the colon is being pushed to the
 remote tag name, effectively deleting it.
The second ~and more intuitive~ way to delete a remote tag is with:
$ git push origin --delete ~tagname~

Checking out Tags
~If you want to view the versions of files a tag is pointing to, you can ~do a git checkout of that tag, although this
 puts your repository in 'detached HEAD' state, which has some ill side effects:
$ git checkout v2.0.0
In 'detached HEAD' state, if you make changes and ~then create a commit, the tag will stay the same, but your
 new commit wont belong to any branch and will be unreachable, except by the exact commit hash. Thus, if you need to
make changes — say youre fixing a bug on an older version, for instance — you will generally want to create a branch:
$ git checkout -b version2 v2.0.0
Switched to a new branch 'version2'
~If you ~do this and make a commit, your version2 branch will be slightly different than your v2.0.0 tag since it will
 move forward with your new changes, so ~do be careful.

https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases
Git doesnt automatically infer your command if you type it in partially. If you dont want to type the entire text of each of the
 Git commands, you can easily set up an alias for each command using git config. Here are a couple of examples you may want to set up:
$ git config --global alias.co checkout
$ git config --global alias.br branch
$ git config --global alias.ci commit
$ git config --global alias.st status
This means that, for example, instead of typing git commit, you just need to type git ci. As you go on using Git, youll probably
 use other commands frequently as well; dont hesitate to create new aliases.
This technique can also be very useful in creating commands that you think should exist. For example, to correct the
 usability problem you encountered with unstaging a file, you can add your own unstage alias to Git:
$ git config --global alias.unstage 'reset HEAD --'
This makes the following two commands equivalent:
$ git unstage fileA
$ git reset HEAD -- fileA
This seems a bit clearer. Its also common to add a last command, like this:
$ git config --global alias.last 'log -1 HEAD'
This way, you can see the last commit easily:
$ git last
As you can tell, Git simply replaces the new command with whatever you alias it for. However, maybe you want to run an
 external command, rather than a Git subcommand. In that case, you start the command with a ! character. This is useful if you
write your own tools that work with a Git repository. We can demonstrate by aliasing git visual to run gitk:
$ git config --global alias.visual '!gitk'

https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell
Git doesnt store data as a series of changesets or differences, but instead as a series of snapshots.
When you make a commit, Git stores a commit object that contains a pointer to the snapshot of the content you staged.
 This object also contains the authors name and email address, the message that you typed, and pointers to the commit or
commits that directly came before this commit ~its parent or parents~: zero parents for the initial commit, one parent for a
 normal commit, and multiple parents for a commit that results from a merge of two or more branches.
To visualize this, lets assume that you have a directory containing three files, and you stage them all and commit.
 Staging the files computes a checksum for each one, stores that version of the file in the
Git repository ~Git refers to them as blobs~, and adds that checksum to the staging area:
$ git add README test.rb LICENSE
$ git commit -m 'Initial commit'
When you create the commit by running git commit, Git checksums each subdirectory ~in this case, just the root project directory~ and
 stores them as a tree object in the Git repository. Git ~then creates a commit object that has the metadata and a
pointer to the root project tree so it can re-create that snapshot when needed.
Your Git repository now contains five objects: three blobs ~each representing the contents of one of the three files~,
 one tree that lists the contents of the directory and specifies which file names are stored as which blobs, and
one commit with the pointer to that root tree and all the commit metadata.
~If you make some changes and commit again, the next commit stores a pointer to the commit that came immediately before it.
A branch in Git is simply a lightweight movable pointer to one of these commits. The default branch name in Git is master.
 As you start making commits, youre given a master branch that points to the last commit you made. Every time you commit, the
master branch pointer moves forward automatically.
Note - The 'master' branch in Git is not a special branch. It is exactly like any other branch. The
 only reason nearly every repository has one is that the git init command creates it by default and most people dont bother to change it.

Creating a New Branch
What happens when you create a new branch? Well, doing so creates a new pointer for you to move around. Lets say you want to
 create a new branch called testing. You ~do this with the 'git branch' command:
$ git branch testing
This creates a new pointer to the same commit youre currently on.
How does Git know what branch youre currently on? It keeps a special pointer called 'HEAD'. Note that this is a
 lot different than the concept of HEAD in other VCSs you may be used to, such as Subversion or CVS. In Git, this is a
pointer to the local branch youre currently on. In this case, youre still on master. The git branch command only created a
 new branch — it didnt switch to that branch.

Switching Branches
To switch to an existing branch, you run the 'git checkout' command. Lets switch to the new testing branch:
$ git checkout testing
This moves HEAD to point to the testing branch.
Note- git log doesnt show all the branches all the time
~If you were to run git log right now, you might wonder where the "testing" branch you just created went, as it would not appear in the output.
The branch hasnt disappeared; Git just doesnt know that youre interested in that branch and it is trying to
 show you what it thinks youre interested in. In other words, by default, git log will only show commit history below the branch youve checked out.
To show commit history for the desired branch you have to explicitly specify it:
 git log testing.
To show all of the branches, add --all to your git log command.
$ git checkout master ~HEAD moves when you checkout~
That command did two things. It moved the HEAD pointer back to point to the master branch, and it reverted the files in
 your working directory back to the snapshot that master points to. This also means the changes you make from this
point forward will diverge from an older version of the project. It essentially rewinds the work youve ~done in your
 testing branch so you can go in a different direction.
Note- Switching branches changes files in your working directory
Its important to note that when you switch branches in Git, files in your working directory will change. If you switch to
 an older branch, your working directory will be reverted to look like it did the last time you committed on that branch.
~If Git cannot ~do it cleanly, it will not let you switch at all.

Because a branch in Git is actually a simple file that contains the 40 character SHA-1 checksum of the commit it points to,
 branches are cheap to create and destroy. Creating a new branch is as quick and simple as writing 41 bytes to a file ~40 characters and a newline~.
This is in sharp contrast to the way most older VCS tools branch, which involves copying all of the projects files into a
 second directory. This can take several seconds or even minutes, depending on the size of the project, whereas in Git the
process is always instantaneous. Also, because were recording the parents when we commit, finding a proper merge base for
 merging is automatically ~done for us and is generally very easy to do. These features help encourage developers to create and use branches often.
Lets see why you should ~do so.
Note- Creating a new branch and switching to it at the same time
Its typical to create a new branch and want to switch to that new branch at the same time — this can be ~done in one operation with
 git checkout -b <newbranchname>.
Note- From Git version 2.23 onwards you can use git switch instead of git checkout to: Switch to an existing branch:
 git switch testing-branch.
Create a new branch and switch to it:
 git switch -c new-branch.
The -c flag stands for create, you can also use the full flag: --create. Return to your previously checked out branch:
 git switch -.

https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging
$ git checkout -b iss53
Switched to a new branch "iss53"
This is shorthand for:
$ git branch iss53
$ git checkout iss53
You work on your website and ~do some commits. Doing so moves the iss53 branch forward, because you have it checked out ~that is, your HEAD is pointing to it~:
$ vim index.html
$ git commit -a -m 'Create new footer [issue 53]'
$ git checkout master
Switched to branch 'master'
$ git checkout -b hotfix
Switched to a new branch 'hotfix'
$ vim index.html
$ git commit -a -m 'Fix broken email address'
You can run your tests, make sure the hotfix is what you want, and finally merge the hotfix branch back into your
master branch to deploy to production. You ~do this with the git merge command:
$ git checkout master
$ git merge hotfix
Updating f42c576..3a0874c
Fast-forward
Youll notice the phrase 'fast-forward' in that merge. Because the commit C4 pointed to by the branch hotfix you
 merged in was directly ahead of the commit C2 youre on, Git simply moves the pointer forward. To phrase that
another way, when you try to merge one commit with a commit that can be reached by following the first commits history,
 Git simplifies things by moving the pointer forward because there is no divergent work
to merge together — this is called a 'fast-forward.'
After your super-important fix is deployed, youre ready to switch back to the work you were doing before you
 were interrupted. However, first youll delete the hotfix branch, because you no longer need it — the
master branch points at the same place. You can delete it with the -d option to git branch:
$ git branch -d hotfix
Now you can switch back to your work-in-progress branch on issue #53 and continue working on it.
$ git checkout iss53
Switched to branch "iss53"
$ vim index.html
$ git commit -a -m 'Finish the new footer [issue 53]'
$ git checkout master
Switched to branch 'master'
$ git merge iss53
Merge made by the 'recursive' strategy.
This looks a bit different than the hotfix merge you did earlier. In this case, your development history has diverged from
 some older point. Because the commit on the branch youre on isnt a direct ancestor of the branch youre merging in,
Git has to ~do some work. In this case, Git does a simple three-way merge, using the two snapshots pointed to by the
 branch tips and the common ancestor of the two.
$ git branch -d iss53

Basic Merge Conflicts
Occasionally- this process doesnt go smoothly. If you changed the same part of the same file differently in the
 two branches youre merging, Git wont be able to merge them cleanly.
$ git merge iss53
Auto-merging index.html
#CONFLICT (content): Merge conflict in index.html
Automatic merge failed; fix conflicts and ~then commit the result.
Git hasnt automatically created a new merge commit. It has paused the process while you resolve the conflict. If you want to
 see which files are unmerged at any point after a merge conflict, you can run git status:
$ git status
Anything that has merge conflicts and hasnt been resolved is listed as unmerged. Git adds standard conflict-resolution markers to the
 files that have conflicts, so you can open them manually and resolve those conflicts. Your file contains a section that looks something like this:
#<<<<<<< HEAD:index.html
#<div id="footer">contact : email.support@github.com</div>
#=======
#<div id="footer">
# please contact us at support@github.com
#</div>
#>>>>>>> iss53:index.html
This means the version in HEAD ~your master branch, because that was what you had checked out when you ran your merge command~ is the
 top part of that block ~everything above the =======~, while the version in your iss53 branch looks like everything in the
bottom part. In order to resolve the conflict, you have to either choose one side or the other or merge the contents yourself.
This resolution has a little of each section, and the
# <<<<<<<, =======, and >>>>>>>
lines have been completely removed. After youve resolved each of these sections in each conflicted file, run git add on
 each file to mark it as resolved. Staging the file marks it as resolved in Git.
~If you want to use a graphical tool to resolve these issues, you can run git mergetool, which fires up an
 appropriate visual merge tool and walks you through the conflicts:
$ git mergetool
Note- If you need more advanced tools for resolving tricky merge conflicts, we cover more on merging in Advanced Merging.
https://git-scm.com/book/en/v2/ch00/_advanced_merging
After you exit the merge tool, Git asks you if the merge was successful. If you tell the script that it was, it stages the
 file to mark it as resolved for you. You can run git status again to verify that all conflicts have been resolved:
$ git status
~If youre happy with that, and you verify that everything that had conflicts has been staged, you can type git commit to finalize the merge commit.

https://git-scm.com/book/en/v2/Git-Branching-Branch-Management
The git branch command does more than just create and delete branches. If you run it with no arguments, you get a simple listing of your current branches:
$ git branch
Notice the \* character that prefixes the master branch: it indicates the branch that you currently have checked out ~i.e., the
 branch that HEAD points to~. This means that if you commit at this point, the master branch will be
moved forward with your new work. To see the last commit on each branch, you can run git branch -v:
$ git branch -v
The useful --merged and --no-merged options can filter this list to branches that you have or have not yet merged into the
 branch youre currently on. To see which branches are already merged into the branch youre on, you can run git branch --merged:
$ git branch --merged
Branches on this list without the \* in front of them are generally fine to delete with git branch -d; youve already
 incorporated their work into another branch, so youre not going to lose anything.
To see all the branches that contain work you havent yet merged in, you can run git branch --no-merged:
$ git branch --no-merged
Tip- The options described above, --merged and --no-merged will, if not given a commit or branch name as an argument,
 show you what is, respectively, merged or not merged into your current branch.
You can always provide an additional argument to ask about the merge state with respect to some other branch without checking that
 other branch out first, as in, what is not merged into the master branch?
$ git checkout testing
$ git branch --no-merged master

Changing a branch name
Caution- Do not rename branches that are still in use by other collaborators. Do not rename a branch like
 master/main/mainline without having read the section Changing the master branch name.
Suppose you have a branch that is called bad-branch-name and you want to change it to corrected-branch-name, while keeping
 all history. You also want to change the branch name on the remote ~GitHub, GitLab, other server~. How ~do you ~do this?
Rename the branch locally with the git branch --move command:
$ git branch --move bad-branch-name corrected-branch-name
This replaces your bad-branch-name with corrected-branch-name, but this change is only local for now.
 To let others see the corrected branch on the remote, push it:
$ git push --set-upstream origin corrected-branch-name
Now well take a brief look at where we are now:
$ git branch --all
\* corrected-branch-name
  main
  remotes/origin/bad-branch-name
  remotes/origin/corrected-branch-name
  remotes/origin/main
Notice that youre on the branch corrected-branch-name and its available on the remote. However, the branch with the
 bad name is also still present there but you can delete it by executing the following command:
$ git push origin --delete bad-branch-name
Now the bad branch name is fully replaced with the corrected branch name.

Changing the master branch name
Warning- Changing the name of a branch like master/main/mainline/default will break the integrations, services, helper utilities and
 build/release scripts that your repository uses. Before you ~do this, make sure you consult with your collaborators.
Also- make sure you ~do a thorough search through your repo and update any references to the old branch name in your code and scripts.
Rename your local master branch into main with the following command:
$ git branch --move master main
Theres no local master branch anymore, because its renamed to the main branch.
To let others see the new main branch, you need to push it to the remote. This makes the renamed branch available on the remote.
$ git push --set-upstream origin main
Now we end up with the following state:
$ git branch --all
\* main
  remotes/origin/HEAD -> origin/master
  remotes/origin/main
  remotes/origin/master
Your local master branch is gone, as its replaced with the main branch. The main branch is present on the remote.
 However- the old master branch is still present on the remote. Other collaborators will continue to use the master branch as the
base of their work, until you make some further changes.
Now you have a few more tasks in front of you to complete the transition:
Any projects that depend on this one will need to update their code and/or configuration.
Update any test-runner configuration files.
Adjust build and release scripts.
Redirect settings on your repo host for things like the repos default branch, merge rules, and other things that match branch names.
Update references to the old branch in documentation.
Close or merge any pull requests that target the old branch.
After youve ~done all these tasks, and are certain the main branch performs just as the master branch, you can delete the master branch:
$ git push origin --delete master

https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows
Long-Running Branches
Because Git uses a simple three-way merge, merging from one branch into another multiple times over a long period is
 generally easy to do. This means you can have several branches that are always open and that you use for different stages of
your development cycle; you can merge regularly from some of them into others.
Again- having multiple long-running branches isnt necessary, but its often helpful, especially when youre dealing with very large or complex projects.

Topic Branches
Topic branches, however, are useful in projects of any size. A topic branch is a short-lived branch that you create and
 use for a single particular feature or related work. This is something youve likely never ~done with a VCS before because its
generally too expensive to create and merge branches. But in Git its common to create, work on, merge, and delete branches several times a day.

We will go into more detail about the various possible workflows for your Git project in Distributed Git, so before you
 decide which branching scheme your next project will use, be sure to read that chapter.
https://git-scm.com/book/en/v2/ch00/ch05-distributed-git
Its important to remember when youre doing all this that these branches are completely local. When youre branching and
 merging- everything is being ~done only in your Git repository — there is no communication with the server.

https://git-scm.com/book/en/v2/Git-Branching-Remote-Branches
Remote Branches
Remote references are references ~pointers~ in your remote repositories, including branches, tags, and so on. You can get a
 full list of remote references explicitly with
git ls-remote ~remote~, or
git remote show ~remote~ for remote branches as well as more information. Nevertheless, a more common way is to take advantage of remote-tracking branches.
Remote-tracking branches are references to the state of remote branches. Theyre local references that you cant move;
 Git moves them for you whenever you ~do any network communication, to make sure they accurately represent the state of the
remote repository. Think of them as bookmarks, to remind you where the branches in your remote repositories were the last time you connected to them.
Lets say you have a Git server on your network at git.ourcompany.com. If you clone from this, Git clone command automatically names it
 'origin' for you, pulls down all its data, creates a pointer to where its master branch is, and names it origin/master locally.
Git also gives you your own local master branch starting at the same place as origins master branch, so you have something to work from.
Note- 'origin' is not special. Just like the branch name 'master' does not have any special meaning in Git, neither does 'origin'. While 'master' is the
 default name for a starting branch when you run git init which is the only reason its widely used, 'origin' is the default name for a
remote when you run git clone. If you run git clone -o booyah instead, ~then you will have booyah/master as your default remote branch.
To synchronize your work with a given remote, you run a
 git fetch ~remote~ command ~in our case,
 git fetch origin~. This command looks up which server 'origin' is ~in this case, its git.ourcompany.com~, fetches any
data from it that you dont yet have, and updates your local database, moving your origin/master pointer to its new, more up-to-date position.

To demonstrate having multiple remote servers and what remote branches for those remote projects look like, lets assume you have
 another internal Git server that is used only for development by one of your sprint teams. This server is at git.team1.ourcompany.com.
You can add it as a new remote reference to the project youre currently working on by running the git remote add command as we
 covered in Git Basics. Name this remote teamone, which will be your shortname for that whole URL.
https://git-scm.com/book/en/v2/ch00/ch02-git-basics-chapter
Now- you can run git fetch teamone to fetch everything the remote teamone server has that you dont have yet. Because that
 server has a subset of the data your origin server has right now, Git fetches no data but sets a remote-tracking branch called
teamone/master to point to the commit that teamone has as its master branch.

Pushing
When you want to share a branch with the world, you need to push it up to a remote to which you have write access. Your local
 branches arent automatically synchronized to the remotes you write to — you have to explicitly push the branches you want to share.
That way, you can use private branches for work you dont want to share, and push up only the topic branches you want to collaborate on.
~If you have a branch named serverfix that you want to work on with others, you can push it up the same way you pushed your first branch. Run
 git push ~remote~ ~branch~:
$ git push origin serverfix
This is a bit of a shortcut. Git automatically expands the serverfix branchname out to refs/heads/serverfix:refs/heads/serverfix, which means,
 ~Take my serverfix local branch and push it to update the remotes serverfix branch.~ Well go over the refs/heads/ part in detail in Git Internals,
but you can generally leave it off. You can also ~do git push origin serverfix:serverfix, which does the same thing — it says,
 ~Take my serverfix and make it the remotes serverfix.~ You can use this format to push a local branch into a remote branch that is
named differently. If you didnt want it to be called serverfix on the remote, you could instead run
 git push origin serverfix:awesomebranch to push your local serverfix branch to the awesomebranch branch on the remote project.
Note- Dont type your password every time
~If youre using an HTTPS URL to push over, the Git server will ask you for your username and password for authentication.
 By default it will prompt you on the terminal for this information so the server can tell if youre allowed to push.
~If you dont want to type it every single time you push, you can set up a 'credential cache'. The simplest is just to
 keep it in memory for a few minutes, which you can easily set up by running
git config --global credential.helper cache.
~For more information on the various credential caching options available, see Credential Storage.
https://git-scm.com/book/en/v2/ch00/_credential_caching
The next time one of your collaborators fetches from the server, they will get a reference to where the servers version of
 serverfix is under the remote branch origin/serverfix:
$ git fetch origin
From https://github.com/schacon/simplegit
# * [new branch]      serverfix    -> origin/serverfix
Its important to note that when you ~do a fetch that brings down new remote-tracking branches, you dont automatically have local,
 editable copies of them. In other words, in this case, you dont have a new serverfix branch — you have only an
origin/serverfix pointer that you cant modify.
To merge this work into your current working branch, you can run
 git merge origin/serverfix. If you want your own serverfix branch that you can work on, you can base it off your remote-tracking branch:
$ git checkout -b serverfix origin/serverfix
 Branch serverfix set up to track remote branch serverfix from origin.
 Switched to a new branch 'serverfix'
This gives you a local branch that you can work on that starts where origin/serverfix is.

Tracking Branches
Checking out a local branch from a remote-tracking branch automatically creates what is called a 'tracking branch'
 ~and the branch it tracks is called an 'upstream branch'~. Tracking branches are local branches that have a
direct relationship to a remote branch. If youre on a tracking branch and type
 git pull, Git automatically knows which server to fetch from and which branch to merge in.
When you clone a repository, it generally automatically creates a master branch that tracks origin/master.
 However- you can set up other tracking branches if you wish — ones that track branches on other remotes, or
dont track the master branch. The simple case is the example you just saw, running
 git checkout -b ~branch~ ~remote~/~branch~. This is a common enough operation that Git provides the --track shorthand:
$ git checkout --track origin/serverfix
In fact, this is so common that theres even a shortcut for that shortcut. If the branch name youre trying to checkout
 a- doesnt exist and b- exactly matches a name on only one remote, Git will create a tracking branch for you:
$ git checkout serverfix
To set up a local branch with a different name than the remote branch, you can easily use the first version with a different local branch name:
$ git checkout -b sf origin/serverfix
~If you already have a local branch and want to set it to a remote branch you just pulled down, or want to change the
 upstream branch youre tracking, you can use the -u or --set-upstream-to option to git branch to explicitly set it at any time.
$ git branch -u origin/serverfix
Branch serverfix set up to track remote branch serverfix from origin.
Note- Upstream shorthand
When you have a tracking branch set up, you can reference its upstream branch with the
# @{upstream} or @{u} shorthand.
 So if youre on the master branch and its tracking origin/master, you can say something like
#git merge @{u} instead of
git merge origin/master if you wish.
~If you want to see what tracking branches you have set up, you can use the -vv option to git branch.
 This will list out your local branches with more information including what each branch is tracking and if your local branch is ahead, behind or both.
$ git branch -vv
Its important to note that these numbers are only since the last time you fetched from each server. This command does not
 reach out to the servers, its telling you about what it has cached from these servers locally. If you want totally up to date
ahead and behind numbers, youll need to fetch from all your remotes right before running this. You could ~do that like this:
$ git fetch --all; git branch -vv

Pulling
~While the
 git fetch command will fetch all the changes on the server that you dont have yet, it will not modify your
working directory at all. It will simply get the data for you and let you merge it yourself. However, there is a command called
 git pull which is essentially a
 git fetch immediately followed by a
 git merge in most cases. If you have a tracking branch set up as demonstrated in the last section, either by
explicitly setting it or by having it created for you by the clone or checkout commands,
 git pull will look up what server and branch your current branch is tracking, fetch from that server and ~then try to merge in that remote branch.
Generally its better to simply use the fetch and merge commands explicitly as the magic of git pull can often be confusing.

Deleting Remote Branches
Suppose youre ~done with a remote branch — say you and your collaborators are finished with a feature and have
 merged it into your remotes master branch ~or whatever branch your stable codeline is in~. You can delete a
remote branch using the --delete option to git push. If you want to delete your serverfix branch from the server, you run the following:
$ git push origin --delete serverfix
Basically all this does is to remove the pointer from the server. The Git server will generally keep the data there for a while until a
 garbage collection runs, so if it was accidentally deleted, its often easy to recover.

https://git-scm.com/book/en/v2/Git-Branching-Rebasing
Rebasing
In Git, there are two main ways to integrate changes from one branch into another: the merge and the rebase.
The Basic Rebase
~If you go back to an earlier example from Basic Merging, you can see that you diverged your work and made commits on two different branches.
The easiest way to integrate the branches, as weve already covered, is the merge command. It performs a three-way merge between the
 two latest branch snapshots ~C3 and C4~ and the most recent common ancestor of the two ~C2~, creating a new snapshot ~and commit~.
However- there is another way: you can take the patch of the change that was introduced in C4 and reapply it on top of C3.
 In Git, this is called rebasing. With the rebase command, you can take all the changes that were committed on one branch and replay them on a different branch.
~For this example, you would check out the experiment branch, and ~then rebase it onto the master branch as follows:
$ git checkout experiment
$ git rebase master
This operation works by going to the common ancestor of the two branches ~the one youre on and the one youre rebasing onto~,
 getting the diff introduced by each commit of the branch youre on, saving those diffs to temporary files, resetting the
current branch to the same commit as the branch you are rebasing onto, and finally applying each change in turn.
At this point, you can go back to the master branch and ~do a fast-forward merge.
$ git checkout master
$ git merge experiment
Now- the snapshot pointed to by C4~ is exactly the same as the one that was pointed to by C5 in the merge example.
 There is no difference in the end product of the integration, but rebasing makes for a cleaner history. If you examine the
log of a rebased branch, it looks like a linear history: it appears that all the work happened in series, even when it originally happened in parallel.
Often- youll ~do this to make sure your commits apply cleanly on a remote branch — perhaps in a project to
 which youre trying to contribute but that you dont maintain. In this case, youd ~do your work in a branch and ~then
rebase your work onto origin/master when you were ready to submit your patches to the main project. That way, the
 maintainer doesnt have to ~do any integration work — just a fast-forward or a clean apply.
Note that the snapshot pointed to by the final commit you end up with, whether its the last of the rebased commits for a
 rebase or the final merge commit after a merge, is the same snapshot — its only the history that is different.
Rebasing replays changes from one line of work onto another in the order they were introduced,
 whereas merging takes the endpoints and merges them together.

More Interesting Rebases
You can also have your rebase replay on something other than the rebase target branch. Take a history like A history with a
 topic branch off another topic branch, for example. You branched a topic branch ~server~ to add some server-side functionality to
your project, and made a commit. Then, you branched off that to make the client-side changes ~client~ and committed a
 few times. Finally, you went back to your server branch and did a few more commits.
Suppose you decide that you want to merge your client-side changes into your mainline for a release, but you want to
 hold off on the server-side changes until its tested further. You can take the changes on client that arent on server
~C8 and C9~ and replay them on your master branch by using the --onto option of git rebase:
$ git rebase --onto master server client
This basically says, ~Take the client branch, figure out the patches since it diverged from the server branch, and
 replay these patches in the client branch as if it was based directly off the master branch instead.~ Its a bit complex, but the result is pretty cool.
Now you can fast-forward your master branch ~see Fast-forwarding your master branch to include the client branch changes~:
$ git checkout master
$ git merge client
Lets say you decide to pull in your server branch as well. You can rebase the server branch onto the master branch without having to
 check it out first by running
git rebase ~basebranch~ ~topicbranch~ — which checks out the topic branch ~in this case, server~ for you and replays it
 onto the base branch ~master~:
$ git rebase master server
This replays your server work on top of your master work, as shown in Rebasing your server branch on top of your master branch.
Then- you can fast-forward the base branch ~master~:
$ git checkout master
$ git merge server
You can remove the client and server branches because all the work is integrated and you dont need them anymore,
 leaving your history for this entire process looking like Final commit history:
$ git branch -d client
$ git branch -d server

The Perils of Rebasing
Ahh- but the bliss of rebasing isnt without its drawbacks, which can be summed up in a single line:
~Do not rebase commits that exist outside your repository and that people may have based work on.
~If you follow that guideline, youll be fine. If you dont, people will hate you, and youll be scorned by friends and family.
When you rebase stuff, youre abandoning existing commits and creating new ones that are similar but different.
 ~If you push commits somewhere and others pull them down and base work on them, and ~then you rewrite those commits with
git rebase and push them up again, your collaborators will have to re-merge their work and things will get messy when
 you try to pull their work back into yours.

Rebase When You Rebase
~If you ~do find yourself in a situation like this, Git has some further magic that might help you out. If someone on your
 team force pushes changes that overwrite work that youve based work on, your challenge is to figure out what is yours and what theyve rewritten.
It turns out that in addition to the commit SHA-1 checksum, Git also calculates a checksum that is based just on the
 patch introduced with the commit. This is called a 'patch-id'.
~If you pull down work that was rewritten and rebase it on top of the new commits from your partner, Git can often
 successfully figure out what is uniquely yours and apply them back on top of the new branch.
You can also simplify this by running a
 git pull --rebase instead of a normal git pull. Or you could ~do it manually with a git fetch followed by a
 git rebase teamone/master in this case.
~If you are using git pull and want to make --rebase the default, you can set the pull.rebase config value with something like
 git config --global pull.rebase true.
~If you only ever rebase commits that have never left your own computer, youll be just fine. If you rebase commits that
 have been pushed, but that no one else has based commits from, youll also be fine. If you rebase commits that have
already been pushed publicly, and people may have based work on those commits, ~then you may be in for some frustrating trouble, and the scorn of your teammates.
~If you or a partner does find it necessary at some point, make sure everyone knows to run
 git pull --rebase to try to make the pain after it happens a little bit simpler.

Rebase vs. Merge
Now that youve seen rebasing and merging in action, you may be wondering which one is better. Before we can answer this,
 lets step back a bit and talk about what history means.
One point of view on this is that your repositorys commit history is a record of what actually happened. Its a
 historical document, valuable in its own right, and shouldnt be tampered with. From this angle, changing the commit history is
almost blasphemous; youre lying about what actually transpired. So what if there was a messy series of merge commits?
 Thats how it happened, and the repository should preserve that for posterity.
The opposing point of view is that the commit history is the story of how your project was made. You wouldnt publish the
 first draft of a book, so why show your messy work? When youre working on a project, you may need a record of all your
missteps and dead-end paths, but when its time to show your work to the world, you may want to tell a more coherent story of
 how to get from A to B. People in this camp use tools like rebase and filter-branch to rewrite their commits before theyre
merged into the mainline branch. They use tools like rebase and filter-branch, to tell the story in the way thats best for future readers.
Now- to the question of whether merging or rebasing is better: hopefully youll see that its not that simple. Git is a
 powerful tool, and allows you to ~do many things to and with your history, but every team and every project is different.
Now that you know how both of these things work, its up to you to decide which one is best for your particular situation.
You can get the best of both worlds: rebase local changes before pushing to clean up your work, but never rebase anything that youve pushed somewhere.

https://git-scm.com/book/en/v2/Git-on-the-Server-The-Protocols
Git on the Server - The Protocols
In order to ~do any collaboration in Git, youll need to have a remote Git repository. Although you can technically
 push changes to and pull changes from individual repositories, doing so is discouraged because you can fairly easily
confuse what theyre working on if youre not careful. Furthermore, you want your collaborators to be able to access the
 repository even if your computer is offline — having a more reliable common repository is often useful.
Therefore- the preferred method for collaborating with someone is to set up an intermediate repository that you both have
 access to, and push to and pull from that.
Running a Git server is fairly straightforward. First, you choose which protocols you want your server to support.
A remote repository is generally a bare repository — a Git repository that has no working directory. Because the repository is
 only used as a collaboration point, there is no reason to have a snapshot checked out on disk; its just the Git data.
In the simplest terms, a bare repository is the contents of your projects .git directory and nothing else.

The Protocols
Git can use four distinct protocols to transfer data:
 Local~ HTTP, Secure Shell ~SSH~ and Git. Here well discuss what they are and in what basic circumstances you would want ~or not want~ to use them.

https://git-scm.com/book/en/v2/Git-on-the-Server-Getting-Git-on-a-Server
In order to initially set up any Git server, you have to export an existing repository into a new bare repository — a repository that
 doesnt contain a working directory. This is generally straightforward to do. In order to clone your repository to create a
new bare repository, you run the clone command with the --bare option. By convention, bare repository directory names end with the suffix .git, like so:
$ git clone --bare my_project my_project.git
Cloning into bare repository 'my_project.git'...done.
You should now have a copy of the Git directory data in your my_project.git directory.
This is roughly equivalent to something like:
$ cp -Rf my_project/.git my_project.git
There are a couple of minor differences in the configuration file but, for your purpose, this is close to the same thing.
 It takes the Git repository by itself, without a working directory, and creates a directory specifically for it alone.

https://git-scm.com/book/en/v2/Distributed-Git-Distributed-Workflows
Distributed Workflows
In contrast with Centralized Version Control Systems, the distributed nature of Git allows you to be far more flexible in
 how developers collaborate on projects. In centralized systems, every developer is a node working more or less equally with a
central hub. In Git, however, every developer is potentially both a node and a hub; that is, every developer can both contribute code to
 other repositories and maintain a public repository on which others can base their work and which they can contribute to.
This presents a vast range of workflow possibilities for your project and/or your team

Centralized Workflow
In centralized systems, there is generally a single collaboration model — the centralized workflow. One central hub,
 or repository, can accept code, and everyone synchronizes their work with it. A number of developers are
nodes — consumers of that hub — and synchronize with that centralized location.
This means that if two developers clone from the hub and both make changes, the first developer to push their changes back up can ~do so
 with no problems. The second developer must merge in the first ones work before pushing changes up, so as not to overwrite the
first developers changes. This concept is as true in Git as it is in Subversion or any CVCS, and this model works perfectly well in Git.
~If you are already comfortable with a centralized workflow in your company or team, you can easily continue using that
 workflow with Git. Simply set up a single repository, and give everyone on your team push access; Git wont let users overwrite each other.
Say John and Jessica both start working at the same time. John finishes his change and pushes it to the server. Then Jessica tries to
 push her changes, but the server rejects them. She is told that shes trying to push non-fast-forward changes and that
she wont be able to ~do so until she fetches and merges. This workflow is attractive to a lot of people because its a
 paradigm that many are familiar and comfortable with.
This is also not limited to small teams. With Gits branching model, its possible for hundreds of developers to
 successfully work on a single project through dozens of branches simultaneously.

Integration-Manager Workflow
Because Git allows you to have multiple remote repositories, its possible to have a workflow where each developer has
 write access to their own public repository and read access to everyone elses. This scenario often includes a
canonical repository that represents the 'official' project. To contribute to that project, you create your own public clone of the
 project and push your changes to it. Then, you can send a request to the maintainer of the main project to pull in your changes.
The maintainer can ~then add your repository as a remote, test your changes locally, merge them into their branch, and
 push back to their repository. The process works as follows:
The project maintainer pushes to their public repository.
A contributor clones that repository and makes changes.
The contributor pushes to their own public copy.
The contributor sends the maintainer an email asking them to pull changes.
The maintainer adds the contributors repository as a remote and merges locally.
The maintainer pushes merged changes to the main repository.
This is a very common workflow with hub-based tools like GitHub or GitLab, where its easy to fork a project and
 push your changes into your fork for everyone to see. One of the main advantages of this approach is that you can continue to
work- and the maintainer of the main repository can pull in your changes at any time. Contributors dont have to wait for the
 project to incorporate their changes — each party can work at their own pace.

Dictator and Lieutenants Workflow
This is a variant of a multiple-repository workflow. Its generally used by huge projects with hundreds of collaborators;
 one famous example is the Linux kernel. Various integration managers are in charge of certain parts of the repository;
theyre called lieutenants. All the lieutenants have one integration manager known as the benevolent dictator.
 The benevolent dictator pushes from their directory to a reference repository from which all the collaborators need to pull.
The process works like this:
Regular developers work on their topic branch and rebase their work on top of master. The master branch is that of the
 reference repository to which the dictator pushes.
Lieutenants merge the developers topic branches into their master branch.
The dictator merges the lieutenants master branches into the dictators master branch.
Finally- the dictator pushes that master branch to the reference repository so the other developers can rebase on it.
This kind of workflow isnt common, but can be useful in very big projects, or in highly hierarchical environments.
 It allows the project leader ~the dictator~ to delegate much of the work and collect large subsets of code at multiple points before integrating them.

Patterns for Managing Source Code Branches
Note- Martin Fowler has made a guide 'Patterns for Managing Source Code Branches'. This guide covers all the
 common Git workflows, and explains how/when to use them. Theres also a section comparing high and low integration frequencies.
https://martinfowler.com/articles/branching-patterns.html

https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project
 Distributed Git - Contributing to a Project
Contributing to a Project
The main difficulty with describing how to contribute to a project are the numerous variations on how to ~do that.
 Because Git is very flexible, people can and ~do work together in many ways, and its problematic to describe how you
should contribute — every project is a bit different. Some of the variables involved are active contributor count,
 chosen workflow, your commit access, and possibly the external contribution method.
The first variable is active contributor count — how many users are actively contributing code to this project, and
 how often? In many instances, youll have two or three developers with a few commits a day, or possibly less for somewhat
dormant projects. For larger companies or projects, the number of developers could be in the thousands, with hundreds or
 thousands of commits coming in each day. This is important because with more and more developers, you run into more issues with
making sure your code applies cleanly or can be easily merged. Changes you submit may be rendered obsolete or severely broken by
 work that is merged in while you were working or while your changes were waiting to be approved or applied. How can you
keep your code consistently up to date and your commits valid?
The next variable is the workflow in use for the project. Is it centralized, with each developer having equal write access to the
 main codeline? Does the project have a maintainer or integration manager who checks all the patches? Are all the patches
peer-reviewed and approved? Are you involved in that process? Is a lieutenant system in place, and ~do you have to submit your work to them first?
The next variable is your commit access. The workflow required in order to contribute to a project is much different if you have
 write access to the project than if you dont. If you dont have write access, how does the project prefer to accept contributed work?
Does it even have a policy? How much work are you contributing at a time? How often ~do you contribute?
All these questions can affect how you contribute effectively to a project and what workflows are preferred or available to you.

Commit Guidelines
First- your submissions should not contain any whitespace errors. Git provides an easy way to check for this — before you commit, run
 git diff --check, which identifies possible whitespace errors and lists them for you.
https://git-scm.com/book/en/v2/ch00/_interactive_staging
https://git-scm.com/book/en/v2/ch00/_rewriting_history
https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

Private Small Team
The simplest setup youre likely to encounter is a private project with one or two other developers. 'Private,' in this context,
 means closed-source — not accessible to the outside world. You and the other developers all have push access to the repository.
In this environment, you can follow a workflow similar to what you might ~do when using Subversion or another centralized system.
 You still get the advantages of things like offline committing and vastly simpler branching and merging, but the workflow can be
very similar; the main difference is that merges happen client-side rather than on the server at commit time.
$ git log --no-merges issue54..origin/master
The issue54..origin/master syntax is a log filter that asks Git to display only those commits that are on the latter branch
 ~in this case origin/master~ and that are not on the first branch ~in this case issue54~. Well go over this syntax in detail in Commit Ranges.
https://git-scm.com/book/en/v2/ch00/_commit_ranges

Private Managed Team
Youll learn how to work in an environment where small groups collaborate on features, after which those team-based contributions are integrated by another party.
$ git checkout -b featureA
$ git push -u origin featureA
$ git push -u origin featureB:featureBee
This is called a refspec. See The Refspec for a more detailed discussion of Git refspecs and different things you can ~do with them.
 Also notice the -u flag; this is short for --set-upstream, which configures the branches for easier pushing and pulling later.
https://git-scm.com/book/en/v2/ch00/_refspec
$ git log featureA..origin/featureA

Forked Public Project
Contributing to public projects is a bit different. Because you dont have the permissions to directly update branches on the
 project- you have to get the work to the maintainers some other way. This first example describes contributing via forking on
Git hosts that support easy forking. Many hosting sites support this ~including GitHub, BitBucket, repo.or.cz, and others~, and
 many project maintainers expect this style of contribution. The next section deals with projects that prefer to accept contributed patches via email.
First- youll probably want to clone the main repository, create a topic branch for the patch or patch series youre planning to
 contribute- and ~do your work there. The sequence looks basically like this:
$ git clone ~url~
$ cd project
$ git checkout -b featureA
#  ... work ...
$ git commit
#  ... work ...
$ git commit
Note- You may want to use rebase -i to squash your work down to a single commit, or rearrange the work in the commits to
 make the patch easier for the maintainer to review — see Rewriting History for more information about interactive rebasing.
https://git-scm.com/book/en/v2/ch00/_rewriting_history
When your branch work is finished and youre ready to contribute it back to the maintainers, go to the original project page and
 click the 'Fork' button, creating your own writable fork of the project. You ~then need to add this repository URL as a
new remote of your local repository; in this example, lets call it myfork:
$ git remote add myfork ~url~
You ~then need to push your new work to this repository. Its easiest to push the topic branch youre working on to your
 forked repository, rather than merging that work into your master branch and pushing that. The reason is that if your
work isnt accepted or is cherry-picked, you dont have to rewind your master branch ~the Git cherry-pick operation is covered in
 more detail in Rebasing and Cherry-Picking Workflows~. If the maintainers merge, rebase, or cherry-pick your work,
youll eventually get it back via pulling from their repository anyhow.
https://git-scm.com/book/en/v2/ch00/_rebase_cherry_pick
In any event, you can push your work with:
$ git push -u myfork featureA
Once your work has been pushed to your fork of the repository, you need to notify the maintainers of the original project that
 you have work youd like them to merge. This is often called a pull request, and you typically generate such a request either
via the website — GitHub has its own 'Pull Request' mechanism that well go over in GitHub — or you can run the
 git request-pull command and email the subsequent output to the project maintainer manually.
https://git-scm.com/book/en/v2/ch00/ch06-github
The git request-pull command takes the base branch into which you want your topic branch pulled and the Git repository URL you
 want them to pull from, and produces a summary of all the changes youre asking to be pulled. For instance, if Jessica wants to
send John a pull request, and shes ~done two commits on the topic branch she just pushed, she can run this:
$ git request-pull origin/master myfork
This output can be sent to the maintainer — it tells them where the work was branched from, summarizes the commits,
 and identifies from where the new work is to be pulled.
On a project for which youre not the maintainer, its generally easier to have a branch like master always track origin/master and
 to ~do your work in topic branches that you can easily discard if theyre rejected. Having work themes isolated into
topic branches also makes it easier for you to rebase your work if the tip of the main repository has moved in the
 meantime and your commits no longer apply cleanly.
~if you want to submit a second topic of work to the project, dont continue working on the topic branch you just
 pushed up — start over from the main repositorys master branch:
$ git checkout -b featureB origin/master
#  ... work ...
$ git commit
$ git push myfork featureB
$ git request-pull origin/master myfork
#  ... email generated request pull to maintainer ...
$ git fetch origin
Now- each of your topics is contained within a silo — similar to a patch queue — that you can rewrite, rebase, and
 modify without the topics interfering or interdepending on each other
Lets say the project maintainer has pulled in a bunch of other patches and tried your first branch, but it no longer cleanly merges.
 In this case, you can try to rebase that branch on top of origin/master, resolve the conflicts for the maintainer, and ~then resubmit your changes:
$ git checkout featureA
$ git rebase origin/master
$ git push -f myfork featureA
This rewrites your history to now look like Commit history after featureA work.
Because you rebased the branch, you have to specify the -f to your push command in order to be able to replace the
 featureA branch on the server with a commit that isnt a descendant of it. An alternative would be to push this new work to a
different branch on the server ~perhaps called featureAv2~.
Lets look at one more possible scenario: the maintainer has looked at work in your second branch and likes the concept but
 would like you to change an implementation detail. Youll also take this opportunity to move the work to be based off the
projects current master branch. You start a new branch based off the current origin/master branch, squash the
 featureB changes there, resolve any conflicts, make the implementation change, and ~then push that as a new branch:
$ git checkout -b featureBv2 origin/master
$ git merge --squash featureB
#  ... change implementation ...
$ git commit
$ git push myfork featureBv2
The --squash option takes all the work on the merged branch and squashes it into one changeset producing the
 repository state as if a real merge happened, without actually making a merge commit. This means your future commit will
have one parent only and allows you to introduce all the changes from another branch and ~then make more changes before
 recording the new commit. Also the --no-commit option can be useful to delay the merge commit in case of the default merge process.
At this point, you can notify the maintainer that youve made the requested changes, and that they can find those changes in your featureBv2 branch.

https://git-scm.com/book/en/v2/Distributed-Git-Maintaining-a-Project
Maintaining a Project
In addition to knowing how to contribute effectively to a project, youll likely need to know how to maintain one.
 This can consist of accepting and applying patches generated via format-patch and emailed to you, or integrating changes in
remote branches for repositories youve added as remotes to your project. Whether you maintain a canonical repository or
 want to help by verifying or approving patches, you need to know how to accept work in a way that is clearest for other
contributors and sustainable by you over the long run.

Working in Topic Branches
When youre thinking of integrating new work, its generally a good idea to try it out in a topic branch — a
 temporary branch specifically made to try out that new work. This way, its easy to tweak a patch individually and
leave it if its not working until you have time to come back to it. If you create a simple branch name based on the
 theme of the work youre going to try, such as ruby_client or something similarly descriptive, you can easily remember it if
you have to abandon it for a while and come back later. The maintainer of the Git project tends to namespace these
 branches as well — such as sc/ruby_client, where sc is short for the person who contributed the work.
As youll remember, you can create the branch based off your master branch like this:
$ git branch sc/ruby_client master
Or- if you want to also switch to it immediately, you can use the checkout -b option:
$ git checkout -b sc/ruby_client master
Now youre ready to add the contributed work that you received into this topic branch and determine if you want to
 merge it into your longer-term branches.

Checking Out Remote Branches
~If your contribution came from a Git user who set up their own repository, pushed a number of changes into it, and ~then
  sent you the URL to the repository and the name of the remote branch the changes are in, you can add them as a remote and ~do merges locally.
~For instance, if Jessica sends you an email saying that she has a great new feature in the ruby-client branch of her repository,
 you can test it by adding the remote and checking out that branch locally:
$ git remote add jessica https://github.com/jessica/myproject.git
$ git fetch jessica
$ git checkout -b rubyclient jessica/ruby-client
~If she emails you again later with another branch containing another great feature, you could directly fetch and
 checkout because you already have the remote setup.
~If you arent working with a person consistently but still want to pull from them in this way, you can provide the URL of the
 remote repository to the git pull command. This does a one-time pull and doesnt save the URL as a remote reference:
$ git pull https://github.com/onetimeguy/project

Determining What Is Introduced
Now you have a topic branch that contains contributed work. At this point, you can determine what youd like to ~do with it.
Its often helpful to get a review of all the commits that are in this branch but that arent in your master branch.
 You can exclude commits in the master branch by adding the --not option before the branch name. This does the same thing as the
master..contrib format that we used earlier. For example, if your contributor sends you two patches and you create a
 branch called contrib and applied those patches there, you can run this:
$ git log contrib --not master
To see what changes each commit introduces, remember that you can pass the -p option to git log and it will append the diff introduced to each commit.
To see a full diff of what would happen if you were to merge this topic branch with another branch, you may have to
 use a weird trick to get the correct results. You may think to run this:
$ git diff master
This command gives you a diff, but it may be misleading. If your master branch has moved forward since you created the
 topic branch from it, ~then youll get seemingly strange results. This happens because Git directly compares the snapshots of the
last commit of the topic branch youre on and the snapshot of the last commit on the master branch. For example, if youve added a
 line in a file on the master branch, a direct comparison of the snapshots will look like the topic branch is going to remove that line.
~If master is a direct ancestor of your topic branch, this isnt a problem; but if the two histories have diverged, the
 diff will look like youre adding all the new stuff in your topic branch and removing everything unique to the master branch.
What you really want to see are the changes added to the topic branch — the work youll introduce if you merge this
 branch with master. You ~do that by having Git compare the last commit on your topic branch with the first common ancestor it has with the master branch.
Technically- you can ~do that by explicitly figuring out the common ancestor and ~then running your diff on it:
$ git merge-base contrib master
36c7dba2c95e6bbb78dfa822519ecfec6e1ca649
$ git diff 36c7db
or- more concisely:
$ git diff "$(git merge-base contrib master)"
However- neither of those is particularly convenient, so Git provides another shorthand for doing the same thing:
 the triple-dot syntax. In the context of the git diff command, you can put three periods after another branch to ~do a
diff between the last commit of the branch youre on and its common ancestor with another branch:
$ git diff master...contrib
This command shows you only the work your current topic branch has introduced since its common ancestor with master.

Rebasing and Cherry-Picking Workflows
Other maintainers prefer to rebase or cherry-pick contributed work on top of their master branch, rather than merging it in,
 to keep a mostly linear history. When you have work in a topic branch and have determined that you want to integrate it,
you move to that branch and run the rebase command to rebuild the changes on top of your current master ~or develop, and so on~ branch. If that
 works well, you can fast-forward your master branch, and youll end up with a linear project history.
The other way to move introduced work from one branch to another is to cherry-pick it. A cherry-pick in Git is like a
 rebase for a single commit. It takes the patch that was introduced in a commit and tries to reapply it on the branch youre currently on.
This is useful if you have a number of commits on a topic branch and you want to integrate only one of them, or if you
 only have one commit on a topic branch and youd prefer to cherry-pick it rather than run rebase.
~If you want to pull commit e43a6 into your master branch, you can run:
$ git cherry-pick e43a6
Finished one cherry-pick.
#[master]: created a0a41a9: "More friendly message when locking the index fails."
This pulls the same change introduced in e43a6, but you get a new commit SHA-1 value, because the date applied is different.

Rerere
~If youre doing lots of merging and rebasing, or youre maintaining a long-lived topic branch, Git has a feature called 'rerere' that can help.
Rerere stands for 'reuse recorded resolution' — its a way of shortcutting manual conflict resolution. When rerere is enabled,
 Git will keep a set of pre- and post-images from successful merges, and if it notices that theres a conflict that
looks exactly like one youve already fixed, itll just use the fix from last time, without bothering you with it.
This feature comes in two parts: a configuration setting and a command. The configuration setting is rerere.enabled,
 and its handy enough to put in your global config:
$ git config --global rerere.enabled true
Now- whenever you ~do a merge that resolves conflicts, the resolution will be recorded in the cache in case you need it in the future.

Tagging Your Releases
When youve decided to cut a release, youll probably want to assign a tag so you can re-create that release at any
 point going forward. You can create a new tag as discussed in Git Basics. If you decide to sign the tag as the maintainer,
the tagging may look something like this:
$ git tag -s v1.5 -m 'my signed 1.5 tag'

Generating a Build Number
Because Git doesnt have monotonically increasing numbers like 'v123' or the equivalent to go with each commit, if you want to
 have a human-readable name to go with a commit, you can run git describe on that commit. In response, Git generates a
string consisting of the name of the most recent tag earlier than that commit, followed by the number of commits since that tag,
 followed finally by a partial SHA-1 value of the commit being described ~prefixed with the letter "g" meaning Git~:
$ git describe master
v1.6.2-rc1-20-g8c5b85c

Preparing a Release
Now you want to release a build. One of the things youll want to ~do is create an archive of the latest snapshot of your code for
 those poor souls who dont use Git. The command to ~do this is git archive:
#$ git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
~If someone opens that tarball, they get the latest snapshot of your project under a project directory. You can also
 create a zip archive in much the same way, but by passing the --format=zip option to git archive:
#$ git archive master --prefix='project/' --format=zip > `git describe master`.zip
You now have a nice tarball and a zip archive of your project release that you can upload to your website or email to people.

The Shortlog
Its time to email your mailing list of people who want to know whats happening in your project. A nice way of quickly
 getting a sort of changelog of what has been added to your project since your last release or email is to use the
git shortlog command. It summarizes all the commits in the range you give it, for example, the following gives you a
 summary of all the commits since your last release, if your last release was named v1.0.1:
$ git shortlog --no-merges master --not v1.0.1

The GitHub Flow
GitHub is designed around a particular collaboration workflow, centered on Pull Requests. This flow works whether youre
 collaborating with a tightly-knit team in a single shared repository, or a globally-distributed company or network of
strangers contributing to a project through dozens of forks. It is centered on the Topic Branches workflow covered in Git Branching.
Heres how it generally works:
Fork the project.
Create a topic branch from master.
Make some commits to improve the project.
Push this branch to your GitHub project.
Open a Pull Request on GitHub.
Discuss- and optionally continue committing.
The project owner merges or closes the Pull Request.
Sync the updated master back to your fork.
This is basically the Integration Manager workflow covered in Integration-Manager Workflow, but instead of using email to
 communicate and review changes, teams use GitHubs web based tools.
Lets walk through an example of proposing a change to an open source project hosted on GitHub using this flow.
Tip - You can use the official GitHub CLI tool instead of the GitHub web interface for most things. The tool can be
 used on Windows, macOS, and Linux systems. Go to the GitHub CLI homepage for installation instructions and the manual.
https://cli.github.com

https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection
Revision Selection
Git allows you to refer to a single commit, set of commits, or range of commits in a number of ways.
 They arent necessarily obvious but are helpful to know.

Single Revisions
You can obviously refer to any single commit by its full, 40-character SHA-1 hash, but there are more human-friendly ways to
 refer to commits as well. This section outlines the various ways you can refer to any commit.
Short SHA-1
Git is smart enough to figure out what commit youre referring to if you provide the first few characters of the SHA-1 hash,
 as long as that partial hash is at least four characters long and unambiguous; that is, no other object in the object database can
have a hash that begins with the same prefix.
~For example, to examine a specific commit where you know you added certain functionality, you might first run the git log command to locate the commit:
$ git log
In this case, say youre interested in the commit whose hash begins with 1c002dd…​. You can inspect that commit with any of the
 following variations of git show ~assuming the shorter versions are unambiguous~:
$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
$ git show 1c002dd4b536e7479f
$ git show 1c002d
Git can figure out a short, unique abbreviation for your SHA-1 values. If you pass --abbrev-commit to the git log command,
 the output will use shorter values but keep them unique; it defaults to using seven characters but makes them longer if necessary to keep the SHA-1 unambiguous:
$ git log --abbrev-commit --pretty=oneline
ca82a6d Change the version number
085bb3b Remove unnecessary test code
a11bef0 Initial commit

Branch References
One straightforward way to refer to a particular commit is if its the commit at the tip of a branch; in that case,
 you can simply use the branch name in any Git command that expects a reference to a commit. For instance, if you want to
examine the last commit object on a branch, the following commands are equivalent, assuming that the topic1 branch points to commit ca82a6d…​:
$ git show ca82a6dff817ec66f44342007202690a93763949
$ git show topic1
~If you want to see which specific SHA-1 a branch points to, or if you want to see what any of these examples boils down to in terms of SHA-1s,
 you can use a Git plumbing tool called rev-parse. You can see Git Internals for more information about plumbing tools;
basically- rev-parse exists for lower-level operations and isnt designed to be used in day-to-day operations. However, it can be
 helpful sometimes when you need to see whats really going on. Here you can run rev-parse on your branch.
$ git rev-parse topic1
ca82a6dff817ec66f44342007202690a93763949

RefLog Shortnames
One of the things Git does in the background while youre working away is keep a 'reflog' — a log of where your HEAD and
 branch references have been for the last few months.
You can see your reflog by using git reflog:
$ git reflog
Every time your branch tip is updated for any reason, Git stores that information for you in this temporary history.
 You can use your reflog data to refer to older commits as well. For example, if you want to see the fifth prior value of the
HEAD of your repository, you can use the "@{5}" reference that you see in the reflog output:
$ "git show HEAD@{5}"
You can also use this syntax to see where a branch was some specific amount of time ago. For instance, to see where
 your master branch was yesterday, you can type:
$ "git show master@{yesterday}"
That would show you where the tip of your master branch was yesterday. This technique only works for data thats still in
 your reflog, so you cant use it to look for commits older than a few months.
To see reflog information formatted like the git log output, you can run git log -g:
$ git log -g master
Its important to note that reflog information is strictly local — its a log only of what youve ~done in your repository.
 The references wont be the same on someone elses copy of the repository; also- right after you initially clone a repository,
youll have an empty reflog, as no activity has occurred yet in your repository.

Ancestry References
The other main way to specify a commit is via its ancestry. If you place a ^ ~caret~ at the end of a reference, Git resolves it to
 mean the parent of that commit. Suppose you look at the history of your project:
$ git log --pretty=format:'%h %s' --graph
Then- you can see the previous commit by specifying HEAD^, which means 'the parent of HEAD':
$ git show HEAD^
You can also specify a number after the ^ to identify which parent you want;
 ~for example, d921970^2 means 'the second parent of d921970.' This syntax is useful only for merge commits, which have
more than one parent — the first parent of a merge commit is from the branch you were on when
 you merged ~frequently master~, while the second parent of a merge commit is from the branch that was merged ~say, topic~:
The other main ancestry specification is the ~ tilde. This also refers to the first parent, so HEAD~ and HEAD^ are equivalent.
 The difference becomes apparent when you specify a number. HEAD~2 means 'the first parent of the first parent,' or
'the grandparent' — it traverses the first parents the number of times you specify. For example, in the history listed earlier, HEAD~3 would be:
$ git show HEAD~3
This can also be written HEAD~~~, which again is the first parent of the first parent of the first parent:
$ git show HEAD~~~
You can also combine these syntaxes — you can get the second parent of the
 previous reference ~assuming it was a merge commit~ by using HEAD~3^2, and so on.

Commit Ranges
Now that you can specify individual commits, lets see how to specify ranges of commits. This is particularly useful for
 managing your branches — if you have a lot of branches, you can use range specifications to answer questions such as,
'What work is on this branch that I havent yet merged into my main branch?'

Double Dot
The most common range specification is the double-dot syntax. This basically asks Git to resolve a range of commits that
 are reachable from one commit but arent reachable from another.
You can ask Git to show you a log of just those commits with master..experiment — that means 'all commits reachable from experiment that arent reachable from master.'
$ 'git log master..experiment'
If- on the other hand, you want to see the opposite — all commits in master that arent in experiment — you can reverse the
 branch names. experiment..master shows you everything in master not reachable from experiment:
$ 'git log experiment..master'
Another frequent use of this syntax is to see what youre about to push to a remote:
$ git log origin/master..HEAD
This command shows you any commits in your current branch that arent in the master branch on your origin remote. If you run a
 git push and your current branch is tracking origin/master, the commits listed by git log origin/master..HEAD are the
commits that will be transferred to the server. You can also leave off one side of the syntax to have Git assume HEAD. For example,
 you can get the same results as in the previous example by typing git log origin/master.. — Git substitutes HEAD if one side is missing.

Multiple Points
The double-dot syntax is useful as a shorthand, but perhaps you want to specify more than two branches to indicate your revision,
 such as seeing what commits are in any of several branches that arent in the branch youre currently on. Git allows you to do-
this by using either the ^ character or --not before any reference from which you dont want to see reachable commits. Thus, the
 following three commands are equivalent:
$ git log refA..refB
$ git log ^refA refB
$ git log refB --not refA
This is nice because with this syntax you can specify more than two references in your query, which you cannot do- with the
 double-dot syntax. For instance, if you want to see all commits that are reachable from refA or refB but not from refC, you can use either of:
$ git log refA refB ^refC
$ git log refA refB --not refC

Triple Dot
The last major range-selection syntax is the triple-dot syntax, which specifies all the commits that are reachable by either of
 two references but not by both of them. If you want to see what is in master or experiment but not any common references, you can run:
$ git log master...experiment
A common switch to use with the log command in this case is --left-right, which shows you which side of the
 range each commit is in. This helps make the output more useful:
$ git log --left-right master...experiment

https://git-scm.com/book/en/v2/Git-Tools-Interactive-Staging
Interactive Staging
Interactive Git commands that can help you craft your commits to include only certain combinations and parts of files.
 These tools are helpful if you modify a number of files extensively, then- decide that you want those changes to be
partitioned into several focused commits rather than one big messy commit. This way, you can make sure your commits are
 logically separate changesets and can be reviewed easily by the developers working with you.
~If you run git add with the -i or --interactive option, Git enters an interactive shell mode, displaying something like this:
$ git add -i

Staging Patches
Its also possible for Git to stage certain parts of files and not the rest.
You also dont need to be in interactive add mode to do- the partial-file staging — you can start the same script by using
 git add -p or git add --patch on the command line. Furthermore, you can use patch mode for partially resetting files with the
 git reset --patch command, for checking out parts of files with the
 git checkout --patch command and for stashing parts of files with the
 git stash save --patch command.
Well go into more details on each of these as we get to more advanced usages of these commands.

https://git-scm.com/book/en/v2/Git-Tools-Stashing-and-Cleaning
Stashing and Cleaning
Often- when youve been working on part of your project, things are in a messy state and you want to switch branches for a
 bit to work on something else. The problem is, you dont want to do- a commit of half-done work just so you can get back to
this point later. The answer to this issue is the git stash command.
Stashing takes the dirty state of your working directory — that is, your modified tracked files and
 staged changes — and saves it on a stack of unfinished changes that you can reapply at any time ~even on a different branch~.
Note- Migrating to git stash push
As of late October 2017, there has been extensive discussion on the Git mailing list, wherein the command
 git stash save is being deprecated in favour of the existing alternative git stash push. The main reason for this is that
git stash push introduces the option of stashing selected pathspecs, something git stash save does not support.
git stash save is not going away any time soon, so dont worry about it suddenly disappearing. But you might want to
 start migrating over to the push alternative for the new functionality.

Stashing Your Work
To push a new stash onto your stack, run git stash or git stash push:
$ git stash
$ git stash list
$ git stash apply
$ git stash apply --index
$ git stash pop
$ "git stash drop stash@{0}"

Creative Stashing
There are a few stash variants that may also be helpful. The first option that is quite popular is the --keep-index option to the
 git stash command. This tells Git to not only include all staged content in the stash being created, but simultaneously leave it in the index.
$ git stash --keep-index
By default, git stash will stash only modified and staged tracked files. If you specify --include-untracked or -u, Git will
 include untracked files in the stash being created. However, including untracked files in the stash will still not
include explicitly ignored files; to additionally include ignored files, use --all , or just -a.
$ git stash -u
Finally- if you specify the --patch flag, Git will not stash everything that is modified but will instead prompt you
 interactively which of the changes you would like to stash and which you would like to keep in your working directory.
$ git stash --patch

Creating a Branch from a Stash
~If you stash some work, leave it there for a while, and continue on the branch from which you stashed the work, you may
 have a problem reapplying the work. If the apply tries to modify a file that youve since modified, youll get a
merge conflict and will have to try to resolve it. If you want an easier way to test the stashed changes again, you can run
 git stash branch new_branchname, which creates a new branch for you with your selected branch name, checks out the
commit you were on when you stashed your work, reapplies your work there, and then- drops the stash if it applies successfully:
$ git stash branch testchanges

Cleaning your Working Directory
Finally- you may not want to stash some work or files in your working directory, but simply get rid of them; thats what the
 git clean command is for.
Youll want to be pretty careful with this command, since its designed to remove files from your working directory that are
 not tracked. If you change your mind, there is often no retrieving the content of those files. A safer option is to run
git stash --all to remove everything but save it in a stash.
Assuming you do- want to remove cruft files or clean your working directory, you can do- so with git clean. To remove all the
 untracked files in your working directory, you can run
git clean -f -d, which removes any files and also any subdirectories that become empty as a result.
 The -f means 'force' or 'really do this,' and is required if the Git configuration variable clean.requireForce is not explicitly set to false.
~If you ever want to see what it would do, you can run the command with the --dry-run or -n option, which means 'do a dry run and tell me what you would have removed'.
$ git clean -d -n
By default, the git clean command will only remove untracked files that are not ignored. Any file that matches a pattern in your
 .gitignore or other ignore files will not be removed. If you want to remove those files too, such as to remove all .o files generated from a
build so you can do- a fully clean build, you can add a -x to the clean command.
$ git clean -n -d
$ git clean -n -d -x
~If you dont know what the git clean command is going to do, always run it with a -n first to double check before
 changing the -n to a -f and doing it for real. The other way you can be careful about the process is to run it with the -i or 'interactive' flag.
This will run the clean command in an interactive mode.
$ git clean -x -i
Note- There is a quirky situation where you might need to be extra forceful in asking Git to clean your working directory.
 ~If you happen to be in a working directory under which youve copied or cloned other Git repositories , perhaps as submodules, even
git clean -fd will refuse to delete those directories. In cases like that, you need to add a second -f option for emphasis.

https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work
Signing Your Work
Git is cryptographically secure, but its not foolproof. If youre taking work from others on the internet and want to verify that
 commits are actually from a trusted source, Git has a few ways to sign and verify work using GPG.

GPG Introduction
First of all, if you want to sign anything you need to get GPG configured and your personal key installed.
$ gpg --list-keys
~If you dont have a key installed, you can generate one with gpg --gen-key.
$ gpg --gen-key
Once you have a private key to sign with, you can configure Git to use it for signing things by setting the user.signingkey config setting.
$ git config --global user.signingkey 0A46826A!
Now Git will use your key by default to sign tags and commits if you want.

Signing Tags
~If you have a GPG private key set up, you can now use it to sign new tags. All you have to do- is use -s instead of -a:
$ git tag -s v1.5 -m 'my signed 1.5 tag'
~If you run git show on that tag, you can see your GPG signature attached to it:
$ git show v1.5

Verifying Tags
To verify a signed tag, you use git tag -v <tag-name>. This command uses GPG to verify the signature. You need the
 signers public key in your keyring for this to work properly:
$ git tag -v v1.4.2.1

Signing Commits
In more recent versions of Git ~v1.7.9 and above~, you can now also sign individual commits. If youre interested in
 signing commits directly instead of just the tags, all you need to do- is add a -S to your git commit command.
$ git commit -a -S -m 'Signed commit'
To see and verify these signatures, there is also a --show-signature option to git log.
$ git log --show-signature -1
Additionally- you can configure git log to check any signatures it finds and list them in its output with the %G? format.
$ git log --pretty="format:%h %G? %aN  %s"
~In Git 1.8.3 and later, git merge and git pull can be told to inspect and reject when merging a commit that does not carry a
 trusted GPG signature with the --verify-signatures command.
~If you use this option when merging a branch and it contains commits that are not signed and valid, the merge will not work.
$ git merge --verify-signatures non-verify
~If the merge contains only valid signed commits, the merge command will show you all the signatures it has
 checked and then- move forward with the merge.
$ git merge --verify-signatures signed-branch
You can also use the -S option with the git merge command to sign the resulting merge commit itself. The following example both
 verifies that every commit in the branch to be merged is signed and furthermore signs the resulting merge commit.
$ git merge --verify-signatures -S  signed-branch

Everyone Must Sign
Signing tags and commits is great, but if you decide to use this in your normal workflow, youll have to make sure that
 everyone on your team understands how to do- so. This can be achieved by asking everyone working with the repository to run
git config --local commit.gpgsign true to automatically have all of their commits in the repository signed by default. If
 you dont, youll end up spending a lot of time helping people figure out how to rewrite their commits with signed versions.
Make sure you understand GPG and the benefits of signing things before adopting this as part of your standard workflow.

https://git-scm.com/book/en/v2/Git-Tools-Searching
Searching
With just about any size codebase, youll often need to find where a function is called or defined, or display the
 history of a method. Git provides a couple of useful tools for looking through the code and commits stored in its database quickly and easily.

Git Grep
Git ships with a command called grep that allows you to easily search through any committed tree, the working directory,
 or even the index for a string or regular expression. For the examples that follow, well search through the source code for Git itself.
By default, git grep will look through the files in your working directory. As a first variation, you can use either of the -n or --line-number
 options to print out the line numbers where Git has found matches:
$ git grep -n gmtime_r
Instead of printing all of the matches, you can ask git grep to summarize the output by showing you only which files contained the
 search string and how many matches there were in each file with the -c or --count option:
$ git grep --count gmtime_r
~If youre interested in the context of a search string, you can display the enclosing method or function for each matching
 string with either of the -p or --show-function options:
$ "git grep -p gmtime_r *.c"
You can also search for complex combinations of strings with the --and flag, which ensures that multiple matches must occur in the
 same line of text. For instance, lets look for any lines that define a constant whose name contains either of the
substrings 'LINK' or 'BUF_MAX', specifically in an older version of the Git codebase represented by the tag v1.8.0
 ~well throw in the --break and --heading options which help split up the output into a more readable format~:
$ git grep --break --heading \
    -n -e '#define' --and \( -e LINK -e BUF_MAX \) v1.8.0
The git grep command has a few advantages over normal searching commands like grep and ack. The first is that its really fast,
 the second is that you can search through any tree in Git, not just the working directory. As we saw in the above example,
we looked for terms in an older version of the Git source code, not the version that was currently checked out.

Git Log Searching
Perhaps youre looking not for where a term exists, but when it existed or was introduced. The git log command has a number of powerful tools for
 finding specific commits by the content of their messages or even the content of the diff they introduce.
If- for example, we want to find out when the ZLIB_BUF_MAX constant was originally introduced, we can use the -S option
 ~colloquially referred to as the Git 'pickaxe' option~ to tell Git to show us only those commits that
changed the number of occurrences of that string.
$ git log -S ZLIB_BUF_MAX --oneline
If- we look at the diff of those commits, we can see that in ef49a7a the constant was introduced and in e01503b it was modified.
If- you need to be more specific, you can provide a regular expression to search for with the -G option.

Line Log Search
Another fairly advanced log search that is insanely useful is the line history search. Simply run git log with the -L option,
 and it will show you the history of a function or line of code in your codebase.
For- example, if we wanted to see every change made to the function git_deflate_bound in the zlib.c file, we could run
 git log -L :git_deflate_bound:zlib.c. This will try to figure out what the bounds of that function are and then-
look through the history and show us every change that was made to the function as a series of patches back to when the function was first created.
$ git log -L :git_deflate_bound:zlib.c
If- Git cant figure out how to match a function or method in your programming language, you can also provide it with a
 regular expression ~or regex~. For example, this would have done- the same thing as the example above:
git log -L '/unsigned long git_deflate_bound/','/^}/':zlib.c. You could also give it a range of lines or a
 single line number and youll get the same sort of output.

https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History
Rewriting History
Many times, when working with Git, you may want to revise your local commit history. One of the great things about Git is that
 it allows you to make decisions at the last possible moment. You can decide what files go into which commits right before
you commit with the staging area, you can decide that you didnt mean to be working on something yet with
 git stash, and you can rewrite commits that already happened so they look like they happened in a different way.
This can involve changing the order of the commits, changing messages or modifying files in a commit, squashing together or
 splitting apart commits, or removing commits entirely — all before you share your work with others.
In this section, youll see how to accomplish these tasks so that you can make your commit history look the way you want before you share it with others.
Note- Dont push your work until youre happy with it
One of the cardinal rules of Git is that, since so much work is local within your clone, you have a great deal of freedom to
 rewrite your history locally. However, once you push your work, it is a different story entirely, and you should consider
pushed work as final unless you have good reason to change it. In short, you should avoid pushing your work until youre happy with it and
 ready to share it with the rest of the world.

Changing the Last Commit
Changing your most recent commit is probably the most common rewriting of history that youll do. Youll often want to do-
 two basic things to your last commit: simply change the commit message, or change the actual content of the commit by adding, removing and modifying files.
If- you simply want to modify your last commit message, thats easy:
$ git commit --amend
You need to be careful with this technique because amending changes the SHA-1 of the commit. Its like a very small
 rebase — dont amend your last commit if youve already pushed it.
Tip- An amended commit may ~or may not~ need an amended commit message
When you amend a commit, you have the opportunity to change both the commit message and the content of the commit. If you
 amend the content of the commit substantially, you should almost certainly update the commit message to reflect that amended content.
On the other hand, if your amendments are suitably trivial ~fixing a silly typo or adding a file you forgot to stage~ such that
 the earlier commit message is just fine, you can simply make the changes, stage them, and avoid the unnecessary editor session entirely with:
$ git commit --amend --no-edit

Changing Multiple Commit Messages
To modify a commit that is farther back in your history, you must move to more complex tools. Git doesnt have a
 modify-history tool, but you can use the rebase tool to rebase a series of commits onto the HEAD that they were
originally based on instead of moving them to another one. With the interactive rebase tool, you can then- stop after
 each commit you want to modify and change the message, add files, or do- whatever you wish. You can run rebase interactively by
adding the -i option to git rebase. You must indicate how far back you want to rewrite commits by telling the command which commit to rebase onto.
For- example, if you want to change the last three commit messages, or any of the commit messages in that group, you supply as an
 argument to git rebase -i the parent of the last commit you want to edit, which is HEAD~2^ or HEAD~3. It may be easier to
remember the ~3 because youre trying to edit the last three commits, but keep in mind that youre actually designating
 four commits ago, the parent of the last commit you want to edit:
$ git rebase -i HEAD~3
Remember again that this is a rebasing command — every commit in the range HEAD~3..HEAD with a changed message and
 all of its descendants will be rewritten. Dont include any commit youve already pushed to a central server — doing so
will confuse other developers by providing an alternate version of the same change.
Running this command gives you a list of commits in your text editor that looks something like this:
pick f7f3f6d Change my name a bit
pick 310154e Update README formatting and add blame
pick a5f4a0d Add cat-file
Its important to note that these commits are listed in the opposite order than you normally see them using the log command.
 If- you run a log, you see something like this:
$ git log --pretty=format:"%h %s" HEAD~3..HEAD
a5f4a0d Add cat-file
310154e Update README formatting and add blame
f7f3f6d Change my name a bit
Notice the reverse order. The interactive rebase gives you a script that its going to run. It will start at the commit you
 specify on the command line HEAD~3 and replay the changes introduced in each of these commits from top to bottom. It lists the
oldest at the top, rather than the newest, because thats the first one it will replay.
You need to edit the script so that it stops at the commit you want to edit. To do- so, change the word 'pick' to the
 word 'edit' for each of the commits you want the script to stop after. For example, to modify only the third commit message,
you change the file to look like this:
edit f7f3f6d Change my name a bit
pick 310154e Update README formatting and add blame
pick a5f4a0d Add cat-file
When you save and exit the editor, Git rewinds you back to the last commit in that list and drops you on the command line with the following message:
$ git rebase -i HEAD~3
Stopped at f7f3f6d... Change my name a bit
You can amend the commit now, with
   git commit --amend
Once youre satisfied with your changes, run
   git rebase --continue
These instructions tell you exactly what to do. Type:
$ git commit --amend
Change the commit message, and exit the editor. Then, run:
$ git rebase --continue
This command will apply the other two commits automatically, and -then youre done. If you change pick to edit on more lines,
 you can repeat these steps for each commit you change to edit. Each time, Git will stop, let you amend the commit, and continue when youre finished.

Reordering Commits
You can also use interactive rebases to reorder or remove commits entirely. If you want to remove the 'Add cat-file' commit and
 change the order in which the other two commits are introduced, you can change the rebase script from this:
pick f7f3f6d Change my name a bit
pick 310154e Update README formatting and add blame
pick a5f4a0d Add cat-file
to this:
pick 310154e Update README formatting and add blame
pick f7f3f6d Change my name a bit
When you save and exit the editor, Git rewinds your branch to the parent of these commits, applies 310154e and then- f7f3f6d, and then- stops.
 You effectively change the order of those commits and remove the 'Add cat-file' commit completely.

Squashing Commits
Its also possible to take a series of commits and squash them down into a single commit with the interactive rebasing tool.
 The script puts helpful instructions in the rebase message:
If- instead of 'pick' or 'edit', you specify 'squash', Git applies both that change and the change directly before it and
 makes you merge the commit messages together. So, if you want to make a single commit from these three commits, you make the script look like this:
pick f7f3f6d Change my name a bit
squash 310154e Update README formatting and add blame
squash a5f4a0d Add cat-file
When you save and exit the editor, Git applies all three changes and -then puts you back into the editor to merge the three commit messages:
When you save that, you have a single commit that introduces the changes of all three previous commits.

Splitting a Commit
Splitting a commit undoes a commit and -then partially stages and commits as many times as commits you want to end up with. For example,
 suppose you want to split the middle commit of your three commits. Instead of 'Update README formatting and add blame', you want to
split it into two commits: 'Update README formatting' for the first, and 'Add blame' for the second. You can -do that in the
 rebase -i script by changing the instruction on the commit you want to split to 'edit':
pick f7f3f6d Change my name a bit
'edit' 310154e Update README formatting and add blame
pick a5f4a0d Add cat-file
Then- when the script drops you to the command line, you reset that commit, take the changes that have been reset, and
 create multiple commits out of them. When you save and exit the editor, Git rewinds to the parent of the first commit in your list,
applies the first commit f7f3f6d, applies the second 310154e, and drops you to the console. There, you can -do a
 mixed reset of that commit with git reset HEAD^, which effectively undoes that commit and leaves the modified files unstaged.
Now you can stage and commit files until you have several commits, and run git rebase --continue when youre done:
$ git reset HEAD^
$ git add README
$ git commit -m 'Update README formatting'
$ git add lib/simplegit.rb
$ git commit -m 'Add blame'
$ git rebase --continue
Git applies the last commit a5f4a0d in the script, and your history looks like this:
$ git log -4 --pretty=format:"%h %s"
1c002dd Add cat-file
9b29157 Add blame
35cfb2b Update README formatting
f7f3f6d Change my name a bit
This changes the SHA-1s of the three most recent commits in your list, so make sure no changed commit shows up in that
 list that youve already pushed to a shared repository. Notice that the last commit f7f3f6d in the list is unchanged.
Despite this commit being shown in the script, because it was marked as 'pick' and was applied prior to any rebase changes,
 Git leaves the commit unmodified.

Deleting a commit
If- you want to get rid of a commit, you can delete it using the rebase -i script. In the list of commits, put the
 word 'drop' before the commit you want to delete ~or just delete that line from the rebase script~:
pick 461cb2a This commit is OK
'drop' 5aecc10 This commit is broken
Because of the way Git builds commit objects, deleting or altering a commit will cause the rewriting of all the commits that
 follow it. The further back in your repos history you go, the more commits will need to be recreated. This can cause lots of
merge conflicts if you have many commits later in the sequence that depend on the one you just deleted.
If- you get partway through a rebase like this and decide its not a good idea, you can always stop. Type
 git rebase --abort, and your repo will be returned to the state it was in before you started the rebase.
If- you finish a rebase and decide its not what you want, you can use git reflog to recover an earlier version of your branch.
 See Data Recovery for more information on the reflog command.
https://git-scm.com/book/en/v2/ch00/_data_recovery
Note- Drew DeVault made a practical hands-on guide with exercises to learn how to use git rebase.
 You can find it at: https://git-rebase.io/

The Nuclear Option: filter-branch
There is another history-rewriting option that you can use if you need to rewrite a larger number of commits in some
 scriptable way — for instance, changing your email address globally or removing a file from every commit. The
command is filter-branch, and it can rewrite huge swaths of your history, so you probably shouldnt use it unless your
 project isnt yet public and other people havent based work off the commits youre about to rewrite. However, it can be
very useful. Youll learn a few of the common uses so you can get an idea of some of the things its capable of.
Caution- git filter-branch has many pitfalls, and is no longer the recommended way to rewrite history. Instead, consider
 using git-filter-repo, which is a Python script that does a better job for most applications where you would normally
turn to filter-branch. Its documentation and source code can be found at https://github.com/newren/git-filter-repo.

Removing a File from Every Commit
This occurs fairly commonly. Someone accidentally commits a huge binary file with a thoughtless git add ., and you want to
 remove it everywhere. Perhaps you accidentally committed a file that contained a password, and you want to make your
project open source. filter-branch is the tool you probably want to use to scrub your entire history. To remove a
 file named passwords.txt from your entire history, you can use the --tree-filter option to filter-branch:
$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd 21/21
Ref 'refs/heads/master' was rewritten
The --tree-filter option runs the specified command after each checkout of the project and -then recommits the results.
 In this case, you remove a file called passwords.txt from every snapshot, whether it exists or not. If you want to
remove all accidentally committed editor backup files, you can run something like
 git filter-branch --tree-filter 'rm -f *~' HEAD.
Youll be able to watch Git rewriting trees and commits and -then move the branch pointer at the end. Its generally a
 good idea to -do this in a testing branch and -then hard-reset your master branch after youve determined the outcome is
what you really want. To run filter-branch on all your branches, you can pass --all to the command.

Making a Subdirectory the New Root
Suppose youve -done an import from another source control system and have subdirectories that make no sense ~trunk, tags, and so on~.
 If- you want to make the trunk subdirectory be the new project root for every commit, filter-branch can help you -do that, too:
$ git filter-branch --subdirectory-filter trunk HEAD
Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f 12/12
Ref 'refs/heads/master' was rewritten
Now your new project root is what was in the trunk subdirectory each time. Git will also automatically remove commits that did not affect the subdirectory.

Changing Email Addresses Globally
Another common case is that you forgot to run git config to set your name and email address before you started working, or
 perhaps you want to open-source a project at work and change all your work email addresses to your personal address. In any case,
you can change email addresses in multiple commits in a batch with filter-branch as well. You need to be careful to
 change only the email addresses that are yours, so you use --commit-filter:
$ git filter-branch --commit-filter
#       'if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
#        then
#                GIT_AUTHOR_NAME="Scott Chacon";
#                GIT_AUTHOR_EMAIL="schacon@example.com";
#                git commit-tree "$@";
#        else
#                git commit-tree "$@";
#        fi'
         HEAD
This goes through and rewrites every commit to have your new address. Because commits contain the SHA-1 values of their parents,
 this command changes every commit SHA-1 in your history, not just those that have the matching email address.

https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified
Reset Demystified
Before moving on to more specialized tools, lets talk about the Git reset and checkout commands. These commands are two of the
 most confusing parts of Git when you first encounter them. They -do so many things that it seems hopeless to actually
understand them and employ them properly. For this, we recommend a simple metaphor.
The Three Trees
An easier way to think about reset and checkout is through the mental frame of Git being a content manager of three
 different trees. By 'tree' here, we really mean 'collection of files', not specifically the data structure.
There are a few cases where the index doesnt exactly act like a tree, but for our purposes it is easier to think about it this way for now.
Git as a system manages and manipulates three trees in its normal operation:
Tree	              Role
HEAD                Last commit snapshot, next parent
Index               Proposed next commit snapshot
Working Directory   Sandbox

The HEAD
HEAD is the pointer to the current branch reference, which is in turn a pointer to the last commit made on that branch.
 That means HEAD will be the parent of the next commit that is created. Its generally simplest to think of HEAD as the
snapshot of your last commit on that branch.
In fact, its pretty easy to see what that snapshot looks like. Here is an example of getting the actual directory listing and
 SHA-1 checksums for each file in the HEAD snapshot:
$ git cat-file -p HEAD
tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
author Scott Chacon  1301511835 -0700
committer Scott Chacon  1301511835 -0700
initial commit
$ git ls-tree -r HEAD
100644 blob a906cb2a4a904a152...   README
100644 blob 8f94139338f9404f2...   Rakefile
040000 tree 99f1a6d12cb4b6f19...   lib
The Git cat-file and ls-tree commands are 'plumbing' commands that are used for lower level things and not really used in
 day-to-day work, but they help us see whats going on here.

The Index
The index is your proposed next commit. Weve also been referring to this concept as Gits 'Staging Area' as this is what
 Git looks at when you run git commit.
Git populates this index with a list of all the file contents that were last checked out into your working directory and
 what they looked like when they were originally checked out. You -then replace some of those files with new versions of them,
and git commit converts that into the tree for a new commit.
$ git ls-files -s
100644 a906cb2a4a904a152e80877d4088654daad0c859 0	README
100644 8f94139338f9404f26296befa88755fc2598c289 0	Rakefile
100644 47c6340d6459e05787f644c2447d2595f5d3a54b 0	lib/simplegit.rb
Again- here were using git ls-files, which is more of a behind the scenes command that shows you what your index currently looks like.
The index is not technically a tree structure — its actually implemented as a flattened manifest — but for our purposes its close enough.

The Working Directory
Finally- you have your working directory ~also commonly referred to as the 'working tree'~. The other two trees store their
 content in an efficient but inconvenient manner, inside the .git folder. The working directory unpacks them into actual files,
which makes it much easier for you to edit them. Think of the working directory as a sandbox, where you can try changes out before
 committing them to your staging area ~index~ and -then to history.
$ tree
.
├── README
├── Rakefile
└── lib
    └── simplegit.rb
1 directory, 3 files


