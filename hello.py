#!/usr/bin/env python3
import json

datas = []

with open("hello.csv", "r", encoding="utf-8") as f:
    lines = f.readlines()
    lines = [line.strip() for line in lines]
    keys = lines[0].split(',') 
    
    for i in lines[1::]:
        values = i.strip().split(",")
        datas.append(dict(zip(keys, values)))

json_str = json.dumps(datas, ensure_ascii=False, indent=4)
print(json_str)

with open("hello.json", "w", encoding="utf-8") as f:
    f.write(json_str)
