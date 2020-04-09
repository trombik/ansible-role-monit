# ansible-role-monit

Configures monit.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `monit_user` | user name of `monit` | `{{ __monit_user }}` |
| `monit_group` | group name of `monit` | `{{ __monit_group }}` |
| `monit_service` | service name of `monit` | `monit` |
| `monit_conf_dir` | base directory of `monit_conf_file` | `{{ __monit_conf_dir }}` |
| `monit_conf_file` | path to `monitrc` | `{{ monit_conf_dir }}/monitrc` |
| `monit_conf_include_dir` | path to directory where config fragment files reside | `{{ __monit_conf_include_dir }}` |
| `monit_conf_extra_include_directories` | see below | `[]` |
| `monit_flags` | TBW | `""` |
| `monit_scripts` | TBW | `[]` |
| `monit_script_path` | TBW | `{{ __monit_script_path }}` |
| `monit_rc` | see below | `{}` |
| `monit_config` | see below | `""` |

## `monit_conf_extra_include_directories`

This is a list of dict. The dict is described below. Each `path` to a directory
is included by `monit_conf_file` when `state` is `enabled`. The directory is
not included when `state` is `disabled`.

Note that the directories listed in the variable are assumed to be managed by
others, not the role. Therefore, the directory is NOT created when `state` is
`enabled` or removed when `state` is `disabled`.

| Name | Value | Mandatory? |
|------|-------|------------|
| `path` | path to the directory to be included | yes |
| `state` | state of the directory, either `enabled` or `disabled` | yes |

## `monit_rc`

This variable is a dict of configuration fragments that `monitrc` includes. The
key is descriptive name of the configuration, which is used as the file name.
The value is another dict, which is explained below.

| Name | Value | Mandatory? |
|------|-------|------------|
| `state` | state of the configuration, either `present` or `absent`. the file is created when `present`, removed when `absent` | yes |
| `content` | the content of the config | yes |

## `monit_config`

This is a variable of raw content of `monit_conf_file`. The value will be
inserted to `monit_conf_file`. The role adds `include` directives, after
`monit_config`, that include files with `.monitrc` file extension under
`monit_conf_include_dir` and `monit_conf_extra_include_directories`.

## Debian

| Variable | Default |
|----------|---------|
| `__monit_user` | `root` |
| `__monit_group` | `root` |
| `__monit_conf_dir` | `/etc/monit` |
| `__monit_conf_include_dir` | `/etc/monit/monitrc.d` |
| `__monit_script_path` | `/usr/sbin` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__monit_user` | `root` |
| `__monit_group` | `wheel` |
| `__monit_conf_dir` | `/usr/local/etc` |
| `__monit_conf_include_dir` | `/usr/local/etc/monit.d` |
| `__monit_script_path` | `/usr/local/sbin` |

## OpenBSD

| Variable | Default |
|----------|---------|
| `__monit_user` | `root` |
| `__monit_group` | `wheel` |
| `__monit_conf_dir` | `/etc` |
| `__monit_conf_include_dir` | `/etc/monit.d` |
| `__monit_script_path` | `/usr/local/sbin` |

## RedHat

| Variable | Default |
|----------|---------|
| `__monit_user` | `root` |
| `__monit_group` | `root` |
| `__monit_conf_dir` | `/etc` |
| `__monit_conf_include_dir` | `/etc/monit.d` |
| `__monit_script_path` | `/usr/sbin` |

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-monit
  vars:
    monit_config: |
      # disable delay during kittchen test because monit does not listen immediately
      set daemon 10
        with start delay 0
      set httpd port 2812
        use address 127.0.0.1
        allow 127.0.0.1
      set logfile syslog facility log_daemon

    monit_conf_extra_include_directories:
      - path: /usr/local/project/config/monit
        state: enabled
      - path: /no/such/dir
        state: disabled
    ssh_rc_command: "{% if (ansible_os_family == 'FreeBSD' or ansible_os_family == 'OpenBSD') %}/etc/rc.d/sshd{% else %}/etc/init.d/ssh{% endif %}"
    monit_scripts:
      - isakmpd_start
    monit_rc:
      sshd:
        state: present
        content: |
          check process sshd with pidfile /var/run/sshd.pid
            start program "{{ ssh_rc_command }} start"
            stop program  "{{ ssh_rc_command }} stop"
            every 2 cycles
            if failed port 22 protocol ssh then restart
      foo:
        state: absent
        content: "foo bar buz"
    redhat_repo:
      epel:
        mirrorlist: "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-{{ ansible_distribution_major_version }}&arch={{ ansible_architecture }}"
        gpgcheck: yes
        enabled: yes
```

# License

```
Copyright (c) 2016 Tomoyuki Sakurai <y@trombik.org>

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
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [ansible-role-init](https://gist.github.com/trombik/d01e280f02c78618429e334d8e4995c0)
