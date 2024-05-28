# pfsense

```
 _______  _______  _______  _______  __    _  _______  _______ 
|       ||       ||       ||       ||  |  | ||       ||       |
|    _  ||    ___||  _____||    ___||   |_| ||  _____||    ___|
|   |_| ||   |___ | |_____ |   |___ |       || |_____ |   |___ 
|    ___||    ___||_____  ||    ___||  _    ||_____  ||    ___|
|   |    |   |     _____| ||   |___ | | |   | _____| ||   |___ 
|___|    |___|    |_______||_______||_|  |__||_______||_______|
```

## Index

- Section1: theoretical
  - Tips and Tricks
- Section2: Configuration
  - First time setup (using wizard)
  - System Tab
  - Firewall Tab
  - Interface Tab
  - Services Tab
  - Vlan
  - Plugins
 
---
## Tips and Tricks
# Section1: Theoritical

---

## Tips and Tricks

- pfsense does not care whether an interface is LAN or WAN. Such thing will be set based on gateway an interface has.
- By setting a port to DHCP, you are implying that i want to get default gateway to come from DHCP --&gt; It is not going to be a LAN
- DNS is on UDP

- ---
## first time setup (using wizard)
# Section2: Configuration

---

## first time setup (using wizard)

by deafult, after setting up wizard, pfsense is pretty secure

- step 2 of 9: uncheck Override DNS
- step 4 of 9: Beware of "Blcok RFC1918 Networks" --&gt; it block private IP ranges
- step 4 of 9: Beware of "block Bogon Networks"
- step 5 of 9: Change LAN IP Address, default is 192.168.1.1, since this default is being used in lots of environments and you might want to use VPN some times to access your LAN network, it is convenient to change this. 192.168.55.1 is pretty good.
- After completion: change & edit dashboard via drag and using upper + . also it is good to remove support section.

## System Tab
System &gt; Advanced &gt; Admin Access:

- Web Configurator &gt; TCP Port: Default config of pfSense is to leave a HTTPS open in LAN-side. It is convenient to change TCP Port of this HTTPS since 443 is pretty common on lots of services and you might face some conflicts with other services. Recommended time is: 10443
- Web Configurator &gt; WabeGUI redirect: un-check it after you set everything, since it is always listening on port 80 to forward you to the port you have set (e.g. 10443) and consuming resources. just remember, whenever you want to access web dashboard enter Link completely (e.g. 192.168.55.1:10443)
- Secure Shell: Enables secure shell --&gt; SSH will only be open on LAN-side

System &gt; Advanced &gt; Firewall & NAT:

- Network Address Translation &gt; Nat Reflection Mode for port forwards (also called hairpin): change to "Pure NAT"

System &gt; User Manager:

- Create a user with admin privileges here.
- then disable "admin" user from entering system

## FireWall Tab
FireWall &gt; Rules &gt; Lan

- Anti-lockout rule: lan is where you want this rule to exist. its a rule that will stop you from writing a rule that lock you out of system. It purposes is to not allow you to stop yourself from logging in to pfsense.

FireWall &gt; Rules &gt; Lan &gt; Edit

- Default Protocol of creating a rule is TCP, beware that icmp, udp (dns) won't work if set on TCP only
- Add a rule to stop guest users get access to firewall web interface. source: any, destination: this firewall, port 10443, Protocol: TCP

FireWall &gt; Aliases

- It is being used for the times you want to assign a name to a set of IP addresses, just for ease of use

## Interface Tab
Interface &gt; Interface Assignment &gt; \[INTERFACE_NAME\]

- pfsense does not care whether an interdace is LAN or WAN. Such thing will be set based on gateway an interface has.
- Static IPV4 Configuration: its for the times you want interface to work as a WAN. so you assign upstream gateway on it to be working as desired.
- Don't forget to apply changes when you are finished

## Services Tab
Services &gt; DHCP Server:

- for every interface you create (vlan or physical interface), pfsense create a list on DHCP server.
- Define a range for IPs
- on up-right of screen there is an icon with description of "related log entries", when you click on it you can see DHCP Leases, so what you have is going to be listed

## VLan
- By default all traffic is flowing on Vlan1, so never use it
- convenient to use when you don't have luxury of using different physical interfaces.
- although Vlans share physical interface and share same bandwidth, they are really good at segmenting things.
- VLan priority is being used when you are using traffic shaping at switch level which prefer one traffic over another
- Be aware that when using VLan of pfsense on a hypervisor, some additional things most be set.

Interfaces &gt; Assignment

- we have to know which VLan is being assigned to which interface, which means what shared physical interface we are using for vlan
- Also don't forget to assign DHCP Server to each VLAN

## Status Tab
Top of most services has "related status page" icon, where you are redirected to related statuses

- <span style="color: rgb(255, 255, 255)">Status &gt; Captive portal: You can use Captive Portal so new users are being shown a window to login</span>

## Diagnostics Tab
- Packet Capture: really good tool that is like wireshark
- DNS lookup
- Test port

## Plugins
Q: Where does plugins show up? A: EveryWhere :) since there is not a centralized place for it, each plugin is going to end up where it belongs.

- acme (automated certificate management environment) --&gt; good for lets encrypt and haproxy. shows in Services
- arpwatch --&gt; check if any new MAC Address shows up on network and then notify you. Don't use on a LAN, use it on network of servers which has static IPs and everything is set.
- darkstat --&gt; gives you some good stats
- nmap
- pftop --&gt; a most have. have real good troubleshooting tools
- openvpn-client-export
- status-traffic-totals --&gt; gives you an overview of traffic over day/week/month. shows in Status tab
- suricata

# acknowledgment
## Contributors

APA 🖖🏻

## Links

```                                                                                                       
  aaaaaaaaaaaaa  ppppp   ppppppppp     aaaaaaaaaaaaa   
  a::::::::::::a p::::ppp:::::::::p    a::::::::::::a  
  aaaaaaaaa:::::ap:::::::::::::::::p   aaaaaaaaa:::::a 
           a::::app::::::ppppp::::::p           a::::a 
    aaaaaaa:::::a p:::::p     p:::::p    aaaaaaa:::::a 
  aa::::::::::::a p:::::p     p:::::p  aa::::::::::::a 
 a::::aaaa::::::a p:::::p     p:::::p a::::aaaa::::::a 
a::::a    a:::::a p:::::p    p::::::pa::::a    a:::::a 
a::::a    a:::::a p:::::ppppp:::::::pa::::a    a:::::a 
a:::::aaaa::::::a p::::::::::::::::p a:::::aaaa::::::a 
 a::::::::::aa:::ap::::::::::::::pp   a::::::::::aa:::a
  aaaaaaaaaa  aaaap::::::pppppppp      aaaaaaaaaa  aaaa
                  p:::::p                              
                  p:::::p                              
                 p:::::::p                             
                 p:::::::p                             
                 p:::::::p                             
                 ppppppppp                             
                                                       
```
