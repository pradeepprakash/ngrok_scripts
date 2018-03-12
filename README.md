# Ngrok_scripts


## Files | Description

ngrok                           | ARM binary for raspberry Pi
ngrok_core.sh                   | Invokes ngrok with configuration from ngrok.yml 
ngrok.log                       | Contains additional raw logs from ngrok.com
ngrok.pid                       | Contains the current PID of ngrok on that system.
ngrok_port.txt                  | Contains extracted port information in plain text.
ngrok_rpi3_spawn_if_killed.sh   | The main worker script. See header of that file for more info.
ngrok-stable-linux-arm.zip      | This version is ARM package for Raspberry. Check ngrok.com for other architectures 
ngrok.yml                       | The ngrok configuration file. Refer https://ngrok.com/docs#config
README.md                       | This file with some help and description.

## What it does
The main worker script (ngrok_rpi3_spawn_if_killed.sh) is supposed to be installed 
as a crontab item to run at regular intervals.
Triggers ngrok.Checks if ngrok is already running and exits. If not, will setup 
the tunnel and email the port information to the email id configured.


##  Configuratiosn needed
###  In file <ngrok_core.sh>
    - set NGROK_PATH to the path where these above file resides in the system.
###  In file <ngrok_rpi3_spawn_if_killed.sh>
    - set NGROK_PATH to the path where these above file resides in the system.
    - set FROM_EMAIL to email id from which email is sent.
    - set TO_EMAIL   to email id to which email is sent.

###  In file <ngrok.yml>
    - place ngrok.yml file in $HOME/.ngrok2
    - set your auth token from ngrok.com as below
      "authtoken: <your_token_from_ngrok.com_goes_here>" without quotes,
