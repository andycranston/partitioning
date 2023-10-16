#
# rescan.cmd
#
# after expanding a root disk expand the LVM partition
#

# set up before and now filenames based on current time
seconds=`date '+%s'`
before=/var/tmp/lsblk-before.$seconds
now=/var/tmp/lsblk-now.$seconds

# run lsblk to see what we have before (also save output)
lsblk > $before
cat $before

# create a tempoary file with the line "1" in it
echo 1 > /var/tmp/one.txt

# rescan all /dev/sd[a-z] disks
for diskname in `ls /dev/sd[a-z]`; do sudo cp /var/tmp/one.txt /sys/block/`basename $diskname`/device/rescan;done

# run lsblk a second time to see what we have now (also save output)
lsblk > $now
cat $now

# end of file
