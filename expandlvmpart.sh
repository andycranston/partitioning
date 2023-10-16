#!/bin/bash
#
# expandlvmpart.sh
#

set -u


# fix PATH
PATH=/bin:/usr/bin:/usr/local/bin
export PATH

# set program (i.e. script) name
progname=`basename $0`

# Check for command line args
if [ $# -ne 3 ]
then
  echo "$progname: usage: $progname host devicename partition number" 1>&2
  exit 2
fi

# extract command line args
hostname=$1
devicename=$2
partnumber=$3

./sshcmds.exp -h $hostname -u andyc -p [PASS1] -c rescan.cmd

./partedfix.exp -h $hostname -u andyc -p [PASS1] -d /dev/$devicename

./sshcmds.exp -h $hostname -u andyc -p [PASS1] -c resize.cmd
