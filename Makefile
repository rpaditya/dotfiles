
all: batt

batt:
	powercfg /batteryreport

ssh:
	rm ${SSH_AUTH_SOCK}
	ssh-agent -a ${SSH_AUTH_SOCK}
	ssh-add ~/.ssh/id_rsa
