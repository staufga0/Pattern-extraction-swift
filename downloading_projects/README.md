# Downloading tool

This python program is a tool that will download every version of every commit of each swift files from the principal branch (usually `master`) of a github repository.

#### How to download projects?
Refere to the README at the root of this project.

#### Why so many ...url_list.txt
`active_url_list.txt` is the one the program reads to download projects from. `test_url_list.txt` contains a few urls that have different kind of repositiories that help me quickly test the program sometimes. Finally, `full_url_list.txt` currently contains 150 repositories url that have a high star count on github and that contain swift files.

#### What platform is supported?
Only Linux is supported. The reason why is that the program calls the following shell commands `git`, `find` and `rm`.

#### How does the program work?
The program opens the file called `active_url_list.txt` which contains the github link of every reposiory to download in the form of : `https://github.com/<username>/<repo>`.

The program clones one of the repositories, finds all the `.swift` files in it, lists all the commits of each file, checkouts each commit of each file individualy and makes a copy of it in a directory called `files`.

Once it is finished, the cloned repository is deleted and the program continues with the next repository on the list.

#### Some more details

Inside of the directory `files/` the copies are arranged in the following way:
```
files/
  <username1>/
    <repo1>/
      <file1>/
        <sha1>/
          file1.swift
        <sha2>/
          file1.swift
        <sha3>/
          file1.swift
        ...

      <file2>/
      ...

    <repo2>/
    ...

  <username2>/
  ...
```

Inside of each `repo` folder is located a `infos.json` file. This file contains an array of all files in the repo where each file has:
* `path` : the path of the file in the original project.
* `name` : the exact name of the file.
* `numberedname` : the name of the file prefixed with a number, each file has a diffrent number to avoid conflicts in case there are two files with the same name in two different folders in the original project.
* `commits` : a dictionary where the key of each element is the sha digest of a commit and the associated value is a dictionary containing two keys: `time` containing the epoch date of the commit and `msg` containing the commit message.  
