import Foundation

protocol Statisticable {
  func run(_ file: String, printResults: Bool) -> Dictionary<String, Int>?
}

extension Statisticable {
  // path is the path of a directory in which files are listed in the form:
  // <username>/<repo>/<filename>/<commit_sha>/<file>.swift
  public func applyToAll(_ path: String) {
    let url = URL(string: path)!

    print("Applying to all files at location: " + path + "\n")

    let usernames = listDirs(url)

    for username in usernames {
      print(username.lastPathComponent)
      let repos = listDirs(username)

      for repo in repos {
        print(" -", repo.lastPathComponent)

        let (filenames, json) = listDirsAndFiles(repo)
        let jsonFile = json[0]
        // print("    -", jsonFile.lastPathComponent)

        for filename in filenames {
          print("    -", filename.lastPathComponent)

          let shas = listDirs(filename)

          for sha in shas {
            let (_, fileList) = listDirsAndFiles(sha)
            let file = fileList[0]

            // let first4 = String(sha.lastPathComponent.prefix(4))
            // print("      -", first4 + "... " + file.lastPathComponent)

            // TODO: Extract timestamp from sha value and jsonFile
            let timestamp = 0

            let output = run(file.path, printResults: false)
            computeStatistics(output, username, repo, filename, timestamp)
          }
        }
      }
    }
  }

  // Used for testing, only applies the run() function to one file
  public func applyToOne(_ path: String, printResults: Bool = true) {
    let _ = run(path, printResults: printResults)
  }

  // Function which takes the patterns counting as argument and process it to
  // create the statistics to analyse the use of patterns in a bunch of projects.
  private func computeStatistics(_ output: Dictionary<String, Int>?, _ username: URL, _ repo: URL, _ filename: URL, _ timestamp: Int) {
    // TODO: Record the evolution of counting of patterns per project, according
    // to time.
    if (output != nil) {
      // At least one of the paterns we're looking for has been found
    }
    else {
      // None of the patterns we're looking for have been found
    }
  }

  // Returns a list of directories in a directory specified by an URL
  private func listDirs(_ url: URL) -> [URL] {
    var dirs = [URL]()
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    do {
      let files = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)

      // Find directories in the list of all the files
      for file in files {
        let isDir = (try file.resourceValues(forKeys: [.isDirectoryKey])).isDirectory
        if(isDir!) {
          dirs.append(file)
        }
      }
    } catch {
        print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
    }
    return dirs
  }

  // Returns a list of directories and a list of files in a directory specified
  // by an URL
  private func listDirsAndFiles(_ url: URL) -> ([URL], [URL]) {
    var dirs = [URL]()
    var nonDirs = [URL]()
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    do {
      let files = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)

      // Find directories in the list of all the files
      for file in files {
        let isDir = (try file.resourceValues(forKeys: [.isDirectoryKey])).isDirectory
        if(isDir!) {
          dirs.append(file)
        }
        else {
          nonDirs.append(file)
        }
      }
    } catch {
        print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
    }
    return (dirs, nonDirs)
  }
}
