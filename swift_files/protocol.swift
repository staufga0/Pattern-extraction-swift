
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}
protocol ItemStoring {
    associatedtype DataType

    var items: [DataType] { get set}
    mutating func add(item: DataType)
}
