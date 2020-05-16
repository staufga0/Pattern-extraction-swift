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

for name, rep in data.items():
    print('')
    print('')
    print(name)
    for repo, com in rep.items():
        c = 0

        vd_time = []
        vd_nb = []

        for commit, count in com.items():
            vd_time.append(int(commit))
            if "constant declaration" in count :
                vd_nb.append(count["constant declaration"])
            else :
                vd_nb.append(0)
            if c == 0 :
                for pattern, number in count.items():
                    print(pattern)
                c = 1
        plt.figure()
        plt.plot(vd_time, vd_nb,'o')
        plt.title(repo)
        plt.ylabel("number of constant declaration")
        plt.show()
        # print(repo)
