:foreach i in=[/ip address find] do={
  :local ipaddr [/ip address get $i address]
  :local intf [/ip address get $i interface]
  :if ([:pick $ipaddr ([:find $ipaddr "/"] + 1) [:len $ipaddr]] != "32") do={
    :put "Scanning subnet: $ipaddr on interface $intf"
    /tool ip-scan interface=$intf address-range=$ipaddr duration=6s
    :delay 1s
  } else={
    :put "Skipping $ipaddr sur $intf"
  }
}

:local vendorMap {
  "18:FD:74"="Mikrotik";
  "78:9A:18"="Mikrotik";
  "60:22:32"="Ubiquiti Networks";
  "18:E8:29"="Ubiquiti Networks"
}

:foreach ID in=[/interface bridge host find] do={
  :local inf [/interface bridge host get $ID interface]
  :local mac [/interface bridge host get $ID mac-address]
  :if ([:len $mac] > 0 and $mac != "" and [:pick $mac 0 5] != "BA:BE") do={
    :local ip
    :local hostname
    :local vendor "Unknown"
    :local lease [/ip dhcp-server lease find mac-address=$mac]
    :if ([:len $lease] > 0) do={
      :set ip [/ip dhcp-server lease get [:pick $lease 0] address]
      :set hostname [/ip dhcp-server lease get [:pick $lease 0] host-name]
    } else={
      :local arp [/ip arp find mac-address=$mac]
      :if ([:len $arp] > 0) do={
        :set ip [/ip arp get [:pick $arp 0] address]
      }
    }
    :if ([:len $ip] > 0) do={
      :local macPrefix [:pick $mac 0 8]
      :if ([:typeof ($vendorMap->$macPrefix)] != "nothing") do={
        :set vendor ($vendorMap->$macPrefix)
      } else={
        :local url ("http://d0wn.com/mac.php?mac=" . $mac)
        :do {
          :local result [/tool fetch url=$url mode=http http-method=get as-value output=user]
          :if (($result->"status") = "finished") do={
            :set vendor ($result->"data")
          }
        } on-error={
          :set vendor "Unknown (fetch failed)"
        }
      }
      :if ([:len $hostname] > 0) do={
        :put "interface=$inf mac=$mac ip=$ip hostname=$hostname vendor=$vendor"
      } else={
        :put "interface=$inf mac=$mac ip=$ip vendor=$vendor"
      }
    }
  }
}
