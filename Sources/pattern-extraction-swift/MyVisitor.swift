import AST
import Parser
import Source




class MyVisitor : ASTVisitor {

  // Dictionary containing the count of all patterns we're searching for.
  // Use the function MyVisitor.incr() to increment one of its values.
  var counts = [String: Int]()

  // Takes as an argument a string representing the key in the dictionary of the
  // pattern that was just found. This function will increment its value by one.
  // Use this function to avoid having to deal with incrementing a nil value for
  // a key.
  func incr(_ key: String) {
    counts[key] = (counts[key] ?? 0) + 1
  }


  //------------------------------------------------------------------------
  // closure ( or lambda in kotlin)
  //------------------------------------------------------------------------
  func visit(_ stmt: ClosureExpression) throws -> Bool {
    incr("clos")
    return true
  }


  func visit(_ stmt: FunctionDeclaration) throws -> Bool {
    //----------------------------------------------------------------------
    // inline test
    //----------------------------------------------------------------------
    for a in stmt.attributes {
      if a.name.textDescription == "inline" {
        if a.argumentClause!.textDescription == "(never)" {
          incr("inlineNever")
        } else if a.argumentClause!.textDescription == "(__always)" {
          incr("inlineAlways")
        }
        // print(a.name.textDescription, "    ", a.argumentClause as Any)
      }
    }

    //----------------------------------------------------------------------
    // default value for argument
    //----------------------------------------------------------------------
    for p in stmt.signature.parameterList {

      if p.defaultArgumentClause != nil {
        incr("defaultArg")
      }
    }

    return true

  }

  // Type inference :
  func visit(_ stmt: ConstantDeclaration) throws -> Bool {
      if let P_ident = stmt.initializerList[0].pattern as? IdentifierPattern {
        if P_ident.typeAnnotation == nil{
          incr("infered_types")
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
          incr("infered_types")
        }
        // print(P_ident.typeAnnotation as Any)
      }
      // obj is a string array. Do something with stringArray

    case let .willSetDidSetBlock(_, typeAnnotation, _, _):
      if typeAnnotation == nil{
        incr("infered_types")
      }
      // print(typeAnnotation as Any)

    default:
      // print("Got default case")
      break
    }
    // print("===============")
    // print("")

    incr("variable_declaration")
    return true
  }
}
