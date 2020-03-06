import AST
import Parser
import Source

print("main has been run")

let sourceFile = try SourceReader.read(at: "swift_files/Exercice1.swift")
let parser = Parser(source: sourceFile)
let topLevelDecl = try parser.parse()

for stmt in topLevelDecl.statements {
  // consume statement
  print(stmt)
}

// do {
//   let sourceFile = try SourceReader.read(at: "../../swift_files/Exercice1.swift")
//   let parser = Parser(source: sourceFile)
//   let topLevelDecl = try parser.parse()
//
//   print("topLevelDecl")
//   print(topLevelDecl)
//
//   for stmt in topLevelDecl.statements {
//     // consume statement
//     print(stmt)
//   }
// } catch {
//   // handle errors
// }
