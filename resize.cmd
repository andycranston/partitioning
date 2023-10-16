#
# resize.cmd
#
# resize partition
#

# get largest partition number
largestpartnum=`sudo parted /dev/sda -- unit s print | awk '{ print $1 }' | grep '^[0-9]' | sort -n | tail -n 1`

# if unable to get a value exit
test "$largestpartnum" = "" && exit

# show largest partition number
echo "Largest partition number is $largestpartnum"

# if partition number is not 3 then bail out
test "$largestpartnum" != "3" && exit

# resize partition to use 100% if disk
device=sda
sudo parted /dev/$device -- unit s print free
sudo parted /dev/$device -- resizepart $largestpartnum 100%
sudo parted /dev/$device -- unit s print free
lsblk

# run pvscan
sudo pvscan

# run partprobe
sudo partprobe

# run pvresize
sudo pvresize /dev/${device}${largestpartnum}

# run pcscan again
sudo pvscan

# run vgdisplay
sudo vgdisplay

# end of file
