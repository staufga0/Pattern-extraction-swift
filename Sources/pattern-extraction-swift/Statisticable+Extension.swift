import Foundation

protocol Statisticable {
  func run(_ file: String, debug: Bool) -> Dictionary<String, Int>?
}

extension Statisticable {
  // path is the path of a directory in which files are listed in the form:
  // <username>/<repo>/<filename>/<commit_sha>/<file>.swift
  public func applyToAll(_ path: String, debug: Bool = false) {
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

        // Converting the infos.json file into a Dictionary
        let jsonInfos = readJsonInfos(jsonFile)!

        for filename in filenames {
          print("    -", filename.lastPathComponent)

          let shas = listDirs(filename)

          for sha in shas {
            let (_, fileList) = listDirsAndFiles(sha)
            let file = fileList[0]

            // let first4 = String(sha.lastPathComponent.prefix(4))
            // print("      -", first4 + "... " + file.lastPathComponent)

            let timestamp = getTime(filename.lastPathComponent, sha.lastPathComponent, jsonInfos)

            let output = run(file.path, debug: debug)
            computeStatistics(output, username, repo, filename, timestamp)
          }
        }
      }
    }
  }

  // Used for testing, only applies the run() function to one file
  public func applyToOne(_ path: String, debug: Bool = false) {
    let _ = run(path, debug: debug)
  }

  // Function which takes the patterns counting as argument and process it to
  // create the statistics to analyse the use of patterns in a bunch of projects.
  private func computeStatistics(_ output: Dictionary<String, Int>?, _ username: URL, _ repo: URL, _ filename: URL, _ timestamp: String) {
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

  private func readJsonInfos(_ jsonFile : URL) -> Dictionary<String, Dictionary<String, Any>>? {
    let jsonData: String

    // Opening the file
    do {
      jsonData = try String(contentsOf: jsonFile, encoding: .utf8)
    }
    catch {
      print("infos.json could not be opened")
      return nil
    }

    // Conversion
    let data = Data(jsonData.utf8)
    let json: Dictionary<String, Dictionary<String, Any>>
    do {
        // make sure this JSON is in the format we expect
        json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Dictionary<String, Any>>
        return json
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
        return nil
    }
  }

  // Extract timestamp for a given file and given sha from jsonInfos
  private func getTime(_ filename: String, _ sha: String, _ jsonInfos: Dictionary<String, Dictionary<String, Any>>) -> String {
    let commits_infos = jsonInfos[filename]!["commits"]! as! Dictionary<String, Dictionary<String, String>>
    let timestamp = commits_infos[sha]!["time"]!
    return timestamp
  }
}
