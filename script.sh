#!/bin/bash

#########################################
## Check script syntax & requirments.  ##
#########################################
# Check script parameters.
[ -z $1 ] && (echo "Usage: $0 <sourceip>"; exit 1)
# Check mailx command.
[ -x /bin/mailx ] || (echo "Please, install 'mailx'"; exit 1)

#########################################
## Prepare mailx command parameters.   ##
#########################################
# Get banned ip.
SOURCEIP="$1"
# Get Hostname.
HOSTNAME=$(/bin/hostname -f)
# Set DOSLogDir
MODEVASIVE_DOSLogDir="/path/to/mod_evasive/log"
# Set Mail hostname.
SMTP_HOST=mail.example.com
# Set SMTP Port.
SMTP_PORT=25
# Set from email address.
FROM_EMAIL_ADDRESS=from@example.com
FRIENDLY_NAME=FromName
# Set from password.
EMAIL_ACCOUNT_PASSWORD=xxxxxxxxxxxx
# Set To Mail addresses.
TO_EMAIL_ADDRESS="rcpt@exapmle.com"
# Set email subject.
EMAIL_SUBJECT="DDOS Attack Detected - $HOSTNAME - Apache ModEvasive"
# Store body mail in file.
BODYMAIL="/tmp/bodymailddos"
# Blocking time
BANNEDTIME="1 minute"
# Custom mail message
{
echo "Massive connections has been detected from this source IP: $SOURCEIP

The apache system has blocked the IP in the mod_evasive for $BANNEDTIME. If the problem persist you should block that IP permanently.

- Anti DDOS System -"
} > $BODYMAIL

# Send email
cat $BODYMAIL | /bin/mailx -v -s "$EMAIL_SUBJECT" -S smtp-use-starttls -S ssl-verify=ignore -S smtp-auth=login -S smtp="smtp://$SMTP_HOST:$SMTP_PORT" -S from="$FROM_EMAIL_ADDRESS($FRIENDLY_NAME)" -S smtp-auth-user=$FROM_EMAIL_ADDRESS -S smtp-auth-password=$EMAIL_ACCOUNT_PASSWORD -S ssl-verify=ignore $TO_EMAIL_ADDRESS

# Remove entry.
rm -f "$MODEVASIVE_DOSLogDir/dos-$SOURCEIP"
#

# Inetgrate with csf.
csf -td $SOURCEIP
