##

**Ansible**

**Introduction**

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>ansible is agent-less so you don’t need to have it installed on servers
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>Yaml files are consisted of two parts, a list and a dictionary. indentation is 2 spaces
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>dictionary inside list

<span class="Apple-converted-space"> </span> shopping:

<span class="Apple-converted-space">   </span> - eggs: 1

<span class="Apple-converted-space">   </span> - milk: 2

<span class="Apple-converted-space">   </span> - fruit: apple

**——————————————————**

**Inventory files 101**

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>Inventories are used to keep hosts. it can have groups inside and groups can also be grouped together. you can create different ini files for stage and test and …
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>hosts.ini file is as follow:

web.mydomain.local

[db]

db1.mydomain.local

db2.mydomain.local

db3.mydomain.local

[web]

web1.mydomain.local

web2.mydomain.local

web3.mydomain.local

[customer1:children]

db

web

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>hosts.yaml:

all:

<span class="Apple-converted-space"> </span> hosts:

<span class="Apple-converted-space">   </span> web.mydomain.local

<span class="Apple-converted-space"> </span> children:

<span class="Apple-converted-space">   </span> customer1:

<span class="Apple-converted-space">     </span> children:

<span class="Apple-converted-space">       </span> db:

<span class="Apple-converted-space">         </span> hosts:

<span class="Apple-converted-space">           </span> db1.mydomain.local:

<span class="Apple-converted-space">           </span> db2.mydomain.local:

<span class="Apple-converted-space">       </span> web:

<span class="Apple-converted-space">         </span> hosts:

<span class="Apple-converted-space">           </span> web1.mydomain.local:

**——————————————————**

**Defining aws Inventory file**

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>$ asnible web -i aws.ini -m ping —> for using ping module<span class="Apple-converted-space"> </span>
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>aws.ini :

web ansible_host=ec2-18-130-249-7.eu-west-2.compute.amazonaws.com ansible_port=22 ansible_user=ec2-user ansible_ssh_private_key_file=/Users/Keys/ansible_lnd_key.pem

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>aws.yaml :

all:

<span class="Apple-converted-space"> </span> hosts:

<span class="Apple-converted-space">   </span> web:

<span class="Apple-converted-space">     </span> ansible_host: ec2-3-8-144-7.eu-west-2.compute.amazonaws.com

<span class="Apple-converted-space">     </span> ansible_port: 22

<span class="Apple-converted-space">     </span> ansible_user: ec2-user

<span class="Apple-converted-space">     </span> ansible_ssh_private_key_file: /Users/Keys/ansible_lnd_key.pem

**——————————————————**

**Running a playbook**

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>we want to install httpd on server, restart service, then remove it
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>$ ansible-playbook -i aws.ini playbook.yaml
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>playbook.yaml:<span class="Apple-converted-space"> </span>

* hosts: web

<span class="Apple-converted-space"> </span> remote_user: root

<span class="Apple-converted-space"> </span> become: yes

<span class="Apple-converted-space"> </span> tasks:

<span class="Apple-converted-space"> </span> - name: Install Apache

<span class="Apple-converted-space">   </span> yum:

<span class="Apple-converted-space">     </span> name: httpd

<span class="Apple-converted-space">     </span> state: installed

<span class="Apple-converted-space"> </span> - name: Restart Apache

<span class="Apple-converted-space">   </span> service:

<span class="Apple-converted-space">     </span> name: httpd

<span class="Apple-converted-space">     </span> state: restarted

<span class="Apple-converted-space"> </span> - name: Remove Apache

<span class="Apple-converted-space">   </span> yum:<span class="Apple-converted-space"> </span>

<span class="Apple-converted-space">     </span> name: httpd

<span class="Apple-converted-space">     </span> state: removed

**——————————————————**

Handlers

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>with handlers, you can send notiffication to a section of playbook, it is going to execute at the end when all other tasks are done, and it executes once
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>handler.yaml:

* hosts: web

<span class="Apple-converted-space"> </span> remote_user: root

<span class="Apple-converted-space"> </span> become: yes

<span class="Apple-converted-space"> </span> tasks:

<span class="Apple-converted-space"> </span> - name: Install Apache

<span class="Apple-converted-space">   </span> yum:

<span class="Apple-converted-space">     </span> name: httpd

<span class="Apple-converted-space">     </span> state: installed

<span class="Apple-converted-space">   </span> notify:

<span class="Apple-converted-space">     </span> - Restart Apache

<span class="Apple-converted-space"> </span> - name: Install nano

<span class="Apple-converted-space">   </span> yum:

<span class="Apple-converted-space">     </span> name: nano

<span class="Apple-converted-space">     </span> state: installed

<span class="Apple-converted-space">   </span> notify:

<span class="Apple-converted-space">     </span> - Restart Apache

<span class="Apple-converted-space"> </span> - name: Install MySQL

<span class="Apple-converted-space">   </span> yum:

<span class="Apple-converted-space">     </span> name: mysql

<span class="Apple-converted-space">     </span> state: installed

<span class="Apple-converted-space">   </span> notify:

