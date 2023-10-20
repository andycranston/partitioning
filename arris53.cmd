#######################################
#                                     #
# add user arris53 to a RedHat 7.9 host #
#                                     #
#######################################

#
# add the general group
#
grep general /etc/group
rc=$?
echo $rc
test $rc -eq 1 && sudo groupadd -g 4000 general

#
# add user arris53
#
grep arris53 /etc/passwd
rc=$?
echo $rc
test $rc -eq 1 && sudo useradd -c "CommScope (Andy Cranston)" -d /home/arris53 -g general -s /bin/bash -u 4001 arris53

#
# make user arris53 a member of group wheel
#
grep wheel /etc/group | grep arris53
rc=$?
echo $rc
test $rc -eq 1 && sudo usermod -a -G wheel arris53

#
# change mode, owner and group on arris53 home directory
#
sudo chmod u=rwx,go=rx /home/arris53
sudo chown arris53:general /home/arris53

# end of file
