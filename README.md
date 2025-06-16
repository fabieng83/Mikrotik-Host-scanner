# MikroTik Network Discovery Script

## Overview
This MikroTik script is designed to scan and discover devices on a network by analyzing IP addresses and MAC addresses on the router's interfaces. It performs an IP scan on non-point-to-point subnets, retrieves device information from the bridge host table, and attempts to identify device vendors based on their MAC addresses. The script outputs details such as interface, MAC address, IP address, hostname (if available), and vendor information.

## Capabilities
1. **Subnet Scanning**:
   - Iterates through all IP addresses configured on the router.
   - Performs an IP scan on these subnets using the `/tool ip-scan` command to discover devices.

2. **Device Information Retrieval**:
   - Scans the bridge host table to retrieve MAC addresses and their associated interfaces.
   - Filters out invalid or specific MAC addresses (e.g., those starting with "BA:BE").
   - Retrieves IP addresses and hostnames (if available) from DHCP leases or ARP table entries.

3. **Vendor Lookup**:
   - Uses a predefined `vendorMap` to map MAC address prefixes to known vendors (e.g., MikroTik, Ubiquiti Networks).
   - For unknown MAC prefixes, performs an HTTP request to an external service (`http://d0wn.com/mac.php`) to fetch vendor information.
   - Falls back to "Unknown" or "Unknown (fetch failed)" if the lookup fails.

4. **Output**:
   - Prints detailed information for each discovered device, including:
     - Interface name
     - MAC address
     - IP address
     - Hostname (if available)
     - Vendor name

## Vendor Map  Speed Optimization
The script includes a `vendorMap` dictionary that maps MAC address prefixes to vendor names for quick lookup. By default, it includes entries for MikroTik and Ubiquiti Networks devices. To accelerate vendor identification and reduce external HTTP requests, you can expand the `vendorMap` by adding more MAC address prefixes and their corresponding vendors. For example:

```mikrotik
:local vendorMap {
  "18:FD:74"="Mikrotik";
  "78:9A:18"="Mikrotik";
  "60:22:32"="Ubiquiti Networks";
  "18:E8:29"="Ubiquiti Networks";
  "00:15:5D"="TP-Link";
  "00:0C:29"="VMware"
}
```

Adding more entries to `vendorMap` reduces reliance on the external lookup service, improving performance.

## Usage
1. Copy the script file into you mikrotik device 
2. Run the script using the command: `/import host.rsc`.
3. Monitor the output in the terminal for discovered devices and their details.

## Notes
- Ensure the router has internet access if you rely on the external vendor lookup service (`http://d0wn.com/mac.php`).
- Modify the `vendorMap` to include MAC prefixes for devices commonly found in your network to optimize performance.
- The script skips point-to-point IP addresses (e.g., /32 subnets) to avoid unnecessary scanning.


## Example Output
```
interface=ether2 mac=3C:1B:F8:35:69:1A ip=10.10.230.66 vendor=Hangzhou Hikvision Digital Technology Co.Ltd.
interface=ether2 mac=74:3F:C2:D6:F8:B5 ip=10.10.230.75 vendor=Hangzhou Hikvision Digital Technology Co.,Ltd.
interface=ether2 mac=74:3F:C2:D6:F8:CE ip=10.10.230.77 vendor=Hangzhou Hikvision Digital Technology Co.,Ltd.
interface=ether2 mac=74:3F:C2:D6:F8:D9 ip=10.10.230.76 vendor=Hangzhou Hikvision Digital Technology Co.,Ltd.
interface=ether2 mac=74:3F:C2:D6:F8:ED ip=10.10.230.78 vendor=Hangzhou Hikvision Digital Technology Co.,Ltd.
interface=ether4 mac=E8:A0:ED:AA:7B:D5 ip=10.10.230.74 vendor=Hangzhou Hikvision Digital Technology Co.Ltd.
interface=ether4 mac=E8:A0:ED:AA:7B:FE ip=10.10.230.67 vendor=Hangzhou Hikvision Digital Technology Co.Ltd.
interface=ether4 mac=E8:A0:ED:AA:7C:15 ip=10.10.230.69 vendor=Hangzhou Hikvision Digital Technology Co.Ltd.
interface=ether4 mac=E8:A0:ED:AA:7C:19 ip=10.10.230.68 vendor=Hangzhou Hikvision Digital Technology Co.Ltd.
interface=ether4 mac=E8:A0:ED:AA:7C:57 ip=10.10.230.71 vendor=Hangzhou Hikvision Digital Technology Co.Ltd.
interface=ether4 mac=E8:A0:ED:AA:7C:7A ip=10.10.230.73 vendor=Hangzhou Hikvision Digital Technology Co.Ltd.
interface=ether4 mac=E8:A0:ED:AA:7C:9E ip=10.10.230.70 vendor=Hangzhou Hikvision Digital Technology Co.Ltd.
interface=ether6 mac=E8:A0:ED:AA:7C:A0 ip=10.10.230.72 vendor=Hangzhou Hikvision Digital Technology Co.Ltd.
interface=ether6 mac=BE:BE:02:3D:B1:BF ip=192.168.131.115 hostname=SFA vendor=Inconnu
interface=ether6 mac=00:E6:3A:23:82:80 ip=10.10.234.198 vendor=Ruckus Wireless
interface=ether6 mac=34:15:93:06:83:20 ip=10.10.234.228 vendor=Ruckus Wireless
interface=ether6 mac=34:15:93:06:98:30 ip=10.10.234.252 vendor=Ruckus Wireless
interface=ether6 mac=34:15:93:06:C8:80 ip=10.10.234.209 vendor=Ruckus Wireless
interface=ether3 mac=34:15:93:06:C8:F0 ip=10.10.234.196 vendor=Ruckus Wireless
interface=ether3 mac=34:15:93:07:1E:60 ip=10.10.234.203 vendor=Ruckus Wireless
interface=ether3 mac=34:15:93:07:46:00 ip=10.10.234.206 vendor=Ruckus Wireless
interface=ether3 mac=34:15:93:07:50:50 ip=10.10.234.253 vendor=Ruckus Wireless
interface=ether3 mac=34:15:93:07:56:00 ip=10.10.234.254 vendor=Ruckus Wireless
interface=ether3 mac=78:9A:18:36:F9:D5 ip=10.10.234.52 vendor=Mikrotik
interface=ether3 mac=78:9A:18:F7:82:71 ip=10.10.234.56 vendor=Mikrotik
interface=ether3 mac=78:9A:18:F8:7E:55 ip=10.10.234.55 vendor=Mikrotik
interface=ether3 mac=D4:01:C3:69:6B:2A ip=10.10.234.43 vendor=Routerboard.com
interface=ether3 mac=D4:01:C3:69:6B:3A ip=10.10.234.44 vendor=Routerboard.com
interface=ether3 mac=D4:01:C3:69:6B:45 ip=10.10.234.49 vendor=Routerboard.com
interface=ether3 mac=D4:01:C3:69:6B:AA ip=10.10.234.48 vendor=Routerboard.com
interface=ether3 mac=D4:01:C3:69:6C:1C ip=10.10.234.47 vendor=Routerboard.com
interface=ether3 mac=D4:01:C3:69:6C:25 ip=10.10.234.46 vendor=Routerboard.com
interface=ether3 mac=D4:01:C3:69:6C:52 ip=10.10.234.45 vendor=Routerboard.com
Script file loaded and executed successfully

```
