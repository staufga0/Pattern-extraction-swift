import AST
import Parser
import Source

print("main has been run")
var infered_types = 0
var nb = 0
var nb2 = 0

do {
  let sourceFile = try SourceReader.read(at: "swift_files/type_inferance.swift")
  let parser = Parser(source: sourceFile)
  // let topLevelDecl = try parser.parse()


  class MyVisitor : ASTVisitor {
    func visit(_ stmt: ConstantDeclaration) throws -> Bool {
        if let P_ident = stmt.initializerList[0].pattern as? IdentifierPattern {
          if P_ident.typeAnnotation == nil{
            infered_types += 1
          }
          print(P_ident.typeAnnotation as Any)
        }
        return true
    }
    func visit(_ stmt: VariableDeclaration) throws -> Bool {
      // print("")
      // print("==================")
      // print("Found var")
      //
      // print(stmt.textDescription)
      // print(stmt.attributes)
      // print(stmt.modifiers)
      // print(stmt.body)


      switch stmt.body {
      case .initializerList(let inits):
        // print(stmt.textDescription)
        // print(type(of :inits[0].pattern))
        if let P_ident = inits[0].pattern as? IdentifierPattern {
          if P_ident.typeAnnotation == nil{
            infered_types += 1
          }
          print(P_ident.typeAnnotation as Any)
        }
        // obj is a string array. Do something with stringArray



      default:
        print("Got default case")
      }
      // print("===============")
      // print("")

      nb2 += 1
      return true
    }
  }
  let myVisitor = MyVisitor()
  let topLevelDecl = try parser.parse()
  try _ =  myVisitor.traverse(topLevelDecl)

  print("number of type inference found: ", infered_types)

  // for stmt in topLevelDecl.statements {
  //   // consume statement
  //   print("=============\n", stmt, "\n=============\n")
  //   print(type(of: stmt))
  // }
} catch {
  // handle errors
  print("error: \(error).")
}
