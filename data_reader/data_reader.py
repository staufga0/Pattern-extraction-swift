import matplotlib.pyplot as plt
import json
import os
import numpy as np

data = {}

folder_path = os.getcwd()+'/datas'
try:
    with open("processed_data.json", 'r') as f:
        data = json.load(f)

except IOError as e:
          print('Operation failed: %s' % e.strerror)

nbProjet = 0
stats = {}
for name, rep in data.items():
    print('')
    print('')
    print(name)
    for repo, com in rep.items():
        nbProjet += 1
        commit, count = sorted(com.items(), reverse=True)[0]
        for key in count:
            if key in stats:
                stats[key].append(count[key])
            else :
                stats[key] = [count[key]]

for key in stats :
    print(key, ' mean: ', np.mean(stats[key]))
    print(key, ' std: ', np.std(stats[key]))

print("nb projet: ", nbProjet)
# for name, rep in data.items():
#     print('')
#     print('')
#     print(name)
#     for repo, com in rep.items():
#         c = 0
#
#         vd_time = []
#         vd_nb = []
#
#         for commit, count in com.items():
#             vd_time.append(int(commit))
#             if "class declaration" in count :
#                 vd_nb.append(count["class declaration"])
#             else :
#                 vd_nb.append(0)
#             if c == 0 :
#                 for pattern, number in count.items():
#                     print(pattern)
#                 c = 1
#         plt.figure()
#         plt.plot(vd_time, vd_nb,'o')
#         plt.title(repo)
#         plt.ylabel("number of class declaration")
#         plt.show()
#         # print(repo)
