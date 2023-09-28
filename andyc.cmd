#######################################
#                                     #
# add user andyc to a RedHat 7.9 host #
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
# add user andyc
#
grep andyc /etc/passwd
rc=$?
echo $rc
test $rc -eq 1 && sudo useradd -c "Andy Cranston" -d /home/andyc -g general -s /bin/bash -u 4000 andyc

#
# make user andyc a member of group wheel
#
grep wheel /etc/group | grep andyc
rc=$?
echo $rc
test $rc -eq 1 && sudo usermod -a -G wheel andyc

#
# change mode, onwer and group on andyc home directory
#
sudo chmod u=rwx,go=rx /home/andyc
sudo chown andyc:general /home/andyc

# end of file
