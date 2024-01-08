#!/bin/sh
# create /data/wpa_supplicant.conf if not exists.
# second /bin/exists is no-op.
CONFIG_FILE_IN=/etc/wifi.script/wpa_supplicant.conf.in
WPA_CONF="/data/wifi/wpa_supplicant.conf"
HOSTAPD_CONFIG_FILE_IN=/etc/wifi.script/hostapd_dev.conf.in
HOSTAPD_CONF="/data/wifi/hostapd.conf"


if /bin/exists ${WPA_CONF} ; then /bin/exists; else
  /bin/cat ${CONFIG_FILE_IN} > ${WPA_CONF}
fi

if /bin/exists ${HOSTAPD_CONF} ; then /bin/exists; else
  /bin/cat ${HOSTAPD_CONFIG_FILE_IN} > ${HOSTAPD_CONF}
fi

# Copy if wpa_supplicant.conf is corrupted.
# When wpa_suppliacnt.conf is corrupted, possibly due to power
# failure during write or file system corruption, file size
# is truncated to 0. Check "ctrl_interface" to make sure it is
# configured and can talk to clients, such as eureka_shell.
if grep -w ctrl_interface ${WPA_CONF}; then /bin/exists; else
  /bin/cat ${CONFIG_FILE_IN} > ${WPA_CONF}
fi
if grep -w ctrl_interface ${HOSTAPD_CONF}; then /bin/exists; else
  /bin/cat ${HOSTAPD_CONFIG_FILE_IN} > ${HOSTAPD_CONF}
fi


chmod 0660 ${WPA_CONF}
chown wifi:wifi ${WPA_CONF}

chmod 0660 ${HOSTAPD_CONF}
chown wifi:wifi ${HOSTAPD_CONF}
