import io
import math
import os
import sys


def test_pep8():
    pass


print(sys.stdout.encoding)
print(sys.getdefaultencoding())
sys.stdout = io.TextIOWrapper(sys.stdout.detach(), encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.detach(), encoding='utf-8')
print(sys.stdout.encoding)
print(sys.getdefaultencoding())
print('汉语/漢語')

print(__name__)
print(os.getcwd())
print(os.path.join(os.getcwd(), os.path.dirname(__file__)))
print(set([]))
print(math.exp(-0.26268660809250016))
print(math.exp(-1.4652633398537678))
print(math.exp(-0.510825623765990))
print(math.exp(-0.916290731874155))


print(max([(1, 0), (0, 100)]))

FREQ = {'中': 1, '中国': 2}
test = "abc"
print(test[2:3])

print(set((
    "the", "of", "is", "and", "to", "in", "that", "we", "for", "an", "are",
    "by", "be", "as", "on", "with", "can", "if", "from", "which", "you", "it",
    "this", "then", "at", "have", "all", "not", "one", "has", "or", "that"
)))


print(10 // 2)
print(11 // 2)
print(11.5 // 2)
