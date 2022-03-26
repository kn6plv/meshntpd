# meshntpd

## Replace AREDN's ntpclient with ntpd

When the service starts at boot time, it waits 120 seconds to allow OLSR to populate its *services_olsr* file with services on the mesh. It then tests the NTP Server entered on the **Basic Settings** page to see whether it is reachable. An NTP query is sent to determine reachability. If it is reachable on the network, then it is added to the top of the list of available NTP servers.

Next it searches for any NTP services found by OLSR and tests each one to determine if it is reachable across the network. If it is reachable then it is added to the list of available NTP servers for ntpd to query. The search process looks for "ntp" anywhere in the advertised service description field (upper or lowercase).

Once the server list is created, any other NTP-related processes are terminated (ntpclient or other running ntpd processes). If there are no reachable servers on the network, then ntpd is not started and a notice is logged in syslog. If there are reachable servers in the server list, then the embedded BusyBox ntpd process is started and the entire list of reachable servers is included. A notice is logged in syslog showing the list of reachable servers. These notices can be viewed from the node command line using:

```logread -e meshntpd```

BusyBox ntpd uses complex algorithms to gradually bring the system clock into alignment with network time. It periodically requests NTP updates and adjusts the clock over a period of time. ntpd typically uses the first or best available time server in its list, but if that server becomes unreachable then it should switch to using the next available peer.
