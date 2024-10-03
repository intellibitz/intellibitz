# https://git-scm.com
# https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things
#https://git-scm.com/docs/gitcredentials
#https://git-scm.com/doc/credential-helpers

git config credential.https://example.com.username myusername
git config credential.helper "[helper] [options]"

git config --global --list
git config --global user.name=["name"]
git config --global user.email=["email"]

git config --global --add safe.directory dir-path

#--
git init -b ["main"] #creates or reinitializes local git repository as main branch
git status #shows modified, unmodified files

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
git clone URL directory_name #clones a remote repository
git clone URL #clones remote git repository

git remote #List the remote repository connections stored in the local repository by shortname
git remote -v #List the remote repository connections in the local repository with shortnames and URLs
git remote add shortname URL #adds a connection to a remote repository named <shortname> at <URL>

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

# https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
# https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository
cat .gitignore
#*.[oa]
#*~

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

