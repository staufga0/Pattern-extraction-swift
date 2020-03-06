import AST
import Parser
import Source

print("main has been run")

var nb = 0
var nb2 = 0

do {
  let sourceFile = try SourceReader.read(at: "swift_files/type_inferance.swift")
  let parser = Parser(source: sourceFile)
  // let topLevelDecl = try parser.parse()


  class MyVisitor : ASTVisitor {
    func visit(_ stmt: ConstantDeclaration) throws -> Bool {
      // visit this if statement
      print("Found const")

      nb += 1
      return true
    }

    func visit(_ stmt: VariableDeclaration) throws -> Bool {
      print("Found var")

      switch stmt.Body {
      case .initializerList(let a):
        print(stmt.textDescription)
      default:
        print("Got default case")
      }

      nb2 += 1
      return true
    }
  }
  let myVisitor = MyVisitor()
  let topLevelDecl = try parser.parse()
  try myVisitor.traverse(topLevelDecl)

  print(nb)

  // for stmt in topLevelDecl.statements {
  //   // consume statement
  //   print("=============\n", stmt, "\n=============\n")
  //   print(type(of: stmt))
  // }
} catch {
  // handle errors
  print("error: \(error).")
}
