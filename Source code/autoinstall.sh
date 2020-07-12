#!/bin/bash
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
CFGFILENAME="autoinstall.cfg"

# Check syntax
if [ -z "$1" ]; then
  echo "Syntax : $0 [configuration file]"
  exit
fi

# Check file and load parameters
FILE="$1"
if [ -f "$FILE" ]; then
  . "$1"
else
  echo "Configuration file not found : $1"
  exit
fi

lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

# Function to replace strings in sample files
strreplace() {
    # Loop the config array
    for i in "${!confs[@]}"
    do
        search=$i
        replace=${confs[$i]}
        sed -i "s^${search}^${replace}^g" $tempfile
    done
}

# Function to wait for reply
pressakey() {
    while [ true ] ; do
    read -t 3 -n 1
    if [ $? = 0 ] ; then
    break ;
    fi
    done
}

# Set hostname
echo $hostname > /etc/hostname
hostname $hostname

# Update and Upgrade
export DEBIAN_FRONTEND=noninteractive
apt -y update && apt -y upgrade

# Install packages
apt-get -yq install motion ipsec-tools xl2tpd strongswan net-tools autofs sshfs mutt msmtp sox libsox-fmt-mp3 wiringpi curl libcurl4 libusb-0.1 unzip wget sudo cron libudev-dev apt-utils whiptail git

# Ipsec Configuration
#ipseccfgfile="$TESTDIR/ipsec.conf.inc"
cp -f $SCRIPTPATH/src/ipsec.conf.inc $tempfile
declare -A confs
confs=(
    [%%conname%%]=$conname
    [%%vpnserverip%%]=$vpnserverip
)
strreplace
cp -f $tempfile $ipseccfgfile

# L2tpd Client Options
#pppoptfile="$TESTDIR/options.l2tpd.client"
cp -f $SCRIPTPATH/src/options.l2tpd.client $tempfile
declare -A confs
confs=(
    [%%vpnuser%%]=$vpnuser
    [%%vpnuserpwd%%]=$vpnuserpwd
)
strreplace
cp -f $tempfile $pppoptfile
chmod 600 $pppoptfile

# PreSharedKey
#ipsecsecretsfile="$TESTDIR/ipsec.secrets"
cp -f $SCRIPTPATH/src/ipsec.secrets $tempfile
declare -A confs
confs=(
    [%%vpnserverip%%]=$vpnserverip
    [%%presharedkey%%]=$presharedkey
)
strreplace
cp -f $tempfile $ipsecsecretsfile
chmod 600 $ipsecsecretsfile


# Vpn Start Script
#vpnupfile="$TESTDIR/vpn-up.sh"
cp -f $SCRIPTPATH/src/vpn-up.sh $tempfile
declare -A confs
confs=(
    [%%conname%%]=$conname
    [%%vpnsubnet%%]=$vpnsubnet
    [%%vpnsubnetmask%%]=$vpnsubnetmask
    [%%internalvpnip%%]=$internalvpnip
)
strreplace
cp -f $tempfile $vpnupfile
chmod 700 $vpnupfile

# Xl2tpd Config
#xl2tpcfgfile="$TESTDIR/xl2tpd.conf"
cp -f $SCRIPTPATH/src/xl2tpd.conf $tempfile
declare -A confs
confs=(
    [%%conname%%]=$conname
    [%%vpnserverip%%]=$vpnserverip
    [%%pppoptfile%%]=$pppoptfile
)
strreplace
cp -f $tempfile $xl2tpcfgfile

# Autofs Config
cp -f $SCRIPTPATH/src/auto.master $tempfile
declare -A confs
confs=(
    [%%autofsrootpath%%]=$autofsrootpath
    [%%autosshfsfile%%]=$autosshfsfile
)
strreplace
#automasterfile="$TESTDIR/auto.master"
cp -f $tempfile $automasterfile
cp -f $SCRIPTPATH/src/auto.sshfs $tempfile
declare -A confs
confs=(
    [%%autofsmountpoint%%]=$autofsmountpoint
    [%%sshusername%%]=$sshusername
    [%%sshservername%%]=$sshservername
    [%%sshserverport%%]=$sshserverport  
    [%%sshserverpath%%]=$sshserverpath    
)
strreplace
#autosshfsfile="$TESTDIR/auto.sshfs"
cp -f $tempfile $autosshfsfile
service autofs restart

