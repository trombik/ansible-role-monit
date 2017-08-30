### Backward incompatibilities

#### `monit_rc` supports `state`

`monit_rc` is now dict of dict and supports `state`, which enables to remove
configuration fragments. When previous `monit_rc` looks like:

```yaml
monit_rc:
  sshd:
    check process sshd with pidfile /var/run/sshd.pid
      start program "/bin/systemctl start sshd"
      stop program  "/bin/systemctl stop sshd"
      every 2 cycles
      if failed port 22 protocol ssh then restart
```

which must be rewritten to:

```yaml
monit_rc:
  sshd:
    state: present
    content: |
      check process sshd with pidfile /var/run/sshd.pid
        start program "/bin/systemctl start sshd"
        stop program  "/bin/systemctl stop sshd"
        every 2 cycles
        if failed port 22 protocol ssh then restart
```


## Release 1.0.0

* Initail release
