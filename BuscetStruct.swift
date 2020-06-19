import Foundation
import Firebase

class Category: Codable {
    var Rooms:[String: Rooms]
    var Services:[String: Servicess]
    var Profile:[String: userAndAdmin]
}
