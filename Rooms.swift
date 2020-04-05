import Foundation
import Firebase

class Rooms:NSObject, Codable {
    var title: String?
    var userId: String?
    var price: String?
    var status: Bool?
    var order: Bool?
    var image: String?
    var dataTimeOrder: String?
    var dateArrival: String?
    var dateDeparture: String?
    var dateApprovedOrders: String?
    var descriptionRoom: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case userId
        case price
        case status
        case order
        case image
        case dataTimeOrder
        case dateArrival
        case dateDeparture
        case dateApprovedOrders
        case descriptionRoom
    }
    init(title: String,userId: String,price: String, status: Bool, order: Bool, image: String, dataTimeOrder: String, dateArrival: String, dateDeparture: String, dateApprovedOrders: String, descriptionRoom: String) {
        self.title = title
        self.userId = userId
        self.price = price
        self.status = status
        self.order = order
        self.image = image
        self.dataTimeOrder = dataTimeOrder
        self.dateArrival = dateArrival
        self.dateDeparture = dateDeparture
        self.dateApprovedOrders = dateApprovedOrders
        self.descriptionRoom = descriptionRoom
    }
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.title = snapshotValue["title"] as? String
        self.userId = snapshotValue["userId"] as? String
        self.price = snapshotValue["price"] as? String
        self.status = (snapshotValue["status"] as? Bool)
        self.order = (snapshotValue["order"] as? Bool)
        self.image = snapshotValue["image"] as? String
        self.dataTimeOrder = snapshotValue["dataTimeOrder"] as? String
        self.dateArrival = snapshotValue["dateArrival"] as? String
        self.dateDeparture = snapshotValue["dateDeparture"] as? String
        self.dateApprovedOrders = snapshotValue["dateApprovedOrders"] as? String
        self.descriptionRoom = snapshotValue["descriptionRoom"] as? String
    }
    override init() {
        self.title = nil
        self.userId = nil
        self.price = nil
        self.status = false
        self.order = false
        self.image = nil
        self.dataTimeOrder = nil
        self.dateArrival = nil
        self.dateDeparture = nil
        self.dateApprovedOrders = nil
        self.descriptionRoom = nil
    }
    func convertToDictionary() -> Any {
        return ["title": title!,
                "userId": userId!,
                "price": price!,
                "status": status!,
                "order": order!,
                "image": image!,
                "dataTimeOrder": dataTimeOrder!,
                "dateArrival": dateArrival!,
                "dateDeparture": dateDeparture!,
                "dateApprovedOrders": dateApprovedOrders!,
                "descriptionRoom": descriptionRoom!]
    }
}