# Vpn Service
#vpnservicefile="$TESTDIR/vpn.service"
cp -f $SCRIPTPATH/src/vpn.service $tempfile
declare -A confs
confs=(
    [%%vpnservicename%%]=$vpnservicename
    [%%vpnupfile%%]=$vpnupfile
)
strreplace
cp -f $tempfile $vpnservicefile
systemctl daemon-reload
if [ ${vpnbootstart,,} = "yes" ]
then
        systemctl enable $vpnservicename
fi

# Motion up Service
#motionupservicefile="$TESTDIR/motionup.service"
cp -f $SCRIPTPATH/src/motionup.service $tempfile
declare -A confs
confs=(
    [%%motionupservicename%%]=$motionupservicename
    [%%motionupscriptfile%%]=$motionupscriptfile
)
strreplace
cp -f $tempfile $motionupservicefile
systemctl daemon-reload
if [ ${motionupbootstart,,} = "yes" ]
then
        systemctl enable $motionupservicename
fi

# Motion Config
#motioncfgfile="$TESTDIR/motion.conf"
cp -f $SCRIPTPATH/src/motion.conf $tempfile
declare -A confs
confs=(
    [%%motiontargetdir%%]=$autofsrootpath/$autofsmountpoint/$motiontargetsubdir
    [%%motionframerate%%]=$motionframerate
    [%%motionmaxmovietime%%]=$motionmaxmovietime
    [%%motionoutputpictures%%]=$motionoutputpictures
    [%%motionstreammaxrate%%]=$motionstreammaxrate
    [%%motionstreamlocalhost%%]=$motionstreamlocalhost
    [%%muttsendmailshfile%%]=$muttsendmailshfile
    [%%motiondetectedmailbodyfile%%]=$motiondetectedmailbodyfile    
    [%%picturesavedmailbodyfile%%]=$picturesavedmailbodyfile
    [%%motionplaycmd%%]=$motionplaycmd    
    [%%motionplaysound%%]=$motionplaysound
    [%%kodiplaycmd%%]=$kodiplaycmd    
    [%%kodiplaysound%%]=$kodiplaysound
    [%%motiontimelapseinterval%%]=$motiontimelapseinterval
)
strreplace
cp -f $tempfile $motioncfgfile
service motion restart

# Mutt Config
#muttrcfile="$TESTDIR/.muttrc"
cp -f $SCRIPTPATH/src/muttrc $tempfile
declare -A confs
confs=(
    [%%mailrealname%%]=$mailrealname
    [%%mailfrom%%]=$mailfrom
)
strreplace
cp -f $tempfile $muttrcfile

# Msmtp Config
#msmtprcfile="$TESTDIR/.msmtprc"
cp -f $SCRIPTPATH/src/msmtprc $tempfile
declare -A confs
confs=(
    [%%mailaccountname%%]=$mailaccountname
    [%%mailservername%%]=$mailservername
    [%%mailserverport%%]=$mailserverport
    [%%mailfrom%%]=$mailfrom
    [%%mailuser%%]=$mailuser
    [%%mailpassword%%]=$mailpassword
)
strreplace
cp -f $tempfile $msmtprcfile

# Muttsendmail.sh
#muttsendmailshfile="$TESTDIR/muttsendmail.sh"
cp -f $SCRIPTPATH/src/muttsendmail.sh $tempfile
declare -A confs
confs=(
    [%%motionstreamurl%%]=$motionstreamurl
    [%%mailto%%]=$mailto
)
strreplace
cp -f $tempfile $muttsendmailshfile
chmod 700 $muttsendmailshfile

# Mail body template files
cp -f $SCRIPTPATH/src/motiondetectedmail.body $motiondetectedmailbodyfile
cp -f $SCRIPTPATH/src/picturesavedmail.body $picturesavedmailbodyfile

# Sound effects
cp -Rf $SCRIPTPATH/sounds $motionplaysoundpath
/usr/bin/amixer set Headphone 100%

