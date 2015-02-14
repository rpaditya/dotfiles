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

twitter:
	${HOME}/sirc/sirc -q -Q -R -n rpaditya -s im.bitlbee.org