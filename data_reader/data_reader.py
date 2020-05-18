import matplotlib.pyplot as plt
import json
import os
import numpy as np

data = {}

folder_path = os.getcwd()+'/datas'
try:
    with open("processed_data.json", 'r') as f:
        data = json.load(f)
# data : {name: {repo : {timestamp:{feature:int}}}}
except IOError as e:
          print('Operation failed: %s' % e.strerror)

nbProjet = 0
stats = {}
feature ={}
time={}
p_time ={}
for name, rep in data.items():
    print('')
    print('')
    print(name)
    for repo, com in rep.items():
        nbProjet += 1

        ts = sorted(com)[0]
        te = sorted(com, reverse=True)[0]
        seen = []
        for commit, count in sorted(com.items()) :
            for key in count :
                if not key in seen :
                    seen.append(key)
                    if key in time :
                        time[key].append((int(commit)-int(ts))/3600/24)
                        p_time[key].append((int(commit)-int(ts))/(int(te)-int(ts)))
                    else :
                        time[key] = [(int(commit)-int(ts))/3600/24]
                        p_time[key] =[(int(commit)-int(ts))/(int(te)-int(ts))]

        commit, count = sorted(com.items(), reverse=True)[0]
        for key in count:
            if key in stats:
                stats[key].append(count[key])
                feature[key] += 1
            else :
                stats[key] = [count[key]]
                feature[key] = 1

#
# for x,y in sorted([(np.mean(stats[k]),k) for k in stats]) :
#     print(y, ': ', x)
#

print("")
print("")

for x,y in sorted([(feature[k]/nbProjet,k) for k in feature]) :
    print(y, ': {0:2f}%'.format(x*100))


print("")
print("")

for x,y in sorted([(np.mean(time[k]),k) for k in time]) :
    print(y, ': {0:2f} : {1:2f}'.format(x, np.std(time[y])))
#



print("")
print("")

for x,y in sorted([(np.mean(p_time[k]),k) for k in p_time]) :
    print(y, ': {0:2f}% : {1:2f}'.format(x*100, np.std(p_time[y])*100))

# for key in stats :
#     print(key, ' mean: ', np.mean(stats[key]))
    # print(key, ' std: ', np.std(stats[key]))

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
