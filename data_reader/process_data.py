import matplotlib.pyplot as plt
import json
import os

data = {}

folder_path = os.getcwd()+'/datas'
try:
    for filename in os.listdir(folder_path):
        with open(os.path.join(folder_path, filename), 'r') as f:
            d = json.load(f)
        data.update(d)

except IOError as e:
          print('Operation failed: %s' % e.strerror)

# print(data)

commdata={}

for name, rep in data.items():
    commdata[name] = {}
    print('')
    print(name)
    for repo, com in rep.items():
        commdata[name][repo] = {}
        current_state = {}
        for commit, fil in sorted(com.items()):
            commdata[name][repo][commit] = {}
            for file, count in fil.items() :
                current_state[file] = count
            # print(current_state)
            for f,c in current_state.items():
                for key in c:
                    if key in commdata[name][repo][commit] :
                        commdata[name][repo][commit][key] += c[key]
                    else :
                        commdata[name][repo][commit][key] = c[key]
            # print("")
            # print(commdata[name][repo][commit])



with open('processed_data.json', 'w') as f :
    json.dump(commdata, f)
