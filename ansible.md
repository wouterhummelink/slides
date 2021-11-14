# Ansible

![AAP Logo](images/ansible.png) <!-- {_ height="40%" width="40% style="border-width: 0;"  } -->

---

## Inhoud

* Wat is Ansible?
* Inventory
* Ad-hoc commands
* Playbooks
* Includes
* Conditionals & Loops
* Roles
* Collections
* Windows
* Best Practices
* Ansible Automation Platform
* Demo

---

## Wat is Ansible?

* Ansible is een tool waarmee taken geautomatiseerd kunnen worden
* Geschreven in python
* Agentless
* Communiceert via SSH, WinRM en meer
* Vereist python of powershell op te managen hosts

---

## Inventory

* Het inventory geeft aan welke machines/devices beheerd worden
* Bevat groepen die machines onderverdelen
* Kan een bestand zijn, maar ook een plugin of script (bijv. vanuit cloud, satellite etc.)

```ini
host1.example.com
host2.example.com
host3.example.com

[all:vars]
ansible_user=ansible

[web]
host[1:2].example.com

[db]
host3.example.com
```

---

## Ad-hoc commands

```bash
ansible all -m ping 
ansible all -m setup
ansible foo.example.com -m yum -a "name=httpd state=installed"
ansible foo.example.com -m command -a "/usr/sbin/reboot"
```

---

## Playbooks

--

```yaml
---
- hosts: webservers
  vars:
    http_port: 80
    max_clients: 200
  remote_user: root
  tasks:
  - yum:
      name: httpd
      state: latest
  - template:
      src: /srv/httpd.j2
      dest: /etc/httpd.conf
    notify:
    - restart apache
  - service:
      name: httpd
      state: started
      enabled: yes
  handlers:
    - service:
        name: httpd
        state: restarted
```
<!-- {_class="stretch"} -->

--

### Playbook Structuur

Een playbook bestaat uit een lijst "plays" met de volgende elementen

* `hosts` Een hostnaam, groep of range hosts
* `vars` Variabelen voor de play
* `tasks` Een lijst aan te roepen ansible modules
* `handlers` Een lijst optionele taken die kunnen worden gebruikt als nodig

Een playbook wordt uitgevoerd met de tool `ansible-playbook`

--

### Includes

Om grotere playbooks meer structuur te geven kan je het opsplitsen in meerdere files

```yaml
- hosts: webserver
  vars_files:
    - vars/webserver.yml
  tasks:
    - include_tasks: webserver.yml
```

---

## Conditionals & Loops

* Ansible staat toe om taken over te slaan met de `when` clausule
* Ansible staat het toe om taken meerdere keren uit te voeren met een variabele

--

## Conditionals

Gebruik `when` om een taak alleen uit te voeren als een bepaald fact of variable de juiste waarde heeft.

```yaml
- hosts: webservers
  tasks:
    - name: Install httpd
      yum:
        name: httpd
        state: installed
      when: ansible_distribution == "CentOS"
```

--

### Example 1: Loop over list

```yaml
- name: add several users
  user:
    name: "{{ item }}"
    state: present
    groups: "wheel"
  loop:
     - testuser1
     - testuser2
```

--

### Example 2: Loop over list van dictionaries

```yaml

- name: add several users
  user:
    name: "{{ item.name }}"
    state: present
    groups: "{{ item.groups }}"
  loop:
    - { name: 'testuser1', groups: 'wheel' }
    - { name: 'testuser2', groups: 'root' }     
```

--

### Example 3: Loop over dictionary

Met gebruik van de volgende variabelen:

```yaml
---
users:
  alice:
    name: Alice Appleworth
    telephone: 123-456-7890
  bob:
    name: Bob Bananarama
    telephone: 987-654-3210
```

Loop over en print de naam en telefoonnummer van de gebruiker

```yaml
tasks:
  - name: Print phone records
    debug:
      msg: "User {{ item.key }} is {{ item.value.name }} ({{ item.value.telephone }})"
    loop: "{{ lookup('dict', users) }}"
```

---

## Roles

In ansible kan je roles gebruiken om een project meer structuur te geven.
Ook kan je door de ansible playbooks in roles op te delen herbruikbare componenten maken.

--

## Roles - Structuur

```text
site.yml
webservers.yml
fooservers.yml
roles/
   common/
     tasks/
     handlers/
     files/
     templates/
     vars/
     defaults/
     meta/
   webservers/
     tasks/
     defaults/
     meta/
```

--

## Tasks & handlers in roles

```yaml
  - yum:
      name: httpd
      state: latest
  - template:
      src: /srv/httpd.j2
      dest: /etc/httpd.conf
    notify:
    - restart apache
```

--

## Vars & Defaults

Vars files geven waarden voor de roles

```yaml
http_port: 80
max_clients: 200
```

__**NB** Vars zijn altijd global.__

--

## Vars Precedentie

* extra vars (-e in the command line) always win
* connection variables (ansible_user, etc.)
* “most everything else” (command line switches, vars in play, included vars, role vars, etc.)
* facts discovered about a system
* variables defined in inventory
* “role defaults”, which lose in priority to everything and are the most easily overridden

[Documentation](http://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable)

--

## Een role gebruiken in een playbook (1)

Roles kunnen worden gebruikt in plaats van een tasks lijst

```yaml
- hosts: webservers
  vars:
    http_port: 8080
  roles:
    - common
    - webserver
```

--

## Een role gebruiken in een playbook (2)

__of__ als of het zelf een task is

```yaml
- hosts: webservers
  tasks:
    include_role:
      name: webservers
```

--

## Ansible Galaxy

* Ansible Galaxy is een website waar roles kunnen worden gedeeld en doorzocht
* `ansible-galaxy` is het commando om roles te downloaden
* `ansible-galaxy init` maakt snel een lege role structuur aan

---

## Collections

* Een ansible content collection is een bundeling van roles, ansible plugins en playbooks
* Collections worden aangeboden door redhat of via community

```text
collection/
├── docs/
├── galaxy.yml
├── meta/
│   └── runtime.yml
├── plugins/
│   ├── modules/
│   │   └── module1.py
│   ├── inventory/
│   └── .../
├── README.md
├── roles/
│   ├── role1/
│   ├── role2/
│   └── .../
├── playbooks/
│   ├── files/
│   ├── vars/
│   ├── templates/
│   └── tasks/
└── tests/
```

---

## Windows

--

## Ansible & Windows

* Ansible gebruikt om windows te benaderen WinRM & Powershell
* Controlnode blijft Linux
* Vereist de python module winrm op de controlnode
* Windows Server 2008 & Windows 7 of hoger
* AD authenticatie wordt ondersteund

--

## Beperkingen

Enkele dingen kunnen niet zomaar met Ansible en Windows:

* Upgrade PowerShell
* Aanpassen WinRM listeners

Deze zaken zijn beter op te lossen in OS-image of server bootstrap

--

## Inventory windows

```ini
[windows_webservers]
winweb01 ansible_connection=winrm ansible_port=5985
```

--

## Playbook windows

```yaml
- name: install-iis
  win_feature:
    name: "Web-Server"
    state: present
- name: default-website-index
  win_copy:
    src: files/index.html
    dest: "C:\\inetpub\\wwwroot\\index.html"
```

---

## Best Practices

* Always name tasks
* Use YAML syntax for tasks
* Keep it simple

--

## Always name tasks

Don't

```yaml
- yum:
    name: httpd
    state: installed
```

Do

```yaml
- name: Ensure web server software is installed
  yum:
    name: httpd
    state: installed
```

--

## Use YAML syntax

Don't

```yaml
- name: Install webserver
  yum: name=httpd state=installed  update_cache=yes
```

Do

```yaml
- name: Install webserver
  yum: 
    name: httpd 
    state: installed  
    update_cache: yes
```

--

## Keep it simple

When you can do something simply, do something simply. Do not reach to use every feature of Ansible together, all at once. Use what works for you. For example, you will probably not need vars, vars_files, vars_prompt and –extra-vars all at once, while also using an external inventory file.

If something feels complicated, it probably is, and may be a good opportunity to simplify things.

---

## Ansible Automation Platform

---

## Demo

---

## Links

This presentation: <https://wouterhummelink.github.io/slides/ansible.html>

* [Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
* [Roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
* [Ansible & Windows](https://docs.ansible.com/ansible/latest/user_guide/windows_usage.html)
