all: batt

batt:
	powercfg /batteryreport

sirc:
	export TERM=screen
	cp /usr/local/src/im/sirc-2.211/getopts.pl ~/lib/sirc/
	${HOME}/sirc/sirc -q -Q -R -n aditya -s 127.0.0.1

ssh:
	rm -f ${SSH_AUTH_SOCK}
	ssh-agent -a ${SSH_AUTH_SOCK}
	ssh-add ${HOME}/.ssh/id_rsa
	ssh-add ${HOME}/.ssh/id_dsa

twitter:
	${HOME}/sirc/sirc -q -Q -R -n rpaditya -s im.bitlbee.org

#	/usr/bin/fetch -4 --no-verify-peer -o - "https://grot.org/net/my_ip.cgi"
#	/usr/bin/fetch -q -4 --no-verify-peer -o - "http://pnw-grot.cloudapp.net/ping"
ping:
	-@/usr/bin/fetch -T 10 -q -4 --no-verify-peer -o /dev/null "http://s.grot.org/ping" "http://pnw-grot.cloudapp.net/ping" 2>1 /dev/null

reboot-required:
	uname -r; freebsd-version -k

apt:
	apt-cyg -m http://mirrors.163.com/cygwin/ update
