# How to run

## TL/DR:
1- Remember to export the remote host password:

```bash
export ANSIBLE_PASSWD="your_remote_host_password"
```

And then you can run the playbook. There's a fixed host entry.

```bash
cd ansible && ansible-playbook -i hosts.yml ubuntu.yml -c paramiko -e ansible_password='{{ lookup("env", "ANSIBLE_PASSWD" )}}' --ask-become-pass
```
