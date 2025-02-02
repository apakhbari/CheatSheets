## **Ansible**

### **Introduction**

- ansible is agent-less so you don’t need to have it installed on servers
- Yaml files are consisted of two parts, a list and a dictionary. indentation is 2 spaces
- dictionary inside list

  ```yaml
  shopping:
    - eggs: 1
    - milk: 2
    - fruit: apple
  ```

---

### **Inventory files 101**

- Inventories are used to keep hosts. it can have groups inside and groups can also be grouped together. you can create different ini files for stage and test and …
- hosts.ini file is as follow:

  ```ini
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
  ```

- hosts.yaml:

  ```yaml
  all:
    hosts:
      - web.mydomain.local
    children:
      customer1:
        children:
          db:
            hosts:
              - db1.mydomain.local
              - db2.mydomain.local
          web:
            hosts:
              - web1.mydomain.local
  ```

---

### **Defining aws Inventory file**

- `$ asnible web -i aws.ini -m ping` —> for using ping module
- aws.ini:

  ```ini
  web ansible_host=ec2-18-130-249-7.eu-west-2.compute.amazonaws.com ansible_port=22 ansible_user=ec2-user ansible_ssh_private_key_file=/Users/Keys/ansible_lnd_key.pem
  ```

- aws.yaml:

  ```yaml
  all:
    hosts:
      web:
        ansible_host: ec2-3-8-144-7.eu-west-2.compute.amazonaws.com
        ansible_port: 22
        ansible_user: ec2-user
        ansible_ssh_private_key_file: /Users/Keys/ansible_lnd_key.pem
  ```

---

### **Running a playbook**

- we want to install httpd on server, restart service, then remove it
- `$ ansible-playbook -i aws.ini playbook.yaml`
- playbook.yaml:

  ```yaml
  hosts: web
  remote_user: root
  become: yes
  tasks:
    - name: Install Apache
      yum:
        name: httpd
        state: installed
    - name: Restart Apache
      service:
        name: httpd
        state: restarted
    - name: Remove Apache
      yum:
        name: httpd
        state: removed
  ```

---

### **Handlers**

- with handlers, you can send notification to a section of playbook, it is going to execute at the end when all other tasks are done, and it executes once
- handler.yaml:

  ```yaml
  hosts: web
  remote_user: root
  become: yes
  tasks:
    - name: Install Apache
      yum:
        name: httpd
        state: installed
      notify:
        - Restart Apache
    - name: Install nano
      yum:
        name: nano
        state: installed
      notify:
        - Restart Apache
    - name: Install MySQL
      yum:
        name: mysql
        state: installed
      notify:
        - Restart Apache
  handlers:
    - name: Restart Apache
      service:
        name: httpd
        state: restarted
  ```

---

### **Execute a command**

- command for seeing STDOUT : `$ ansible-playbook -i aws.ini -vvvv cmd.yaml` —> can use up to 4 Vs for extremely verbose
- or for seeing output, you can add a register with a name, and then add debug
- ansible by default use /bin/sh if you are using more complex stuff (redirection and wildcards) for commands, you have to set:
  ```yaml
  args:
    executable: /bin/bash
  ```

- cmd.yaml:

  ```yaml
  hosts: web
  remote_user: root
  become: yes
  tasks:
    - name: Curl AWS
      shell:
        cmd: curl http://169.254.169.254/latest/meta-data/public-ipv4
      register: curl
    - debug: var=curl.stdout_lines
  ```

---

### **Variables**

- we can create variables inside ansible. also arrays could be created
- It is right to pass in cli variables in command line using `-e "basic_var=yo"`
- var.yaml:

  ```yaml
  http_port: 80
  server_name: prod_dc01
  ```

- var_file_demo.yaml:

  ```yaml
  hosts: localhost
  vars_files:
    - vars.yaml
  tasks:
    - name: Display 1st Value
      debug:
        msg: "{{ http_port }}"
    - name: Display 2nd Value
      debug:
        msg: "{{ server_name }}"
  ```

  `$ ansible-playbook -e (EXTRA_VARS) "@vars.yaml" var_file_demo.yaml`

- you can use loop module to iterate a variable and do something with it. there are 2 approaches both demonstrated below
- multi.yaml:

  ```yaml
  hosts: web
  remote_user: root
  become: yes
  vars:
    packages:
      - httpd
      - nano
      - mysql
  tasks:
    - name: Install Software
      yum:
        name: "{{ item }}"
        state: installed
      loop: "{{ packages }}"
    - name: Remove Software
      yum:
        name:
          - httpd
          - nano
          - mysql
        state: removed
  ```

---

### **Roles**

- it is possible to make modular playbooks in order to re-use them
- `$ ansible-galaxy init apache` —> creates these folders

  - `/defaults` —> default variables
  - `/files`
  - `/handlers`
  - `/meta`
  - `/tasks`
  - `/templates`
  - `/tests`
  - `/vars` —> for overwriting defaults

- for making role to work, should define `/handlers/main.yaml` and `/tasks/main.yaml`
- for installing roles from third-party it is best practice to use below command, since ansible by default downloads roles to a systemic path and it is better to have it inside project, we specify roles path

  ```bash
  $ ansible-galaxy install --roles-path . -r requirements.yaml
  ```

- collections are a set of roles
- In meta, you can create dependencies, so for example a role is dependent on another role, so it gets executed after it

---

### **Vault**

- a way for keeping data secure. it encrypts the file. drawback of it is there is only 1 password also there is no key rotation
- `$ ansible-vault encrypt aws.yaml`
- `$ ansible-vault view aws.yaml`
- `$ ansible-vault rekey aws.yaml` —> change password
- `$ ansible-vault decrypt aws.yaml`

---

### **HashiCorp Vault**

- uninstall it if you’ve installed it using brew and install it with pip