#!/bin/bash
#
# @(!--#) @(#) tanium.sh, sversion 0.1.0, fversion 001, 27-september-2023
#
# create a partition on disk /dev/sdb
#
# checks /dev/sdb is blank with no partition table before doing any destrctive action
#
# Links:
#
#    https://www.golinuxcloud.com/parted-command-in-linux/
#

# fail on undefined shell variables (highly recommended!!!)
set -u

# set PATH
PATH=/bin:/usr/bin:/sbin:/usr/sbin
export PATH


progname=`basename $0`


if [ "`id | cut -d'(' -f2 | cut -d')' -f1`" != "root" ]
then
  echo "$progname: must run this script via sudo or directly as root" 1>&2
  exit 1
fi

stdout=/tmp/$progname.out.$$
stderr=/tmp/$progname.err.$$

diskname=/dev/sdb

echo "Checking to see if a partition table already exists on disk $diskname"

parted $diskname print >$stdout 2>$stderr
retcode=$?

if [ $retcode -ne 0 ]
then
  echo "$progname: error running parted command when printing the partition table" 1>&2
  cat $stdout 1>&2
  cat $stderr 1>&2
  exit $retcode
fi

stdoutlinecount=`cat $stdout | wc -l | awk '{ print $1 }'`
stderrlinecount=`cat $stderr | wc -l | awk '{ print $1 }'`

if [ $stderrlinecount -ne 1 ]
then
  echo "$progname: stderr it not exactly one line when printing partition table" 1>&2
  cat $stdout 1>&2
  cat $stderr 1>&2
  exit 1
fi

if [ "`cat $stderr`" != "Error: $diskname: unrecognised disk label" ]
then
  echo "$progname: disk $diskname appears to be in use - it already has a partition table" 1>&2
  exit 1
fi

echo "Disk $diskname ready for a partition table to be written"

sudo parted $diskname mklabel gpt
retcode=$?

if [ $retcode -ne 0 ]
then
  echo "$progname: issue trying to write a partition table to disk $diskname" 1>&2
  exit 1
fi

echo "Disk $diskname now ready for a partition to be created"

sudo parted $diskname mkpart primary xfs 1 5000
retcode=$?

if [ $retcode -ne 0 ]
then
  echo "$progname: issue trying to create a partition on disk $diskname" 1>&2
  exit 1
fi

echo "Partition created on $diskname"

exit 0
