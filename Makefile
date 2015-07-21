
all: batt

batt:
	powercfg /batteryreport

ssh:
	rm -f ${SSH_AUTH_SOCK}
	ssh-agent -a ${SSH_AUTH_SOCK}
	ssh-add ${HOME}/.ssh/id_rsa

sirc:
	${HOME}/sirc/sirc -q -Q -R -n rpaditya -s 127.0.0.1

twitter:
	${HOME}/sirc/sirc -q -Q -R -n rpaditya -s im.bitlbee.org
