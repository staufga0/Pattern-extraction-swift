import matplotlib.pyplot as plt
import json
import os,glob
data = {}

folder_path = os.getcwd()+'/datas'
print(folder_path)
try:
    for filename in os.listdir(folder_path):
        print(filename)
        with open(os.path.join(folder_path, filename), 'r') as f:
            d = json.load(f)
            print(f)
        data.update(d)

except IOError as e:
          print('Operation failed: %s' % e.strerror)


print(data)
