# kerberize-ssh-fnal
Setup kerberos and on a generic linux box

# How To

You must install the following BEFORE using this:
* git
* make
* sudo

Once those are installed run the following:

```shell
git clone https://github.com/jcpunk/kerberize-ssh-fnal.git
cd kerberize-ssh-fnal
sudo make install
touch ~/.k5login
# Systems running selinux should do this
#   It will not hurt non-selinux systems
restorcon -F ~/.k5login >/dev/null 2>&1
```

You may also need to alter the host firewall to allow ssh access
