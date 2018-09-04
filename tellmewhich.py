# -*- coding: utf-8 -*-
from functools import reduce


def fn(x, y):
    return x * 26 + y


def char2num(s):
    return int(s, 36) - int('a', 36)


def str2num(str):
    return reduce(fn, map(char2num, str))


def num2str(num, size=4):
    str = ""
    devided = num
    while devided > 0 or len(str) < size:
        remain = devided % 26
        str = chr(remain + ord('a')) + str
        devided = devided // 26
    return str


print(str2num("aaab"))
print(num2str(1))
urldic = {}


def load_model():
    with open(r"C:\Users\shendezhou\github\finance\fourcharsdomain", "r") as file:
        print("opened")
        for line in file.readlines():
            urldic[line.replace(
                "https://www.", "").replace("http://www.", "").replace(".com/", "").strip()] = 1


load_model()

for n in range(26**4):
    domain = num2str(n)
    if domain not in urldic:
        #w = whois(domain + ".com")
        #print(domain, w)
        pass

print("=" * 30)
