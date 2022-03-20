#! /bin/sh

# Wait before attempting to configure server. This gives OLSRD time
# to find servers on the network
sleep 60

# NTP servers tend to be poorly advertised, so we have to use a bit of
# heuristics to find them
servers=""
for candidate in $(grep -i ntp /var/run/services_olsr | sed "s/^http:\/\/\(.*\):.*$/\1/")
do
    if $(ntpd -n -q -p ${candidate} > /dev/null 2>&1); then
        servers="${servers} -p ${candidate}"
    fi
done
candidate=$(uci -q get system.ntp.server)
if [ "${candidate}" != "" ]; then
    if $(ntpd -n -q -p ${candidate} > /dev/null 2>&1); then
        servers="${servers} -p ${candidate}"
    fi
fi

/etc/init.d/ntpclient stop 2> /dev/null
killall ntpd 2> /dev/null
if [ "${servers}" != "" ]; then
    ntpd ${servers}
fi
