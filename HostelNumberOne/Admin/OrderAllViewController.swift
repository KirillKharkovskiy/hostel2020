import UIKit
import Firebase
import MessageUI
class OrderAllViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate{
    @IBOutlet weak var buttonTrue: UIButton!
    @IBOutlet weak var buttonFalse: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var _rooms = [Rooms]()
    var _services = [Servicess]()
    var _dictKey : String = ""
    var _profile = [userAndAdmin]()
    var sortedProfile = [userAndAdmin]()
    var sortedArrayRooms = [Rooms]()
    var sortedArrayServices = [Servicess]()
    let sectionHeaders = [" Profile ","Room","Services"] // Заголовки
    var sectionContent = [[userAndAdmin]().self,[Rooms]().self,[Servicess]().self] as [Any]
    var sortedKey: String = ""
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        sortedRooms()
        sortedServic()
        sortedProfilefunc()
        button()
    }
    func setupTableView(){
        tableView.tableFooterView = UIView(frame: CGRect.zero) // мметод что бы не прорисовывались лишнии ячейки
    }
    func button(){
        buttonTrue.layer.cornerRadius = 8  /// радиус закругления закругление
        buttonTrue.clipsToBounds = true  // не забудь это, а то не закруглиться
        buttonFalse.layer.cornerRadius = 8    /// радиус закругления закругление
        buttonFalse.layer.borderWidth = 2.0   // толщина обводки
        buttonFalse.layer.borderColor = #colorLiteral(red: 1, green: 0.6210887085, blue: 0.9104183452, alpha: 1)
        buttonFalse.clipsToBounds = true  // не забудь это, а то не закруглиться
    }
    
    
    // MARK: - Button Order true
    @IBAction func buttonOrderTrue(_ sender: Any) {

//        let composer = MFMailComposeViewController()
//        if MFMailComposeViewController.canSendMail() {
//             composer.mailComposeDelegate = self
//            composer.setToRecipients([email])
//             composer.setSubject("Гостиничный комплекс TreeHotel")
//             composer.setMessageBody("Ваш номер и услуги одобрены приятного проживания", isHTML: false)
//             present(composer, animated: true, completion: nil)
//        }
//        print(email)
//        if !MFMailComposeViewController.canSendMail() {
//            print("Mail services are not available")
//            return
//        }
        approverOrderRoom()
        approveOrderServices()
        approverOrderProfile()
        Database.database().reference().child("Buscet").child(String(_dictKey)).removeValue() // удаление
         self.performSegue(withIdentifier: "cancel", sender: self)
         tableView.reloadData()
    }
    
    // MARK: - Button order false
    
    @IBAction func buttonFalseAction(_ sender: Any) {
       
//        let composer = MFMailComposeViewController()
//          if MFMailComposeViewController.canSendMail() {
//               composer.mailComposeDelegate = self
//              composer.setToRecipients([email])
//               composer.setSubject("Гостиничный комплекс TreeHotel")
//               composer.setMessageBody("Ваш заказ отклонен", isHTML: false)
//               present(composer, animated: true, completion: nil)
//          }
//          print(email)
//          if !MFMailComposeViewController.canSendMail() {
//              print("Mail services are not available")
//              return
//          }
        Database.database().reference().child("Buscet").child(String(_dictKey)).removeValue() // удаление
              self.performSegue(withIdentifier: "cancel", sender: self)
                    tableView.reloadData()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
         dismiss(animated: true, completion: nil)
     }

    
    
    // MARK: - approverOrder
    
    func approverOrderRoom(){
        let ref = Database.database().reference().child("ApprovedOrders").child(datatime()).child("Rooms")
        for i in sortedArrayRooms {
            if let title = i.title{
                i.status = true
                i.dateApprovedOrders = datatime()
                let romsRef = ref.child(title.lowercased())
                romsRef.setValue(i.convertToDictionary())
            }
        }
    }
    func approveOrderServices(){
        let ref = Database.database().reference().child("ApprovedOrders").child(datatime()).child("Services")
        for i in sortedArrayServices {
            if let title = i.title{
                i.status = true
                i.dateApprovedOrders = datatime()
                let servRef = ref.child(title.lowercased())
                servRef.setValue(i.convertToDictionary())
            }
        }
    }
    func approverOrderProfile(){
        let ref = Database.database().reference().child("ApprovedOrders").child(datatime()).child("Profile")
        for i in sortedProfile{
            if let profile = i.fullName{
                i.dateApprovedOrders = datatime()
                let profRef = ref.child(profile.lowercased())
                profRef.setValue(i.convertToDictionary())
            }
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
            return sortedArrayRooms.count
        }else{
            return sortedArrayServices.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellProfile", for: indexPath) as! orderViewCell
            let profile = sortedProfile[indexPath.row]
            cell.fullNameLabel.text = "Full name: " + profile.fullName!
            cell.emailLabel.text = "Email: " + profile.email!
            cell.passportLabel.text = "Passport: " + profile.passport!
            cell.phoneNumbelLabel.text = "Telephone: " + profile.phoneNumber!
            cell.passwordLabel.text = "Password: " + profile.password!
            cell.userIdLabel.text = "UserId: " + profile.userId!
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellRooms", for: indexPath) as! orderViewCell
            let rooms = sortedArrayRooms[indexPath.row]
            cell.titleLabel.text = rooms.title
            cell.priceLabel.text = rooms.price! + " руб."
            cell.statusLabel.text = "\(rooms.dateArrival!)-\(rooms.dateDeparture!)"
            cell.imageViewLabel.contentMode = .scaleAspectFill
            cell.imageViewLabel.layer.cornerRadius = 20
            cell.imageViewLabel.clipsToBounds = true
            if let imageLogo = rooms.image{
                let url = URL(string: imageLogo)!
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageViewLabel?.image = UIImage(data: data!)
                    }
                    }.resume()
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellServices", for: indexPath) as! orderViewCell
            let services = sortedArrayServices[indexPath.row]
            cell.titleLabel.text = services.title!
            cell.priceLabel.text = services.price! + " руб."
            cell.statusLabel.text = services.dateComplitionServ
            cell.imageViewLabel.contentMode = .scaleAspectFill
            cell.imageViewLabel.layer.cornerRadius = 20
            cell.imageViewLabel.clipsToBounds = true
            if let imageLogo = services.image{
                let url = URL(string: imageLogo)!
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageViewLabel?.image = UIImage(data: data!)
                    }
                    }.resume()
            }
            return cell
        }
    }
}
// MARK: - sorted Rooms and Services ,Profile
extension OrderAllViewController{
    func sortedRooms(){
        for item in _rooms{
            if [item.dataTimeOrder] == [_dictKey] {
                let rooms = Rooms(title: item.title!, userId: item.userId!, price: item.price!, status: item.status!, order: item.order!, image: item.image!, dataTimeOrder: item.dataTimeOrder!, dateArrival: item.dateArrival!, dateDeparture: item.dateDeparture!, dateApprovedOrders: item.dateApprovedOrders!, descriptionRoom: item.descriptionRoom!)
                self.sortedArrayRooms.append(rooms)
                self.sectionContent.append(rooms)
                
                tableView.reloadData()
            }
        }
    }
    func sortedServic(){
        for item in _services{
            if [item.dataTimeOrder] == [_dictKey] {
                let serv = Servicess(title: item.title!, price: item.price!, userId: item.userId!, order: item.order!, status: item.status!, image: item.image!, dataTimeOrder: item.dataTimeOrder!, dateComplitionServ: item.dateComplitionServ!, dateApprovedOrders: item.dateApprovedOrders!, descriptionServ: item.descriptionServ!)
                self.sortedArrayServices.append(serv)
                self.sectionContent.append(serv)
                tableView.reloadData()
            }
        }
    }
    func sortedProfilefunc(){
        email.removeAll()
        for itemProfile in _profile{
            for itemRooms in sortedArrayRooms{
                sortedKey.removeAll()
                if itemProfile.email == itemRooms.userId {
                    let prof = userAndAdmin(email: itemProfile.email!, fullName: itemProfile.fullName!, isAdmin: itemProfile.isAdmin!, passport: itemProfile.passport!, password: itemProfile.password!, userId: itemProfile.userId!, phoneNumber: itemProfile.phoneNumber!, dataTimeOrder: itemProfile.dataTimeOrder!, dateApprovedOrders: itemProfile.dateApprovedOrders!)
                    self.sortedProfile.append(prof)
                    self.sectionContent.append(prof)
                    email.append(contentsOf: prof.email!)
                    
                    tableView.reloadData()
                }
            }
            sortedKey.append(itemProfile.dataTimeOrder!)
        }
    }
}
// MARK: - convert dateTime
extension OrderAllViewController{
    func datatime()->String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: now)
        return dateString
    }
}
