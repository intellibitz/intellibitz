# https://git-scm.com
# https://git-scm.com/docs/gitcredentials
# https://git-scm.com/doc/credential-helpers
# https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things
# https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
# https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository

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
#Initial branch configuration: git init also sets up an initial branch (traditionally main). However, this
# branch doesn't have any commits until you make your first commit.
$ git init                        #(1) Create a /path/to/my/codebase/.git directory.
$ git add .                       #(2) Add all existing files to the index.
$ git commit -m "commit_message"  #(3) Record the pristine state as the first commit in the history.
git init -b ["main"] #creates or reinitializes local git repository as main branch

#You clone a repository with git clone <url>. For example, if you want to clone the
# Git linkable library called libgit2, you can do so like this:
git clone URL #clones remote git repository
$ git clone https://github.com/libgit2/libgit2
#If you want to clone the repository into a directory named something other than libgit2, you can
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
git init      #(1) Create a /path/to/my/codebase/.git directory.
git add .     #(2) Add all existing files to the index.
git commit    #(3) Record the pristine state as the first commit in the history.
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
# before a commit is finalized (pre-commit) or before pushing to a remote repository (pre-push). By default, Git populates this
# directory with example scripts. These scripts are not active until renamed (removing the .sample extension).
info/:
#--
#Inside, you'll find the exclude file, which works like a .gitignore file but is specific to this repository. The patterns listed in
# the exclude file will be ignored by Git, similar to how .gitignore works, but without the need to commit this file into the repository.
description:
#--
#This file is only used by the GitWeb program, which is a Git web interface. By default, it contains a placeholder text
# ("Unnamed repository; edit this file 'description' to name the repository."), which can be changed to provide a
# meaningful description of your repository for viewers on GitWeb.
index:
#--
#The index file (not present immediately after git init but created upon first adding files to the staging area)
# acts as the staging area ("index") for Git. It tracks which files will be included in the next commit.

cat .gitignore
#*.[oa]
#*~

