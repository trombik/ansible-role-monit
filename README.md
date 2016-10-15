ansible-role-monit
=====================

Configures monit.

Requirements
------------

None

Role Variables
--------------

| Variable | Description | Default |
|----------|-------------|---------|
| monit\_user | user of monit | {{ \_\_monit\_user }} |
| monit\_group | group of monit | {{ \_\_monit\_group }} |
| monit\_service | service name of monit | monit |
| monit\_conf\_dir | directory name where monitrc is | {{ \_\_monit\_conf\_dir }} |
| monit\_conf\_file | path to monitrc | {{ \_\_monit\_conf\_dir }}/monitrc |
| monit\_conf\_include\_dir | path to directory where all monit configuration fragments are | {{ \_\_monit\_conf\_include\_dir }} |
| monit\_flags | not used at the moment | "" |
| monit\_scripts | extra scripts in the role to be installed (optional) | [] |
| monit\_script\_path | path to directory to install extra scripts | {{ \_\_monit\_script\_path }} |
| monit\_conf\_daemon | poll cycle in sec | 10 |
| monit\_conf\_start\_delay | start delay in sec | 180 |
| monit\_conf\_httpd\_enable | enable http interface if true | true |
| monit\_conf\_httpd\_address | bind address of http interface | 127.0.0.1 |
| monit\_conf\_httpd\_port | bind port of http interface | 2812 |
| monit\_conf\_httpd\_allow | acl to allow | ["127.0.0.1"] |
| monit\_conf\_logfile\_syslog\_facility | syslog facility | log\_daemon |
| monit\_rc | dict of monit configs (see the example playbook) | {} |

## Debian

| Variable | Default |
|----------|---------|
| \_\_monit\_user | root |
| \_\_monit\_group | root |
| \_\_monit\_conf\_dir | /etc/monit |
| \_\_monit\_conf\_include\_dir | /etc/monit/monitrc.d |
| \_\_monit\_script\_path | /usr/sbin |

## FreeBSD

| Variable | Default |
|----------|---------|
| \_\_monit\_user | root |
| \_\_monit\_group | wheel |
| \_\_monit\_conf\_dir | /usr/local/etc |
| \_\_monit\_conf\_include\_dir | /usr/local/etc/monit.d |
| \_\_monit\_script\_path | /usr/local/sbin |

## OpenBSD

| Variable | Default |
|----------|---------|
| \_\_monit\_user | root |
| \_\_monit\_group | wheel |
| \_\_monit\_conf\_dir | /etc |
| \_\_monit\_conf\_include\_dir | /etc/monit.d |
| \_\_monit\_script\_path | /usr/local/sbin |

## RedHat

| Variable | Default |
|----------|---------|
| \_\_monit\_user | root |
| \_\_monit\_group | root |
| \_\_monit\_conf\_dir | /etc |
| \_\_monit\_conf\_include\_dir | /etc/monit.d |
| \_\_monit\_script\_path | /usr/sbin |

Created by [yaml2readme.rb](https://gist.github.com/trombik/b2df709657c08d845b1d3b3916e592d3)


Dependencies
------------

When the host is a RedHat variant,

- `ansible-role-redhat-repo`

None for others.

## Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-monit
  vars:
    ssh_rc_command: "{% if (ansible_os_family == 'FreeBSD' or ansible_os_family == 'OpenBSD') %}/etc/rc.d/sshd{% else %}/etc/init.d/ssh{% endif %}"
    monit_conf_start_delay: 0 # disable delay during kittchen test because monit does not listen immediately
    monit_scripts:
      - isakmpd_start
    monit_rc:
      sshd: |
        check process sshd with pidfile /var/run/sshd.pid
          start program "{{ ssh_rc_command }} start"
          stop program  "{{ ssh_rc_command }} stop"
          every 2 cycles
          if failed port 22 protocol ssh then restart
```

### RedHat

```yaml
- hosts: localhost
  roles:
    - ansible-role-redhat-repo
    - ansible-role-monit
  vars:
    ssh_rc_command: /etc/init.d/ssh
    monit_conf_start_delay: 0 # disable delay during kittchen test because monit does not listen immediately
    monit_scripts:
      - isakmpd_start
    monit_rc:
      sshd: |
        check process sshd with pidfile /var/run/sshd.pid
          start program "{{ ssh_rc_command }} start"
          stop program  "{{ ssh_rc_command }} stop"
          every 2 cycles
          if failed port 22 protocol ssh then restart
    redhat_repo_extra_packages:
      - epel-release
    redhat_repo:
      epel:
        mirrorlist: "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-{{ ansible_distribution_major_version }}&arch={{ ansible_architecture }}"
        gpgcheck: yes
        enabled: yes
```
License
-------

Copyright (c) 2016 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Author Information
------------------

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

This README was created by [ansible-role-init](https://gist.github.com/trombik/d01e280f02c78618429e334d8e4995c0)
