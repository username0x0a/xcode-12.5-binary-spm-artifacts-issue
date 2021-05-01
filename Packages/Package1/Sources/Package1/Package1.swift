
public protocol Carrier {
    typealias ID = String

    var id: ID { get }
    var name: String { get }
    var isLowcost: Bool { get }
}

public protocol CarrierProviding: AnyObject {

    var allCarrierIDs: Set<Carrier.ID> { get }

    func carrier(withID id: Carrier.ID) -> Carrier
}
