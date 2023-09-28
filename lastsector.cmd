#
# lastsector.cmd
#

lastsector=`sudo parted -s /dev/sdb -- unit s print free | grep "Free Space" | awk '{ print $2 }' | sed 's/s//g' | sort -n | tail -n 1`
echo $lastsector

# end of file
