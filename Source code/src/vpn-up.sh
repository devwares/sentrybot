#!/bin/bash

# Loop to test ppp connection
while [ "0" -eq "0" ]
do

  export testppp=`/sbin/ip link show | grep ppp | grep -c UP`
  if [ "0" -eq "$testppp" ]; 
  then

    # Connect to VPN
    mkdir -p /var/run/xl2tpd
    touch /var/run/xl2tpd/l2tp-control
    service strongswan restart
    service xl2tpd restart
    ipsec up %%conname%%
    echo "c %%conname%%" > /var/run/xl2tpd/l2tp-control

  fi

  # Route to VPN hosts
  route add -net %%vpnsubnet%% netmask %%vpnsubnetmask%% gw %%internalvpnip%%

  # Wait before next test
  sleep 15

done