# Kodi script file
cp -f $SCRIPTPATH/src/post2kodi.sh  $tempfile
declare -A confs
confs=(
    [%%kodiuser%%]=$kodiuser
    [%%kodipass%%]=$kodipass
    [%%kodiaddress%%]=$kodiaddress
    [%%kodiport%%]=$kodiport
)
strreplace
cp -f $tempfile $kodiscriptfile
chmod 700 $kodiscriptfile

# Motion start script
cp -f $SCRIPTPATH/src/motion-up.sh $motionupscriptfile
chmod 700 $motionupscriptfile

# Domoticz user creation
if id -u "$domoticzuser" >/dev/null 2>&1; then
  echo "$domoticzuser : user exists"
else
  adduser --quiet --disabled-password --shell /bin/bash --home /home/$domoticzuser --gecos "$domoticzname" $domoticzuser
  echo "$domoticzuser:$domoticzpass" | chpasswd
fi

# Domoticz download
mkdir -p /etc/domoticz/
OS=`lowercase \`uname -s\``
MACH=`uname -m`
if [ ${MACH} = "armv6l" ]
then
 MACH="armv7l"
fi
echo "::: Destination folder=${domoticzworkdir}"
if [[ ! -e $domoticzworkdir ]]; then
	echo "::: Creating ${domoticzworkdir}"
	mkdir -p $domoticzworkdir
	chown "${domoticzuser}":"${domoticzuser}" $domoticzworkdir
fi
cd $domoticzworkdir
wget -O domoticz_release.tgz "http://www.domoticz.com/download.php?channel=release&type=release&system=${OS}&machine=${MACH}"
echo "::: Unpacking Domoticz..."
tar xvfz domoticz_release.tgz
rm domoticz_release.tgz
Database_file="${domoticzworkdir}/domoticz.db"
if [ ! -f $Database_file ]; then
	echo "Creating database..."
	touch $Database_file
	chmod 644 $Database_file
	chown "${domoticzuser}":"${domoticzuser}" $Database_file
fi
{
	echo "Dest_folder=${domoticzworkdir}"
	echo "Enable_http=true"
	echo "HTTP_port=${domoticzwwwport}"
	echo "Enable_https=true"
	echo "HTTPS_port=${domoticzsslport}"
}>> "/etc/domoticz/setupVars.conf"

# Domoticz service
cp -f $SCRIPTPATH/src/domoticz.service $tempfile
declare -A confs
confs=(
    [%%domoticzuser%%]=$domoticzuser
    [%%domoticzgroup%%]=$domoticzgroup
    [%%domoticzservicename%%]=$domoticzservicename
    [%%domoticzworkdir%%]=$domoticzworkdir
    [%%domoticzwwwport%%]=$domoticzwwwport
    [%%domoticzsslport%%]=$domoticzsslport
)
strreplace
cp -f $tempfile $domoticzservicefile
systemctl daemon-reload

# Gpio export (rc.local)
search='"exit 0"'
replace="exit with 0"
sed -i "s^${search}^${replace}^g" /etc/rc.local
search='exit 0'
replace="/usr/bin/gpio export 17 out\n/usr/bin/gpio export 18 out\n/usr/bin/gpio export 27 out\n/usr/bin/gpio export 22 out\n/usr/bin/gpio export 23 out\n/usr/bin/gpio export 24 out\n/usr/bin/gpio export 25 out\n/usr/bin/gpio export 12 out\n\n/usr/sbin/service $domoticzservicename start\n\nexit 0"
sed -i "s^${search}^${replace}^g" /etc/rc.local

# Delete temp file
rm -f $tempfile

echo Configuration done.
if [ ${vpnbootstart,,} = "yes" ]
then
        echo $vpnservicename service will start at boot time
else
	echo $vpnservicename service will NOT start at boot time
fi
if [ ${motionupbootstart,,} = "yes" ]
then
        echo $motionupservicename service will start at boot time
else
	echo $motionupservicename service will NOT start at boot time
fi

# Add server key to known hosts
echo $sshserverkey >> /root/.ssh/known_hosts

# Generate RSA key
ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""
echo RSA key generated. Please add it to the vpn server authorized keys :
echo ------------------------------------------
cat /root/.ssh/id_rsa.pub
echo ------------------------------------------
echo
echo Press any key to reboot \(CTRL-C to cancel\)
pressakey
reboot
