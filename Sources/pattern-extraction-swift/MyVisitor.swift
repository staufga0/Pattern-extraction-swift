import AST
import Parser
import Source




class MyVisitor : ASTVisitor {
  var infered_types = 0
  var inlineAlways = 0
  var inlineNever = 0
  var defaultArg = 0
  var clos = 0
  var nb = 0
  var nb2 = 0
    //------------------------------------------------------------------------
  // closure ( or lambda in kotlin)
  func visit(_ stmt: ClosureExpression) throws -> Bool {
    clos += 1
    return true
  }


  func visit(_ stmt: FunctionDeclaration) throws -> Bool {

    // -------------------------------------------------------------
    // inline test
    //-----------------------------------------------------------//
    for a in stmt.attributes {
      if a.name.textDescription == "inline" {
        if a.argumentClause!.textDescription == "(never)" {
          inlineNever += 1
        } else if a.argumentClause!.textDescription == "(__always)" {
          inlineAlways += 1
        }
        // print(a.name.textDescription, "    ", a.argumentClause as Any)
      }
    }
    //----------------------------------------------------------
    // default value for argument
    //----------------------------------------------------
    for p in stmt.signature.parameterList {

      if p.defaultArgumentClause != nil {
        defaultArg += 1
      }
    }

    return true

  }

  // Type inference :
  func visit(_ stmt: ConstantDeclaration) throws -> Bool {
      if let P_ident = stmt.initializerList[0].pattern as? IdentifierPattern {
        if P_ident.typeAnnotation == nil{
          infered_types += 1
        }
        // print(P_ident.typeAnnotation as Any)
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
        // print(P_ident.typeAnnotation as Any)
      }
      // obj is a string array. Do something with stringArray

    case let .willSetDidSetBlock(_, typeAnnotation, _, _):
      if typeAnnotation == nil{
        infered_types += 1
      }
      // print(typeAnnotation as Any)

    default:
      print("Got default case")
    }
    // print("===============")
    // print("")

    nb2 += 1
    return true
  }
}
