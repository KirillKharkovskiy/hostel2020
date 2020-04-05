import Foundation
import Firebase
class Servicess:NSObject,Codable{
    var title : String?
    var price : String?
    var userId : String?
    var order : Bool?
    var status : Bool?
    var image : String?
    var dataTimeOrder : String?
    var dateComplitionServ: String?
    var dateApprovedOrders : String?
    var descriptionServ: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case price
        case userId
        case order
        case status
        case image
        case dataTimeOrder
        case dateComplitionServ
        case dateApprovedOrders
        case descriptionServ
    }
    init(title: String, price: String, userId: String, order: Bool, status: Bool, image: String, dataTimeOrder: String, dateComplitionServ: String, dateApprovedOrders: String, descriptionServ: String) {
        self.title = title
        self.price = price
        self.userId = userId
        self.order = order
        self.status = status
        self.image = image
        self.dataTimeOrder = dataTimeOrder
        self.dateComplitionServ = dateComplitionServ
        self.dateApprovedOrders = dateApprovedOrders
        self.descriptionServ = descriptionServ
    }
    init(dictionary: [AnyHashable: Any]) {
        self.title = dictionary["title"] as? String
        self.price = dictionary["price"] as? String
        self.userId = dictionary["userId"] as? String
        self.order = (dictionary["order"] as? Bool)
        self.status = (dictionary["status"] as? Bool)
        self.image = dictionary["image"] as? String
        self.dataTimeOrder = dictionary["dataTimeOrder"] as? String
        self.dateComplitionServ = dictionary["dateComplitionServ"] as? String
        self.dateApprovedOrders = dictionary["dateApprovedOrders"] as? String
        self.descriptionServ = dictionary["descriptionServ"] as? String
    }
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.title = snapshotValue["title"] as? String
        self.price = snapshotValue["price"] as? String
        self.userId = snapshotValue["userId"] as? String
        self.order = (snapshotValue["order"] as? Bool)
        self.status = (snapshotValue["status"] as? Bool)
        self.image = snapshotValue["image"] as? String
        self.dataTimeOrder = snapshotValue["dataTimeOrder"] as? String
        self.dateComplitionServ = snapshotValue["dateComplitionServ"] as? String
        self.dateApprovedOrders = snapshotValue["dateApprovedOrders"] as? String
        self.descriptionServ = snapshotValue["descriptionServ"] as? String
    }
    override init() {
        self.title = nil
        self.userId = nil
        self.price = nil
        self.status = false
        self.order = false
        self.image = nil
        self.dataTimeOrder = nil
        self.dateComplitionServ = nil
        self.dateApprovedOrders = nil
        self.descriptionServ = nil
    }
    func convertToDictionary() -> Any {
        return ["title": title!,
                "price": price!,
                "userId": userId!,
                "order": order!,
                "status": status!,
                "image": image!,
                "dataTimeOrder": dataTimeOrder!,
                "dateComplitionServ": dateComplitionServ!,
                "dateApprovedOrders": dateApprovedOrders!,
                "descriptionServ": descriptionServ!]
    }
}
