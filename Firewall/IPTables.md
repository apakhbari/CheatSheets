# IPTables Cheatsheet
```
 ___   _______  _______  _______  _______  ___      _______  _______ 
|   | |       ||       ||   _   ||  _    ||   |    |       ||       |
|   | |    _  ||_     _||  |_|  || |_|   ||   |    |    ___||  _____|
|   | |   |_| |  |   |  |       ||       ||   |    |   |___ | |_____ 
|   | |    ___|  |   |  |       ||  _   | |   |___ |    ___||_____  |
|   | |   |      |   |  |   _   || |_|   ||       ||   |___  _____| |
|___| |___|      |___|  |__| |__||_______||_______||_______||_______|
```


- List all rules
```
$ iptables -L
```

- List all rules with line numbers
```
$ iptables -L --line-numbers
```

- Add a rule
- This line will add a rule to the INPUT chain.
```
# Accept TCP 10050 from IP address x.x.x.x
$ iptables -A INPUT -p tcp -s x.x.x.x --dport 10050 -j ACCEPT

# Accept UDP 161 from IP address x.x.x.x
$ iptables -A INPUT -p udp -s x.x.x.x --dport 161 -j ACCEPT
```


- Insert an INPUT rule at line number

```
# Inserts Accept TCP 3306 for ip x.x.x.x at INPUT chain line 6.
$ iptables -I INPUT 6 -p tcp -s x.x.x.x --dport 3306 -j ACCEPT

# Inserts Accept UDP 161 for ip x.x.x.x at INPUT chain line 4.
$ iptables -I INPUT 4 -p udp -s x.x.x.x --dport 161 -j ACCEPT
```

- Block a port
- After allowing a rule, you can block a port for every other IP address not already specifically accepted.


```
# Block UDP 161 for all IP addresses
$ iptables -A INPUT -p udp --dport 161 -j DROP

# Block TCP 9100 for all ip addresses
$ iptables -A INPUT -p tcp --dport 9100 -j DROP
```

- Delete a rule at line number

```
# Deletes the rule on INPUT chain at line 3
$ iptables -D INPUT 3
```

Create a NAT PREROUTING rule

# Redirects external TCP port 443 requests onto localhost port 3000
sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 3000
List NAT rules

iptables -t nat -L
Persisting IPTables rules.
After rebooting a server, you many lose your IPTables rules. So to prevent that, you can install iptables-persistent.


sudo apt install iptables-persistent
This will save your settings into two files called,

/etc/iptables/rules.v4

/etc/iptables/rules.v6

Any changes you make to the iptables configuration won't be auto saved to these persistent files, so if you want to update these files with any changes, then use the commands,


iptables-save > /etc/iptables/rules.v4

iptables-save > /etc/iptables/rules.v6
## IPTables Help
```
$ iptables -h
```

iptables v1.8.4

Usage: iptables -[ACD] chain rule-specification [options]
       iptables -I chain [rulenum] rule-specification [options]
       iptables -R chain rulenum rule-specification [options]
       iptables -D chain rulenum [options]
       iptables -[LS] [chain [rulenum]] [options]
       iptables -[FZ] [chain] [options]
       iptables -[NX] chain
       iptables -E old-chain-name new-chain-name
       iptables -P chain target [options]
       iptables -h (print this help information)

Commands:
Either long or short options are allowed.
  --append  -A chain            Append to chain
  --check   -C chain            Check for the existence of a rule
  --delete  -D chain            Delete matching rule from chain
  --delete  -D chain rulenum
                                Delete rule rulenum (1 = first) from chain
  --insert  -I chain [rulenum]
                                Insert in chain as rulenum (default 1=first)
  --replace -R chain rulenum
                                Replace rule rulenum (1 = first) in chain
  --list    -L [chain [rulenum]]
                                List the rules in a chain or all chains
  --list-rules -S [chain [rulenum]]
                                Print the rules in a chain or all chains
  --flush   -F [chain]          Delete all rules in  chain or all chains
  --zero    -Z [chain [rulenum]]
                                Zero counters in chain or all chains
  --new     -N chain            Create a new user-defined chain
  --delete-chain
            -X [chain]          Delete a user-defined chain
  --policy  -P chain target
                                Change policy on chain to target
  --rename-chain
            -E old-chain new-chain
                                Change chain name, (moving any references)
Options:
    --ipv4      -4              Nothing (line is ignored by ip6tables-restore)
    --ipv6      -6              Error (line is ignored by iptables-restore)
[!] --protocol  -p proto        protocol: by number or name, eg. 'tcp'
[!] --source    -s address[/mask][...]
                                source specification
[!] --destination -d address[/mask][...]
                                destination specification
[!] --in-interface -i input name[+]
                                network interface name ([+] for wildcard)
 --jump -j target
                                target for rule (may load target extension)
  --goto      -g chain
                              jump to chain with no return
  --match       -m match
                                extended match (may load extension)
  --numeric     -n              numeric output of addresses and ports
[!] --out-interface -o output name[+]
                                network interface name ([+] for wildcard)
  --table       -t table        table to manipulate (default: 'filter')
  --verbose     -v              verbose mode
  --wait        -w [seconds]    maximum wait to acquire xtables lock before give up
  --wait-interval -W [usecs]    wait time to try to acquire xtables lock
                                default is 1 second
  --line-numbers                print line numbers when listing
  --exact       -x              expand numbers (display exact values)
[!] --fragment  -f              match second or further fragments only
  --modprobe=<command>          try to insert modules using this command
  --set-counters PKTS BYTES     set the counter during insert/append
[!] --version   -V              print package version.