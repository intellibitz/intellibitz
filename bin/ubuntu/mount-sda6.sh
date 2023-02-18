#https://askubuntu.com/questions/46588/how-to-automount-ntfs-partitions
#http://askubuntu.com/questions/333287/external-hard-disk-read-only

sudo mount -o remount,uid=1000,gid=1000,rw /dev/sda6

#Try executing the following command in a terminal:

sudo mount -o remount,uid=1000,gid=1000,rw /dev/sdc1
#Explanation:

#-o means "with these options".
#remount - remounts the drive over the same mount point with the same previous options.
#uid=1000 - this option makes the user with id 1000 the owner of the drive. This is probably your username's id if you only have one username. If you have more than one username on your system, run the command id and use the number after uid=.
#gid=1000 - this option makes the group with id 1000 the group owner of the drive. Same notes as previous point.
#rw - this option mounts the drive as read/write. It was probably read/write anyways, but this is just to double check.
#Since you've already tried this command and it didn't work, let's try manually mounting the drive. Follow the below:

sudo umount /dev/sdc1
#This unmounts the drive.
sudo mkdir toshibaHDD
#This will create a new mount point.
sudo mount -o rw,uid=1000,gid=1000,user,exec,umask=003,blksize=4096 /dev/sdc1 /media/toshibaHDD
#user - permits any user to mount the drive
#exec - allows for execution of binaries on this drive. You can remove this option if you want.
#umask=003 - this will give rwxrwxr-- permissions to everything (directories and files) inside the drive. Alternatively, you can use dmask and fmask instead of umask to give separate permissions to directories and files (respectively).
#Now check the permissions of your drive.

#Edit
#Follow the steps to make it permanent:
#Unplug your external hard disk.
cd /etc
sudo cp fstab fstab.bak
#This takes a backup of the file we're about to edit.
sudo nano fstab
#This opens up the fstab file in a text editor.
#Move the blinking cursor to the end of the file, and paste the following two lines:
# line for mounting the external drive
UUID=D04A-0AE4   /media/toshibaHDD  exfat rw,uid=1000,gid=1000,user,exec,umask=003,blksize=4096   0   0
#Windows-Partition
UUID=<xxxxx> /media/win ntfs rw,auto,users,exec,nls=utf8,umask=003,gid=46,uid=1000    0   0

#Hit Ctrl+X, then Y, then Enter to save and close.
#That's it. Now, when you plug your external hard disk in, it will always have those options.
