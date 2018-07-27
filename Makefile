_default:
	@echo "Ensure you've installed: augeas, openssh-server, bind-utils, xauth, and kerberos"

install_debian:
	-apt-get update
	-export DEBIAN_FRONTEND=noninteractive; apt-get -y install augeas-tools openssh-server krb5-user dnsutils xauth

install_fedora:
	-dnf -y install augeas openssh-server krb5-workstation bind-utils xorg-x11-xauth

configure_root_k5login:
	-touch /root/.k5login
	-restorcon -F /root/.k5login

install_sshd_config:
	cat etc/ssh/sshd_config > /etc/ssh/sshd_config
	
enable_sshd:
	-systemctl enable sshd.service
	-systemctl restart sshd.service

install_makehostkeys:
	cp usr/local/bin/makehostkeys /usr/local/bin/makehostkeys
	chmod 755 /usr/local/bin/makehostkeys

configure_krb5_conf:
	echo "set /files/etc/krb5.conf/libdefaults/dns_lookup_kdc true" | augtool -s
	echo "set /files/etc/krb5.conf/libdefaults/default_realm FNAL.GOV" | augtool -s

install: install_debian install_fedora configure_root_k5login install_sshd_config enable_sshd install_makehostkeys configure_krb5_conf
	@echo "##################################################"
	@echo ""
	@echo "For DHCP systems you should setup your DHCP Client ID."
	@echo " Some systems set this up automatically some don't."
	@echo ""
	@echo " I'll try and test to see if you are lucky"
	@echo "#######BEGIN RESULT#########"
	dig `hostname -s` +search +nocomments +nostats +noquestion | grep -v ';' | grep -v 'root-servers.net'
	@echo "####### END RESULT #########"
	@echo ""
	@echo " The above RESULT may indicate your expected hostname."
	@echo ""
	@echo "Remaining steps:"
	@echo " 1. Setup your host with DNS"
	@echo "     Test with:"
	@echo "       dig `hostname -s` +search +nocomments"
	@echo "       ifconfig -a"
	@echo " 2. Request a new host key"
	@echo "     Via Service Desk"
	@echo " 3. Once the new key is approved run makehostkeys"
	@echo "     sudo makehostkeys -n myhostname.example.com"
	@echo " 4. Restart sshd or reboot your computer"
	@echo ""