<span class="Apple-converted-space">     </span> - Restart Apache

<span class="Apple-converted-space"> </span> handlers:

<span class="Apple-converted-space">   </span> - name: Restart Apache

<span class="Apple-converted-space">     </span> service:

<span class="Apple-converted-space">       </span> name: httpd

<span class="Apple-converted-space">       </span> state: restarted

**——————————————————**

Execute a command

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>command for seeing STDOUT : $ ansible-playbook -i aws.ini -vvvv cmd.yaml —> can use up to 4 Vs for extremely verbos
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>or for seeing output, you can add a register with a name, and then add debug
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>ansible by default use /bin/sh if you are using more complex stuff (redirection and wildcards) for commands, you have to set:
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>args:

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>executable: /bin/bash<span class="Apple-converted-space"> </span>

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>cmd.yaml:

* hosts: web

<span class="Apple-converted-space"> </span> remote_user: root

<span class="Apple-converted-space"> </span> become: yes

<span class="Apple-converted-space"> </span> tasks:

<span class="Apple-converted-space">   </span> - name: Curl AWS

<span class="Apple-converted-space">     </span> shell:<span class="Apple-converted-space"> </span>

<span class="Apple-converted-space">       </span> cmd: curl http://169.254.169.254/latest/meta-data/public-ipv4

<span class="Apple-converted-space">     </span> register: curl

<span class="Apple-converted-space">   </span> - debug: var=curl.stdout_lines

**——————————————————**

Variables

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>we can create variables inside ansible. also arrays could be created
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>It is right to pass in cli variables in command line using -e “basic_var=yo”
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>var.yaml:

http_port: 80

server_name: prod_dc01

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>var_file_demo.yaml:

* hosts: localhost

<span class="Apple-converted-space"> </span> vars_files:

<span class="Apple-converted-space">   </span> - vars.yaml

<span class="Apple-converted-space"> </span> tasks:

<span class="Apple-converted-space"> </span> - name: Display 1st Value

<span class="Apple-converted-space">   </span> debug:

<span class="Apple-converted-space">     </span> msg: "{{ http_port }}"

<span class="Apple-converted-space"> </span> - name: Display 2nd Value

<span class="Apple-converted-space">   </span> debug:

<span class="Apple-converted-space">     </span> msg: "{{ server_name }}"

$ ansible-playbook -e (EXTRA_VARS) “@vars.yaml” var_file_demo.yaml

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>you can use loop module to iterate a variable and do something with it. there are 2 approaches both demonstrated below
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>multi.yaml:

* hosts: web

<span class="Apple-converted-space"> </span> remote_user: root

<span class="Apple-converted-space"> </span> become: yes

<span class="Apple-converted-space"> </span> vars:

<span class="Apple-converted-space">   </span> packages:

<span class="Apple-converted-space">     </span> - httpd<span class="Apple-converted-space"> </span>

<span class="Apple-converted-space">     </span> - nano<span class="Apple-converted-space"> </span>

<span class="Apple-converted-space">     </span> - mysql

<span class="Apple-converted-space"> </span> tasks:

<span class="Apple-converted-space"> </span> - name: Install Software

<span class="Apple-converted-space">   </span> yum:

<span class="Apple-converted-space">     </span> name: "{{ item }}"

<span class="Apple-converted-space">     </span> state: installed

<span class="Apple-converted-space">   </span> loop: "{{ packages }}"

<span class="Apple-converted-space"> </span> - name: Remove Software

<span class="Apple-converted-space">   </span> yum:<span class="Apple-converted-space"> </span>

<span class="Apple-converted-space">     </span> name:<span class="Apple-converted-space"> </span>

<span class="Apple-converted-space">       </span> - httpd<span class="Apple-converted-space"> </span>

<span class="Apple-converted-space">       </span> - nano<span class="Apple-converted-space"> </span>

<span class="Apple-converted-space">       </span> - mysql

<span class="Apple-converted-space">     </span> state: removed

**——————————————————**

Roles

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>it is possible to make modular playbooks in order to re-use them
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>$ ansible-galaxy init apache —> creates these folders

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>/defaults —> default variables<span class="Apple-converted-space"> </span>
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>/files
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>/handlers
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>meta
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>tasks
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>templates
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>tests
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>/vars —> for overwritting defaults

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>for making role to work, should define /handlers/main.yaml and /tasks/main.yaml
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>for installing roles from third-company it is best practice to use below command, since ansible by default download roles to a systemic path and it is better to have it inside project, we specify roles path

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>$ ansible-galaxy install —roles-path . -r requirements.yaml

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>collections are a set of roles
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>In meta, you can create dependencies, so for example a role is dependent on another role, so it get executed after it

**——————————————————**

Vault

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>a way for keeping data secure. it encrypts the file. drawback of it is there is only 1 password also there is no key rotation
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>$ ansible-vault encrypt aws.yaml
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>$ansible-vault view aws.yaml
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>$ansible-vault rekey aws.yaml —> change password
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>$ ansible-vault decrypt aws.yaml

**——————————————————**

HashiCorp Vault

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>uninstall it if you’ve installed it using brew and install it with pip
