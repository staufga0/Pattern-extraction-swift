
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}
protocol ItemStoring {
    associatedtype DataType

    var items: [DataType] { get set}
    mutating func add(item: DataType)
}

protocol FullyNamed {
    var fullName: String { get }
}





extension Int: Fullynamed {
    var fullname = "obviously integer"
    // implementation of protocol requirements goes here
}


struct Circle : Fullynamed {
  var center : Point
  var radius : Int

  var fullName = "circle"
}


class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}


extension Array where Element : Fullynamed {

    func filterWithname(name : String) -> [Element] {
        return self.filter { (item) -> Bool in
            return item.fullname == name
        }
    }
}
