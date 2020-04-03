import AST
import Parser
import Source

print("main has been run")

do {
  // let sourceFile = try SourceReader.read(at: "swift_files/type_inferance.swift")
  // let sourceFile = try SourceReader.read(at: "swift_files/inline_func.swift")
  let sourceFile = try SourceReader.read(at: "swift_files/closure.swift")

  let parser = Parser(source: sourceFile)
  // let topLevelDecl = try parser.parse()

  let myVisitor = MyVisitor()
  let topLevelDecl = try parser.parse()
  try _ =  myVisitor.traverse(topLevelDecl)

  print("number of type inference found: ", myVisitor.infered_types)
  print("number of inline never found: ", myVisitor.inlineNever)
  print("number of inline Always found: ", myVisitor.inlineAlways)
  print("number of default value for arguement found: ", myVisitor.defaultArg)
  print("number of closure found: ", myVisitor.clos)

  // for stmt in topLevelDecl.statements {
  //   // consume statement
  //   print("=============\n", stmt, "\n=============\n")
  //   print(type(of: stmt))
  // }
} catch {
  // handle errors
  print("error: \(error).")
}
