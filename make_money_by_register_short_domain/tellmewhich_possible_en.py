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
    with open(r"C:\Users\shendezhou\github\finance\make_money_by_register_short_domain\searchengine\domain_en", "r") as file:
        print("opened")
        for line in file.readlines():
            key = line.replace(
                "https://www.", "").replace("http://www.", "").replace(".com/", "").strip()
            urldic[key] = 1


load_model()
print(num2str(26**4 - 1))
print(len(urldic))

index = 0

for n in range(26**4):
    domain = num2str(n)
    if domain not in urldic:
        #w = whois(domain + ".com")
<<<<<<< HEAD:make_money_by_register_short_domain/tellmewhich_possible_en.py
        if index % 1000 == 0:
            if file:
                file.close()
            fileid = index // 1000
            file = open(
                r"C:\Users\Administrator\github\finance\make_money_by_register_short_domain\possible_unreg\possible_en_domain" + str(fileid) + ".txt", "w")
        file.write(domain + '\n')
        index += 1
=======
        #print(domain, w)
        pass
>>>>>>> 6b0c9cbead8bfceeee6a391b2c30ee94a51ee7a4:tellmewhich.py

print("=" * 30)
