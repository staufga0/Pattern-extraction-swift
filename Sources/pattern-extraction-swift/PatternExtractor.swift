import AST
import Parser
import Source

class PatternExtractor : Statisticable {
  func run(_ file: String, printResults: Bool) -> Dictionary<String, Int>? {

    do {
      let sourceFile = try SourceReader.read(at: file)
      let parser = Parser(source: sourceFile)

      let myVisitor = MyVisitor()
      let topLevelDecl = try parser.parse()
      try _ =  myVisitor.traverse(topLevelDecl)

      // Print found results. (Only encountered patterns will be added to the
      // dictionary and therefore printed here.
      if(printResults) {
        for (key, val) in myVisitor.counts {
          print("'" + key + "' found :", val)
        }
      }

      return myVisitor.counts
    }
    catch {
      // handle errors
      print("error: \(error).")
      return nil
    }

  }
}


// Code as it previously was in main.swfit:

// print("main has been run")
//
// do {
//   // let sourceFile = try SourceReader.read(at: "swift_files/type_inferance.swift")
//   // let sourceFile = try SourceReader.read(at: "swift_files/inline_func.swift")
//   let sourceFile = try SourceReader.read(at: "swift_files/closure.swift")
//
//   let parser = Parser(source: sourceFile)
//   // let topLevelDecl = try parser.parse()
//
//   let myVisitor = MyVisitor()
//   let topLevelDecl = try parser.parse()
//   try _ =  myVisitor.traverse(topLevelDecl)
//
//
//   // Print found results. (Only encountered patterns will be added to the
//   // dictionary and therefore printed here.
//   for (key, val) in myVisitor.counts {
//     print("'" + key + "' found :", val)
//   }
//
//
//   // for stmt in topLevelDecl.statements {
//   //   // consume statement
//   //   print("=============\n", stmt, "\n=============\n")
//   //   print(type(of: stmt))
//   // }
// } catch {
//   // handle errors
//   print("error: \(error).")
// }
