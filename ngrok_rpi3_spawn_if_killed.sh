#
#
#  This script is to be run in cron at regular intervals to make sure ngrok is
#  running and if restart sends out email wtith the changed port number.
#
#
#!/bin/bash
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
# From which id the e-mail is being sent.
FROM_EMAIL=your.id@email.com
# To which id the e-mail is being sent.
TO_EMAIL=to.id@email.com
#Path where ngrok and ngrok worker files( .pid, .log, .txt , .sh) files are stored
# Change according to your location
NGROK_PATH=$HOME/rpi3/ngrok
PIDFILE="$NGROK_PATH/ngrok.pid"
echo "Before:${PIDFILE}: $(cat ${PIDFILE})"
if [ -e "${PIDFILE}" ] && (ps -u $(whoami) -opid= |
                           grep -P "^\s*$(cat ${PIDFILE})$" &> /dev/null); then
  echo "Already running."
  exit 99
fi
#Start Ngrok with configuration  from YML file.
$NGROK_PATH/ngrok_core.sh& 
#Wait 10seconds for connection and tunnel to be established
echo "Waiting for 10 seconds for connection establishment...."
sleep 10
echo "Done waiting for 10 seconds....Parsing JSON"
#NGROK returns the url and port number through API
/usr/bin/curl http://localhost:4040/api/tunnels/ssh |/usr/bin/jq -r '.public_url' > $NGROK_PATH/ngrok.log
cp $NGROK_PATH/ngrok.log $NGROK_PATH/ngrok_port.txt
#Filter out only port number for easy reading
/usr/bin/awk '{val=substr($0,22,5);print val}' $NGROK_PATH/ngrok.log > $NGROK_PATH/ngrok_port.txt
#Send mail with port number. Assumes sendmail is installed and setup.
echo -e "Subject:Rpi3.Ngrok.Port\n\n" "[" `date` "]:: " "Port:  "`cat $NGROK_PATH/ngrok_port.txt` | sendmail -F "Ngrok Pi3" -f $FROM_EMAIL $TO_EMAIL
#Store PID to check if ngrok has restarted
echo $! > "${PIDFILE}"
chmod 644 "${PIDFILE}"
