import UIKit
import Firebase
extension UIViewController {
    
    func showAlert(title: String,
                   message: String,
                   isCancelButton: Bool? = nil,
                   isOkDestructive: Bool? = nil,
                   okButtonName: String? = nil,
                   completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        var OkBtnName = "Ок"
        if okButtonName != nil {
            OkBtnName = okButtonName!
        }
        
        var styleOkButton: UIAlertAction.Style = .default
        
        if isOkDestructive != nil && isOkDestructive == true {
            styleOkButton = UIAlertAction.Style.destructive
        }
        
        var okButton = UIAlertAction()
        
        if completion != nil {
            
            okButton = UIAlertAction(title: OkBtnName, style: styleOkButton) { (_) in
                completion!()
            }
            
            alert.addAction(okButton)
            
            if isCancelButton != nil && isCancelButton == true {
                let cancelAction = UIAlertAction(title: "Отмена", style: .default)
                alert.addAction(cancelAction)
            }
        } else {
            okButton = UIAlertAction(title: "Ок", style: .default)
            alert.addAction(okButton)
        }
        
        present(alert, animated: true)
    }
}

extension UIViewController{
    func datatime()->String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: now)
        return dateString
    }
}

//extension UIViewController {
//    func observdataMain
//        (with ref: DatabaseReference, with rooms:  [Rooms], with services: inout [Servicess], with dictKey: inout [String], with profile: inout [userAndAdmin], with tbc: UITableView) {
//
//        ref.observe(.value, with: { (snapshot) in
//            
//            rooms.removeAll()
//            services.removeAll()
//            dictKey.removeAll()
//
//            let s = snapshot.value
//            if s == nil {
//                print("Error")
//            }else{
//                let b = s as? [String: AnyObject] // TODO: переделай на as? и на обычный try с отловом ошибок и их распечаткой? что бы случайно в продакшене не
//                if b == nil {
//                    print("error")
//                }else{
//                    let theJSONData = try? JSONSerialization.data(
//                        withJSONObject: b!,
//                        options: [])
//                    let decoder = JSONDecoder()
//                    let decodedDict = try? decoder.decode( [String: Category].self, from: theJSONData!)
//                    if decodedDict?.values == nil{
//                        print("decodedDict == nil error")
//                    }else{
//                        decodedDict!.forEach({ (arg0) in
//                            let (key, value) = arg0
//                            dictKey.append(key)
//
//                            dictKey.sort(by:{$0 > $1})
//                            print("Key-----------",dictKey)
//
//                            if key != "" {
//                                for item in value.Rooms{
//                                    if key == item.value.dataTimeOrder {
//                                        // мб благодаря этому условию можно будет избежать дополнительной сортировки, но не факт
//                                    }
//                                    let _rooms = Rooms(title: item.value.title!, userId: item.value.userId!, price: item.value.price!, status: item.value.status!, order: item.value.order!, image: item.value.image!, dataTimeOrder:item.value.dataTimeOrder!, dateArrival: item.value.dateArrival!, dateDeparture: item.value.dateDeparture!, dateApprovedOrders: item.value.dateApprovedOrders!, descriptionRoom: item.value.descriptionRoom!)
//                                    rooms.append(_rooms)
//                                    tbc.reloadData()
//
//                                }
//                                for item in value.Services{
//                                    let _serv = Servicess(title: item.value.title!, price: item.value.price!, userId: item.value.userId!, order: item.value.order!, status: item.value.status!, image: item.value.image!, dataTimeOrder: item.value.dataTimeOrder!, dateComplitionServ: item.value.dateComplitionServ!, dateApprovedOrders: item.value.dateApprovedOrders!, descriptionServ: item.value.descriptionServ!)
//                                    services.append(_serv)
//                                    tbc.reloadData()
//
//                                }
//                                for item in value.Profile{
//                                    let _profil = userAndAdmin(email: item.value.email!, fullName: item.value.fullName!, isAdmin: item.value.isAdmin!, passport: item.value.passport!, password: item.value.password!, userId: item.value.userId!, phoneNumber: item.value.phoneNumber!, dataTimeOrder: item.value.dataTimeOrder!, dateApprovedOrders:item.value.dateApprovedOrders!)
//                                    profile.append(_profil)
//                                    tbc.reloadData()
//                                }
//                            } else{
//                                print("key isEmpty")
//                            }
//                        })
//                    }
//                }
//            }
//        })
//    }
//}
