#!/bin/bash

. config.sh

if [ $# -lt 2 ]; then
    echo Insuficient parameters, please try again...
    exit 1
fi

PARAM_NAME=$1
PARAM_OS=$2

if [ ! -z $3 ]; then
    PARAM_MEMORY="--memory $3 "
fi

#
# Force log DEBUG
# 
DEBUG=1

echo PARAM_OS = $PARAM_OS
export PARAM_TYPE
export PARAM_HARDDRIVE

#
# Select specific operation system for Virtual Machine
#
if [ $PARAM_OS = 'linux' ]; then
    PARAM_TYPE="Ubuntu"
    ## UUID or filename of virtual storage
    PARAM_HARDDRIVE="0f690690-7c22-48db-ae32-aed307215dd2" 
elif [ $PARAM_OS = 'windows' ]; then
    PARAM_TYPE='WindowsXP'
    ## UUID or filename of virtual storage
    PARAM_HARDDRIVE="windows-image.vdi"
else
    echo Operative System Unkown: $PARAM_OS
    exit 1
fi

echo PARAM_TYPE = $PARAM_TYPE

log "Creating Virtual machine for operational system $PARAM_TYPE"
$VBOXMANAGE createvm --name $PARAM_NAME --ostype $PARAM_TYPE --register

log "Modifying Virtual machine"
$VBOXMANAGE modifyvm $PARAM_NAME $PARAM_MEMORY --nic1 nat --nic2 hostonly --hostonlyadapter2 vboxnet0 --vrdp on \
    --vrdpmulticon on --usb off --pae on --acpi on --nestedpaging on

log "Creating Sata driver in virtual machine"
$VBOXMANAGE storagectl       $PARAM_NAME \
                            --name "satadisk" \
                            --add sata
                            
log "Attach virtual harddrive"
$VBOXMANAGE storageattach $PARAM_NAME --storagectl "satadisk" --port 0 --device 0 --type hdd --medium $PARAM_HARDDRIVE

# Set ip da maquina virtual vazio
$VBOXMANAGE guestproperty set $PARAM_NAME "/VirtualBox/GuestInfo/Net/1/V4/IP"

log "Setting new logo"
$VBOXMANAGE modifyvm $PARAM_NAME --bioslogoimagepath $HOME/trabalho-final/tecgraf.bmp
# $VBOXMANAGE modifyvm $PARAM_NAME --bioslogoimagepath /home/edward/trabalho-final/tecgraf.bmp

log "Starting virtual machine"
$VBOXMANAGE startvm $PARAM_NAME --type sdl &

# Wait for 30 secounds to get a ip number... after this will abort
sleep 1
echo
echo "Waiting"
for ((i=0; i<$VIRTUAL_MACHINE_START_TIMEOUT; i++)); do
    sleep 1
    IP=$($VBOXMANAGE guestproperty get $PARAM_NAME "/VirtualBox/GuestInfo/Net/1/V4/IP" | egrep -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
    echo .
    if [ ! -z $IP ]; then
        break
    fi
done

echo

if [ -z $IP ]; then
    echo "Couldn't get virtual machine's ip. Possible causes:"
    echo "1. Virtual machine didn't have virtualbox-tools installed"
    echo "2. Virtual machine have problem and not started"
    exit 1
fi

cat >/tmp/$PARAM_NAME.lua <<~END
name = "$PARAM_NAME"
ip = "$IP"
port = 20202
resources = {
  cpu = 1800,
  mem = 512,
  os = "$PARAM_OS",
  arch = "x86_64",
  bandwidth = 100,
}
languages = {
  "lua",
  "java",
}
~END

echo "Waiting while Execution Node starts"
sleep 5
echo "Time off"


