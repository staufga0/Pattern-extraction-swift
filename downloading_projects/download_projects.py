from pathlib import Path
import json
import subprocess
import shutil
from log import log

error_log = log('error_log.txt')
done_log = log('done_log.txt')


# Returns all .swift files from a folder given as input arugment
def get_files_from_repo(repo):
    command = 'find . -type f -name "*.swift"'
    output = subprocess.check_output(command, shell=True, cwd=("./" + repo)).decode("utf-8")
    return [e for e in output.split('\n') if e]

def filename_from_path(path):
    return Path(path).name

# Returns sha, timestamps and title of all commits of a file
def get_commits_from_file(path, repo):
    # command = 'git --no-pager log --follow --pretty=format:"%C(auto)%H;%ct;%s" -- ' + path
    command = 'git --no-pager log --pretty=format:"%C(auto)%H;%ct;%s" -- ' + path
    output = subprocess.check_output(command, shell=True, cwd=("./" + repo)).decode("utf-8")

    # res = []
    # lookup = {}
    commits = {}
    for el in output.split('\n'):
        parts = el.split(';')
        # res.append({"sha": parts[0], "time": parts[1], "msg": ''.join(parts[2:])})
        # lookup[parts[0]] = parts[1]
        commits[parts[0]] = {"time": parts[1], "msg": ''.join(parts[2:])}

    # return (res, lookup)
    return commits

def add_repo_to_path(path, repo):
    return "./" + repo + path[1:]

def download_file(path, sha, dest, repo):
    # Checkout the specific commit for this file
    command = 'git checkout ' + sha + ' "' + path + '"'
    try:
        subprocess.check_output(command, shell=True, cwd=("./" + repo))
    except subprocess.CalledProcessError:
        error_log.log("git checkout failed to execute for file " + path + " and commit " + sha + " for the repo: " + repo + " and therefore wasn't copied")
        return

    # Copy the file and save it where it should
    Path(dest).mkdir(parents=True, exist_ok=True)
    shutil.copy(add_repo_to_path(path, repo), dest)

# Prints stdout in the terminal in real time
def run_command(command):
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    while True:
        output = process.stdout.readline()
        if len(output) == 0 and process.poll() is not None:
            break
        if output:
            print(output.strip())
    rc = process.poll()
    return rc

def extract(username, repo, only_do_json=False):
    cwd = "./files/" + username + "/" + repo
    infos_path =  cwd + "/infos.json"

    json_data = []

    files = get_files_from_repo(repo)
    total = len(files)

    if(total == 0):
        print("No files found for this repo: " + username + "/" + repo)
        error_log.log("0 files found for " + username + "/" + repo)
        return

    if(total == 1):
        print("There is only 1 file found for repo: " + username + "/" + repo)
        error_log.log("Extraction aborted because 1 single file found for " + username + "/" + repo)
        return

    Path(cwd).mkdir(parents=True, exist_ok=True)


    for idx, file in enumerate(files):
        name = filename_from_path(file)
        numberedname = "{0:0=4d}".format(idx) + "_" + name

        print('\033[2K\033[1G', end="")
        print(str(idx+1) + "/" + str(total) + " for: " + name, end="", flush=True)

        # Get commits, checkout on each of them, copy files
        # (commits, lookup) = get_commits_from_file(file, repo)
        commits = get_commits_from_file(file, repo)

        if(not only_do_json):
            for sha in commits:
            # for commit in commits:
                # sha = commit['sha']
                dest = cwd + "/" + numberedname + "/" + sha

                download_file(file, sha, dest, repo)

        json_data.append({'path': file, 'name': name, "numberedname": numberedname, 'commits': commits})#, 'lookup': lookup})
    print()


    with open(infos_path, 'w+') as outfile:
        json.dump(json_data, outfile, indent=2)

    done_log.log("Repo " + username + "/" + repo + " finished downloading")

def clone(link):
    command = "git clone -q --progress " + link
    run_command(command)

def delete_clone(repo):
    subprocess.check_output('rm -rf ' + repo, shell=True)


# Principal function used to run this code
def download_repo(link):
    infos = link.split('//github.com/')[1].strip().split("/")
    repo = infos[1]
    username = infos[0]
    print(" * Current project: " + username + "/" + repo)


    print("\n- Cloning repo")
    clone(link) # (1)

    print("\n- Getting commits")
    extract(username, repo) # (2)

    delete_clone(repo) # (3)
    print("Finished!\n")


    print()


# Entrypoint of this code
with open('active_url_list.txt', "r") as f:
    urls = f.readlines()

for url in urls:
    download_repo(url)
