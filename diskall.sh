#!/bin/bash

for host in beach1 beach2 beach3
do
  echo $host
  ./sshcmds.exp -h $host -u andyc -p [PASS1] -c diskinfo.cmd >diskinfo.$host.out 2>diskinfo.$host.err
done

exit 0
