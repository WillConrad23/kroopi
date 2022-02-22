#!/bin/bash

# Crontab schedule:
# “At 9am and 2pm on days from
#  Monday through Saturday in 
#  every month from September through March.”
# 0 9,14 * 1-3,9-12 1-6

log=netlog.txt
time=$(date +%c)

# Check internet connection
if [ ! $(curl -s captive.apple.com) ]; then
  echo "No internet connection - Attempting to log in..."

  # Attempt to log into school guest network
  curl -s -m 5 --data "user=jconrad23&password=PASSWORD&email=&cmd=authenticate&agreementAck=Accept" -X POST http://10.0.0.90/cgi-bin/login?cmd=login&mac=68:7F:74:47:35:2E
  # This curl mimics the POST string sent to the servers
  # when you log in with the captive portal
  sleep 5
  if [ $(curl -s captive.apple.com) ]; then
    echo "Login Success"
    printf "OFFLINE - $time - LOGIN SUCCESS\n" >> $log
  else
    echo "Login Fail"
    printf "OFFLINE - $time - LOGIN FAIL\n" >> $log
  fi
else
  printf "ONLINE  - $time\n" >> $log
fi

git add netlog.txt
git commit -m "Log"
git push
