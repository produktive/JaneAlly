#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"
mkdir -p EDI
mkdir -p ERA

if [[ ! -f "settings.conf" ]]; then
	
	while true; do
		echo 'Welcome to JaneAlly! Please enter your OfficeAlly SFTP login details to begin.'
		read -p 'OfficeAlly SFTP address: ' host
		read -p 'OfficeAlly SFTP username: ' user
		read -p 'OfficeAlly SFTP password: ' pass
		read -p 'Do you want to automatically run every day (yes/no)? ' auto
		if [ "$auto" != 'yes' ]; then auto='no'; fi
		echo 'It is extremely important that you verify your login details or risk getting locked out of your OfficeAlly account.'
		read -p 'Is this information correct (yes/no)? ' confirm
		if [ "$confirm" == 'yes' ]; then
			break
		else
			continue
		fi
	done
	
	
	if [ "$auto" == 'yes' ]; then
		job="0 8 * * * \"$SCRIPT_DIR/JaneAlly.command\" > \"$SCRIPT_DIR/autolog.txt\" 2>&1"
		cat <(fgrep -i -v "$SCRIPT_DIR/JaneAlly.command" <(crontab -l)) <(echo "$job") | crontab -
		echo 'Great, JaneAlly will automatically run daily at 8 am. Leave this computer on.'
	else
		echo 'Great, you will need to run this program manually whenever you want to transmit files.'
	fi
	
	echo -en "host=\"$host\"\nport=\"22\"\nuser=\"$user\"\npass=\"$(echo "$pass" | base64)\"" > settings.conf
	echo 'Please wait, running the program for the first time takes a couple minutes...'

fi

. settings.conf
pass=$(echo "$pass" | base64 --decode)
if [[ -f "history.log" ]]; then
	mv history.log history.tmp
fi

expect <(cat <<EOD
set timeout 20

# Connect to SFTP server
spawn sftp -P $port -oUser=$user -p $host
expect {
  "yes/no" {send "yes\r";exp_continue}
  "assword:" {send "$pass\r";exp_continue}
	sftp>
}

# Upload edi files to inbound folder
send "put EDI/*.edi inbound\r"
expect sftp>

# Get list of remittance files
log_file -noappend history.log
send "ls outbound/*ERA_STATUS*.zip -1t\r"
expect sftp>
log_file
send "!sed -i '' 1d ./history.log\r"
expect sftp>
send "!sed -i '' '/sftp>/d' ./history.log\r"
expect sftp>
send "exit\r"
expect eof
EOD
)

# Get filenames of new files only
if [[ -f "history.tmp" ]]; then
	newfiles=$(comm -13 history.tmp history.log)
else
	newfiles=$(< history.log)
fi
newfiles=$(echo $newfiles | tr -d "\t\n\r" | tr -s ' ')

if [ ! -z "$newfiles" ]; then
	expect <(cat <<EOD
	set timeout 20

	# Connect to SFTP server
	spawn sftp -P $port -oUser=$user -p $host
	expect assword:
	send "$pass\r"
	expect sftp>
	foreach file [split [string trim "$newfiles"]] {
		send "get \$file ERA\r"
		expect sftp>
	}

	send "exit\r"
	expect eof
EOD
	)
		
echo 'Files downloaded, extracting remittances...'
	for z in ERA/*.zip; do 
		fname=${z:4:35}
		unzip -j "$z" "${fname/STATUS/835}.835" -d "ERA"
	done
fi

echo 'Extraction complete, cleaning up files...'
rm -f EDI/*.edi
rm -f ERA/*.zip
rm -f history.tmp
echo 'Clean up complete.'
osascript -e 'tell application "Terminal" to quit' &
exit