#!/bin/bash
crontab -l | grep -v 'JaneAlly.command' | crontab -
osascript -e 'tell application "Terminal" to quit' &
exit