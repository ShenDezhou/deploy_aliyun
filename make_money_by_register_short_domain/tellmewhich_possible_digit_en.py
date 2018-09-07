# -*- coding: utf-8 -*-
from functools import reduce


def fn(x, y):
    return x * 36 + y


def char2num(s):
    return int(s, 36)


def str2num(str):
    return reduce(fn, map(char2num, str))


def num2str(num, size=4):
    repstr = ""
    devided = num
    while devided > 0 or len(repstr) < size:
        remain = devided % 36
        __str = str(remain) if remain < 10 else chr(remain - 10 + ord('a'))
        repstr = __str + repstr
        devided = devided // 36
    return repstr


print(str2num("aaab"))
print(num2str(1))
urldic = {}


def load_model():
    with open(r"C:\Users\Administrator\github\finance\make_money_by_register_short_domain\searchengine\domain_digit-en", "r") as file:
        print("opened")
        for line in file.readlines():
            key = line.replace(
                "https://www.", "").replace("http://www.", "").replace(".com/", "").strip()
            urldic[key] = 1


load_model()
print(num2str(36**4 - 1))
print(len(urldic))

index = 0

for n in range(36**4):
    domain = num2str(n)
    if domain not in urldic:
        #w = whois(domain + ".com")
        if index % 1000 == 0:
            if file:
                file.close()
            fileid = index // 1000
            file = open(
                r"C:\Users\Administrator\github\finance\make_money_by_register_short_domain\possible_unreg\possible_digit-en_domain" + str(fileid) + ".txt", "w")
        file.write(domain + '\n')
        index += 1

print("=" * 30)
