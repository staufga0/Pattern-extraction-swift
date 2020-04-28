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
    incr("closure")
    return true
  }

  //------------------------------------------------------------------------
  // protocol
  //------------------------------------------------------------------------
  func visit(_ stmt: ProtocolDeclaration) throws -> Bool {
    incr("protocol")
    // print("")
    // print("")
    // print(stmt.textDescription)
    for member in stmt.members{
      switch member {
      case .associatedType(_):
        incr("protocol with associated datatype")

      default:
        // print("Got default case")
        break
      }
    }
    // print(stmt.textDescription)
    // print(stmt.attributes.isEmpty ? "" : "\(stmt.attributes.textDescription) ")
    // print(stmt.typeInheritanceClause?.textDescription ?? "")
    //
    // if stmt.memeber
    // print("")
    // let membersText = stmt.members.map({ $0.textDescription }).joined(separator: "\n")
    // let memberText = stmt.members.isEmpty ? "" : "\n\(membersText)\n"
    // print("{\(memberText)}")
    return true
  }


  //------------------------------------------------------------------------
  // Class declaration
  //------------------------------------------------------------------------
  func visit(_ stmt: ClassDeclaration) throws -> Bool {
    incr("class declaration")
    return true
  }

  //------------------------------------------------------------------------
  // Struct declaration
  //------------------------------------------------------------------------
  func visit(_ stmt: StructDeclaration) throws -> Bool {
    incr("struct declaration")
    return true
  }

  //------------------------------------------------------------------------
  // Extension
  //------------------------------------------------------------------------
  func visit(_ stmt: ExtensionDeclaration) throws -> Bool {
    incr("extension")
    // print("")
    // print("")
    // print(stmt.textDescription)
    // print(stmt.attributes)
    if(stmt.typeInheritanceClause != nil){
      incr("extension with protocol")
    }
    else if(stmt.genericWhereClause != nil){
      incr("extension with where clause")
    }
    else {
      incr("protocol extension ?(might be smthg else)")
    }

    return true
  }


  func visit(_ stmt: FunctionDeclaration) throws -> Bool {
    //----------------------------------------------------------------------
    // inline test
    //----------------------------------------------------------------------
    if stmt.signature.result?.type is OptionalType {
      incr("optional return value")
    }
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

  // Type inference and optionalss:
  func visit(_ stmt: ConstantDeclaration) throws -> Bool {
      if let P_ident = stmt.initializerList[0].pattern as? IdentifierPattern {
        if P_ident.typeAnnotation?.type is OptionalType {
          incr("optional")
        }
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
    // print(stmt.modifiers)    // print(stmt.modifiers)



    switch stmt.body {
    case .initializerList(let inits):
      // print(stmt.textDescription)
      // print(type(of :inits[0].pattern))

      // print(stmt.body)
      // print(inits.map({ $0.textDescription }).joined(separator: ", "))
      if let P_ident = inits[0].pattern as? IdentifierPattern {
        if P_ident.typeAnnotation?.type is OptionalType {
          incr("optional")
        }

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
