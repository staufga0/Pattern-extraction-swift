import Foundation

protocol Statisticable {
  func run(_ file: String, debug: Bool) -> Dictionary<String, Int>?
}

extension Statisticable {
  // path is the path of a directory in which files are listed in the form:
  // <username>/<repo>/<filename>/<commit_sha>/<file>.swift
  public func applyToAll(_ path: String, _ outpath: String, _ keyspath: String , debug: Bool = false) {
    let url = URL(string: path)!

    print("Applying to all files at location: " + path + "\n")

    let usernames = listDirs(url)
    var allOuputs = [String: [String: [String: [String: [String: Int]]]]]()
    var allKeys = Set<String>()

    for username in usernames {
      allOuputs[username.lastPathComponent] = [:];
      print(username.lastPathComponent)
      let repos = listDirs(username)

      for repo in repos {
        allOuputs[username.lastPathComponent]?[repo.lastPathComponent] = [:]
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
            if(output == nil) {
              // Also works
              // print("Error encountered in: " + username.lastPathComponent + "/" + repo.lastPathComponent + "/" + filename.lastPathComponent + "/" + sha.lastPathComponent + " returned nil\n", to: &logger)
              logger.write("Error encountered in: " + username.lastPathComponent + "/" + repo.lastPathComponent + "/" + filename.lastPathComponent + "/" + sha.lastPathComponent + " returned nil\n")
            }
            else {
              computeStatistics(output!, username, repo, filename, timestamp, &allOuputs, &allKeys)
            }
          }
        }
        // print(allOuputs)
        // var sortedKeys = Array(allOuputs[username.lastPathComponent]![repo.lastPathComponent]!.keys)
        // sortedKeys.sort(by: <)
        // print(sortedKeys)
        // print(allKeys)
      }
    }

    // When finished write the values to json file
    // print("About to jsonify")
    let myJsonData = try? JSONSerialization.data(withJSONObject: allOuputs, options: [])
    // print("Obtained jsonDAta")
    // print("Json data:", myJsonData ?? "empty")
    let jsonString = String(data: myJsonData!, encoding: .utf8)! as String
    // print(jsonString)

    let outJsonPath = URL(fileURLWithPath: outpath)
    do {
      try jsonString.write(to: outJsonPath, atomically: true, encoding: String.Encoding.utf8)
    }
    catch {
      print("Could not write the data to the disk")
    }

    let myKeys = allKeys.joined(separator: "\n")
    let outKeys = URL(fileURLWithPath: keyspath)
    do {
      try myKeys.write(to: outKeys, atomically: true, encoding: String.Encoding.utf8)
    }
    catch {
      print("Could not write the list of keys to the disk")
    }
  }

  // Used for testing, only applies the run() function to one file
  public func applyToOne(_ path: String, debug: Bool = false) {
    let _ = run(path, debug: debug)
  }

  // Function which takes the patterns counting as argument and process it to
  // create the statistics to analyse the use of patterns in a bunch of projects.
  private func computeStatistics(_ output: Dictionary<String, Int>, _ username: URL, _ repo: URL, _ filename: URL, _ timestamp: String, _ allOuputs: inout [String :[String: [String: [String: [String: Int]]]]], _ allKeys: inout Set<String>) {
    let timestampNumber = timestamp
    // print(filename.lastPathComponent)
    // allOuputs[username.lastPathComponent]?[repo.lastPathComponent]?[timestampNumber]?[filename.lastPathComponent] = output
    // for (key, _) in output {
    //   allKeys.insert(key)
    // }

    // print(filename.lastPathComponent)
    // print(timestampNumber)
    if (allOuputs[username.lastPathComponent] == nil){
      allOuputs[username.lastPathComponent] = [repo.lastPathComponent : [timestampNumber :[filename.lastPathComponent : output]]]
    }else if (allOuputs[username.lastPathComponent]![repo.lastPathComponent] == nil){
      allOuputs[username.lastPathComponent]![repo.lastPathComponent] = [timestampNumber :[filename.lastPathComponent : output]]
    }else if (allOuputs[username.lastPathComponent]![repo.lastPathComponent]![timestamp] == nil){
      allOuputs[username.lastPathComponent]![repo.lastPathComponent]![timestampNumber] = [filename.lastPathComponent : output]
    }else{
      allOuputs[username.lastPathComponent]![repo.lastPathComponent]![timestampNumber]![filename.lastPathComponent] = output
    }

    // let keyExists = allOuputs[username.lastPathComponent]?[repo.lastPathComponent]?[timestampNumber]?[filename.las] != nil
    //
    // if(keyExists) {
    //    allOuputs[username.lastPathComponent]?[repo.lastPathComponent]?[timestampNumber]?[filename.lastPathComponent] = output
    //    // for (key, value) in output {
    //    //   let valueExists = allOuputs[username.lastPathComponent]?[repo.lastPathComponent]?[timestampNumber]![key] != nil
    // //     if(valueExists) {
    // //       allOuputs[username.lastPathComponent]?[repo.lastPathComponent]?[timestampNumber]![key]? += value
    // //     }
    // //     else {
    // //       allOuputs[username.lastPathComponent]?[repo.lastPathComponent]?[timestampNumber]![key]? = value
    // //     }
    // //
    // //     allKeys.insert(key)
    // //   }
    // }
    // else {
    //   print("hello")
    //   allOuputs[username.lastPathComponent] = [repo.lastPathComponent : [timestampNumber :[filename.lastPathComponent : output]]]
    //   for (key, _) in output {
    //     allKeys.insert(key)
    //   }
    // }

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
