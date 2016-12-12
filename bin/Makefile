
get:
	wget -O xterm-bg.sh "https://gist.githubusercontent.com/blueyed/c8470c2aad3381c33ea3/raw/1daac38ab42dcfd79471c630bee24570c162acdc/xterm-bg.sh"
	chmod 744 ~/bin/xterm-bg.sh

IMAPREPO=mswork
IMAPUIDFILE=${HOME}/tmp/${IMAPREPO}.offlineimap-invalid-uid
IMAPUID=`sort -u ${IMAPUIDFILE} | tr '\n' ','`
# | sed -e 's/,.$//g'
imapClean:
	@${HOME}/bin/imapCleanup.pl ${IMAPREPO} ${IMAPUID}
	@rm -f ${IMAPUIDFILE}
	@touch ${IMAPUIDFILE}
