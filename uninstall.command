#!/bin/bash
crontab -l | grep -v 'JaneAlly.sh' | crontab -
osascript -e 'tell application "Terminal" to quit' &
exit