#
# !!! must be sourced from a Bourne style shell !!!
#
# @(!--#) @(#) setpw.sh, version 001, 10-june-2018
#
# used to set environment variables to values of passwords
# without showing the password on the screen or leaving
# a trace in a shell history file like .bash_history
#

if [ $# -eq 0 ]
then
  echo "setpw: usage: setpw ENVIRONMENT_VARIABLE_NAME" 1>&2
else
  ENVIRONMENT_VARIABLE_NAME=$1

  echo -n "Enter password.........: "
  stty -echo
  read password1
  stty echo
  echo

  if [ "$password1" == "" ]
  then
    echo "setpw: no password entered" 1>&2
  else
    echo -n "Enter password again...: "
    stty -echo
    read password2
    stty echo
    echo

    if [ "$password1" != "$password2" ]
    then
      echo "setpw: passwords don't match" 1>&2
    else
      eval $ENVIRONMENT_VARIABLE_NAME=$password1
      eval export $ENVIRONMENT_VARIABLE_NAME
      echo "Environment variable $ENVIRONMENT_VARIABLE_NAME set to password entered above"
    fi
  fi

  unset ENVIRONMENT_VARIABLE_NAME
  unset password1
  unset password2
fi
