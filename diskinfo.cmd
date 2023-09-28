#
# diskinfo.cmd
#
# handy disk info commands to get an idea of deployed and remaining storage
#

df -k

cat /etc/fstab

disks=`ls /dev/sd[a-z]`

for disk in $disks; do sudo parted $disk print; done

sudo lsblk

sudo ls -l /dev/mapper

diskdirs=`find /dev/disk -type d -print`

for diskdir in $diskdirs; do echo === $diskdir ===; sudo ls -l $diskdir; done

# end of file
