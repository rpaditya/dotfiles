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
	-@/usr/bin/fetch -T 10 -q -4 --no-verify-peer -o /dev/null "http://s.grot.org/ping?h=some.grot.org" "http://pnw-grot.cloudapp.net/ping?h=some.grot.org" 2>1 /dev/null

reboot-required:
	uname -r; freebsd-version -k

apt:
	apt-cyg -m http://mirrors.163.com/cygwin/ update

#
# count how many times in the last day a station has connected to our wlan
#
wlancount:
	bzgrep " connected" /var/log/messages | sed -e "s/.*gw.lan.grot.org //g" | sed -e "s/ wlan.*//g" | sort | uniq -c

#OUIDB="https://bugzilla.redhat.com/attachment.cgi?id=126669"
OUIDB="https://code.wireshark.org/review/gitweb?p=wireshark.git;a=blob_plain;f=manuf"
FETCH=fetch -q -o
ethercodes:
	@${FETCH} ${HOME}/etc/ethercodes.dat ${OUIDB}

WIFIIF:=`netsh interface ipv6 show interface | grep Wi-Fi | /usr/bin/awk '{print $1}'`
mtu:
	netsh interface ipv6 show interface
	@echo "run as admin in cmd shell"
	@echo ${WIFIIF}
	netsh interface ipv6 set subinterface 14 mtu=1476 store=persistent

#netsh interface ipv6 set subinterface ${WIFIIF} mtu=1476 store=persistent

external-screen-only:
	#xrandr --output DP-1 --scale 1.5x1.5 --fb 8192x8192
	#xrandr --output DP-1 --scale 2x2 --fb 5120x2160 --panning 5120x2160
	xrandr --dpi 276 \
	--output eDP-1 --off \
	--output DP-1 --scale 1.5x1.5 --fb 3840x1620 --panning 3840x1620

dual-screen:
	xrandr --dpi 276 \
	--output eDP-1 --mode 1920x1080 \
	--output DP-1 --scale 1.5x1.5 --fb 3840x1620 --panning 3840x1620

screen-reset:
	xrandr --output eDP-1 --scale 1x1 --fb 1920x1080 --panning 1920x1080

turn-off-touchpad-on-external-mouse:
	gsettings set org.gnome.desktop.peripherals.touchpad send-events disabled-on-external-mouse

backup: backup-pictures

HOST=`hostname`
backup-pictures:
	rsync -av ~/Pictures some.ipv6:images.grot.org/up/${HOST}/
