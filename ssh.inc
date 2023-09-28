#
# @(!--#) @(#) ssh.inc, version 002, 28-september-2023
#
# expect procedures for handling a spawned ssh connection
#

# #############################################################

proc sshpassenv {password description} {
  global progname
  global env

  # is the password enclosed in [ and ] brackets?
  if {[string length $password] >= 3} {
    if {[string compare [string index $password 0] "\["] == 0} {
      if {[string compare [string index $password [expr [string length $password] - 1]] "]"] == 0} {
        set passwordenv [string range $password 1 [expr [string length $password] - 2]]
  
        if {[catch {set password $env($passwordenv)}] != 0} {
          send_error "$progname: the $description environment variable \"$passwordenv\" is not set\n"
          exit 1
        }
      }
    }
  }

  return $password
}


# #############################################################

proc sshlogin {password} {
  # set a password count to zero
  set pcount 0

  # start login loop
  while {1} {
    expect {
      timeout {
        send_error "\n$progname: timeout during ssh login process\n"
        exit 1
      }
      eof {
        send_error "\n$progname: end of file during ssh login process\n"
        exit 1
      }
      "Host key verification failed.\r" {
        send_error "$progname: host key issue prevents ssh login process\n"
        exit 1
      }
      "Are you sure you want to continue connecting*\\? " {
        send "yes\r"
      }
      "'s password: " {
        incr pcount
        if {$pcount > 1} {
          send_error "\n$progname: too many password attempts during ssh login process\n"
          exit 1
        }
        send "$password\r"
      }
      "$ " {
        # prompt
        break
      }
    }
  }
}

# #############################################################

proc sshsudo {username sudopassword} {
  # reset sudo caching (if any)
  send "sudo -K\r"

  # should get prompt back
  expect {
    timeout {
      send_error "\n$progname: timeout while running \"sudo -K\" command\n"
      exit 1
    }
    eof {
      send_error "\n$progname: end of file while running \"sudo -K\" command\n"
      exit 1
    }
    "$ " {
      # fall through
    }
  }

  # run "sudo id" to force prompting of sudo password
  send "sudo id\r"

  # set a password count to zero
  set pcount 0

  # use a loop so we can catch the sudo password prompt if it is going to be displayed
  while {1} {
    expect {
      timeout {
        send_error "\n$progname: timeout while running \"sudo id\" command\n"
        exit 1
      }
      eof {
        send_error "\n$progname: end of file while running \"sudo id\" command\n"
        exit 1
      }
      "\\\[sudo] password for $username: " {
        incr pcount
        if {$pcount > 1} {
          send_error "\n$progname: too many password attempts while running \"sudo id\" command\n"
          exit 1
        }
        send "$sudopassword\r"
      }
      "$ " {
        # prompt
        break
      }
    }
  }
}

# #############################################################

proc sshclose {} {
  # send exit command to shutdown ssh connection
  send "exit\r"

  # wait for eof
  expect {
    eof {
      # fall through
    }
    timeout {
      send_error "\n$progname: time out waiting for ssh connection to close\n"
      exit 1
    }
  }
}

# #############################################################

# end of file
