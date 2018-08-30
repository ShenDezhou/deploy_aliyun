from itertools import chain
import sys

def asdf(arg):
    for i in xrange(10):
        yield i


def gen(arg):
    for i in xrange(10,0,-1):
        yield i
print 'hello'

def main():
    return chain(asdf(None), gen(None))

for i in main():
    print i

for i in (asdf(None), gen(None)):
    print i

print 100 or 1
print sys.float_info

min_rank=100
max_rank=999
unify=lambda w:(w - min_rank / 10.0) / (max_rank - min_rank / 10.0)
for x in xrange(100,1000,100):
    print x,unify(x)


print (10 - 100/10.0) / (999 - 100/10.0)

print (str,)

print sys.getfilesystemencoding()
print sys.version_info[0]
