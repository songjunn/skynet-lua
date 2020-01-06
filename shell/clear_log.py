import sys, os, time, datetime

localtime = time.asctime( time.localtime(time.time()) )
print "localtime :", localtime

now = datetime.datetime.now()
delta = datetime.timedelta(days=-7)
n_days = now + delta
day = n_days.strftime('%Y%m%d')
#print day
dirname, filename = os.path.split(os.path.abspath(sys.argv[0]))
#print dirname
#print filename

cmd = 'rm -rf '+dirname+'/../log/game-'+day+'-*.log'
print cmd
os.system(cmd)