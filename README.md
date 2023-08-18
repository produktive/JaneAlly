# JaneAlly
<p align="center">
  <img src="https://i.imgur.com/HNOedgX.png">
</p>
This is a tool for automating OfficeAlly electronic claims and remittance transmissions. It can automatically upload electronic claim files to your OfficeAlly account, as well as download new remittance files daily. It was built to interface with Jane App, but can work with any software that utilizes EDI and ERA files. It accomplishes the following:

1. Prompt for password & automate login to OfficeAlly
2. Upload `.edi` claim files in 'EDI' folder to OfficeAlly for processing
3. After successful upload, clear 'EDI' folder of successfully uploaded claims
4. Download new remittances from OfficeAlly and extract ERA files into 'ERA' folder

## Prerequisites
1. A Mac or Linux computer. This will not run on Windows. A Windows tool will be developed soon. If you plan to use the daily automatic feature, the computer must remain on at all times. Otherwise, you can run the tool manually at your convenience.
2. An [OfficeAlly](https://officeally.com) account. You need to contact [support@officeally.com](mailto:support@officeally.com) and ask them to turn on SFTP access. You will receive an email with an SFTP address and username, and a separate email with a password.
3. Consent & understand that for the tool to function, your OfficeAlly SFTP login credentials will be stored on your computer. Use this tool on computers that only you or trusted individuals use. If you are concerned about about the security of your login details being stored, do not proceed.

## Installation
1. [Click here to download ZIP file](https://github.com/produktive/JaneAlly/archive/refs/heads/main.zip), or click the green Code button and click 'Download ZIP.'
2. Unzip to a convenient location, you will be needing to visit this folder to upload/download files. You can rename the default folder `JaneAlly-main` if you'd like.
3. Open the folder, right click on file `JaneAlly.command` and click 'Open.' You will get a warning. Click OK.
4. Follow the prompts and enter the information exactly as provided in your OfficeAlly emails. It will request the SFTP address (some form of `ftp.officeally.com`, `ftp` may include a number. Then it wikll ask for your username, which should be the same as your normal OfficeAlly login, and your SFTP password, which will arrive in a separate email from your credentials. You will only have to enter this information once and we will save the information for future sessions.
5. Finally, it will ask if you want the program to run automatically. Type yes and it will run automatically everyday at 4 am. Obviously, your computer must be on during that time for the program to run. It will run in the background and disappear when finished. It is best to use a computer than is always on. If you don't enable automatic running, you will need to open the program manually when you want it to run.

## How to Use
After running the installation for the first time, you will see lots of lines of text flying by and some new files and folders appearing in the JaneAlly folder. Every time the program runs, new electronic remittance advice files are downloaded into the ERA folder. Only files that haven't been downloaded since last run will be downloaded. The first time the program is run, it will download all remittances in the last 60 days. Open the ERA folder, highlight and drag all files to the Remittances folder in Jane App. It's okay if old files are uploaded, Jane will ignore duplicate files. Once remittances are uploaded, manually delete all files in the ERA folder in JaneAlly. To upload claims simply place `.edi` files downloaded from Jane App into the EDI folder. If set to run automatically, all claims will be automatically uploaded and cleared from the folder every morning at 4 am. If performing manually, simply double-click the `JaneAlly.command` file and it will upload and clear immediately.

**You still have to manually download `.edi` files from Jane and upload ERA files to Jane, because Jane does not currently support automation in this way. If and when they do, I will attempt to automate the entire procedure.**

## Uninstall
If you setup automatic running and you want to stop it, simply right-click and open file `uninstall.command`. The program will only run when you click it.

## Frequently Asked Questions

#### What if I entered incorrect information on installation and need to start over?
Delete the file `settings.conf` in the JaneAlly folder and then run `JaneAlly.command` again.

#### How do I know if my claims successfully uploaded?
You will get an email from OfficeAlly when they are picked up for processing that the upload was successful. You can also open `autolog.txt` to see the results of the last time JaneAlly automatically ran. If you do not have `autolog.txt` then you do not have automatic running enabled or it has not run yet.