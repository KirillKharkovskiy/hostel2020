import Foundation
import Firebase
class userAndAdmin:NSObject, Codable {
    var email: String?
    var fullName: String?
    var isAdmin: String?
    var password: String?
    var userId: String?
    var phoneNumber: String?
    var dataTimeOrder: String?
    var dateApprovedOrders: String?

    enum CodingKeys: String, CodingKey {
        case email
        case fullName
        case isAdmin
        case password
        case userId
        case phoneNumber
        case dataTimeOrder
        case dateApprovedOrders
        
    }
    init(email: String, fullName: String, isAdmin: String, password:String , userId: String, phoneNumber:String, dataTimeOrder:String, dateApprovedOrders: String) {
        self.email = email
        self.fullName = fullName
        self.isAdmin = isAdmin
        self.password = password
        self.userId = userId
        self.phoneNumber = phoneNumber
        self.dataTimeOrder = dataTimeOrder
        self.dateApprovedOrders = dateApprovedOrders
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as?[String: AnyObject]
        self.email = (snapshotValue?["email"] as? String)
        self.fullName = snapshotValue?["fullName"] as? String
        self.isAdmin = (snapshotValue?["isAdmin"] as? String)
        self.password = snapshotValue?["password"] as? String
        self.userId = snapshotValue?["userId"] as? String
        self.phoneNumber = snapshotValue?["phoneNumber"] as? String
        self.dataTimeOrder = snapshotValue?["dataTimeOrder"] as? String
        self.dateApprovedOrders = snapshotValue?["dateApprovedOrders"] as? String
    }
    override init() {
        self.email = nil
        self.fullName = nil
        self.isAdmin = nil
        self.password = nil
        self.userId = nil
        self.phoneNumber = nil
        self.dataTimeOrder = nil
        self.dateApprovedOrders = nil
    }
    func convertToDictionary() -> Any {
        return [
            "email": email!,
            "fullName": fullName!,
            "isAdmin": isAdmin!,
            "password": password!,
            "userId": userId!,
            "phoneNumber": phoneNumber!,
            "dataTimeOrder": dataTimeOrder!,
            "dateApprovedOrders": dateApprovedOrders!]
    }
}
