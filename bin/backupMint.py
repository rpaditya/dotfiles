import os
import urllib
import urllib2
import cookielib
from optparse import OptionParser
import datetime

class mintlib():
    
    def __init__(self):
        self.opener = urllib2.build_opener(urllib2.HTTPCookieProcessor())  # need cookies for the JSESSION ID
        urllib2.install_opener(self.opener)
        
    def login(self, username, password):
        request = urllib2.Request("https://wwws.mint.com/loginUserSubmit.xevent?task=L",  urllib.urlencode(locals()))
        request.add_header("User-Agent", "Mozilla/5.0") # Mint kicks to a "Upgrade to IE 7.0" page without this
        response = self.opener.open(request)
        
    def download(self, file):
        # write CSV file of all Mint transactions for this account to a file
        response = self.opener.open("https://wwws.mint.com/transactionDownload.event?") 
        open(file, "w").write(response.read())
        
    def logout(self):
        response = self.opener.open("https://wwws.mint.com/logout.event")         

def getOptions():
    arguments = OptionParser()
    arguments.add_options(["--username", "--password", "--file"])
    arguments.set_default("file", "mint_backup_%s.csv" % str(datetime.date.today()))
    return arguments.parse_args()[0] # options

if __name__ == '__main__':    
    options = getOptions()
    mint = mintlib()
    mint.login(options.username, options.password)
    mint.download(options.file)
    print "Done"
