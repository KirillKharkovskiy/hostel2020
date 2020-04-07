import UIKit
import Firebase

class ComplitionAllClientViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonEvictionClient: UIButton!
    var _rooms = [Rooms]()
    var _services = [Servicess]()
    var _dictKey : String = ""
    var _profile = [userAndAdmin]()
    var sortedProfile = [userAndAdmin]()
    var sortedArrayRooms = [Rooms]()
    var sortedArrayServices = [Servicess]()
    let sectionHeaders = [" Profile ","Room","Services"] // Заголовки
    var sectionContent = [[userAndAdmin]().self,[Rooms]().self,[Servicess]().self] as [Any]

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
        buttonEvictionClient.layer.cornerRadius = 8  /// радиус закругления закругление
        buttonEvictionClient.clipsToBounds = true  // не забудь это, а то не закруглиться
        buttonEvictionClient.layer.cornerRadius = 8    /// радиус закругления закругление
        buttonEvictionClient.layer.borderWidth = 2.0   // толщина обводки
        buttonEvictionClient.layer.borderColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        buttonEvictionClient.clipsToBounds = true  // не забудь это, а то не закруглиться
    }
    
    // MARK: - ActionButtonEvectionClient
    @IBAction func buttonEvicttionClient(_ sender: Any) {
        Database.database().reference().child("ApprovedOrders").child(String(_dictKey)).removeValue()
        self.performSegue(withIdentifier: "cancel", sender: self)
               tableView.reloadData()
    }
    
}
// MARK: - Table view data source
extension ComplitionAllClientViewController: UITableViewDataSource,UITableViewDelegate{
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellProfile", for: indexPath) as! ComlitionAllCellTableViewCell
            let profile = sortedProfile[indexPath.row]
            cell.fullNameLabel.text = profile.fullName
            cell.emailLabel.text = profile.email
            cell.passportLabel.text = profile.passport
            cell.telephoneLabel.text = profile.phoneNumber
            cell.passwordLabel.text = profile.password
            cell.userIdLabel.text = profile.userId
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellRooms", for: indexPath) as! ComlitionAllCellTableViewCell
            let rooms = sortedArrayRooms[indexPath.row]
            cell.titleLabel.text = rooms.title
            cell.priceLabel.text = rooms.price
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellServices", for: indexPath) as! ComlitionAllCellTableViewCell
            let services = sortedArrayServices[indexPath.row]
            cell.titleLabel.text = services.title
            cell.priceLabel.text = services.price
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
// MARK: - sorted Rooms and Services
extension ComplitionAllClientViewController{
    func sortedRooms(){
        for item in _rooms{
            if [item.dateApprovedOrders] == [_dictKey] {
                let rooms = Rooms(title: item.title!, userId: item.userId!, price: item.price!, status: item.status!, order: item.order!, image: item.image!, dataTimeOrder: item.dataTimeOrder!, dateArrival: item.dateArrival!, dateDeparture: item.dateDeparture!, dateApprovedOrders: item.dateApprovedOrders!, descriptionRoom: item.descriptionRoom!)
                self.sortedArrayRooms.append(rooms)
                self.sectionContent.append(rooms)
                
                tableView.reloadData()
            }
        }
    }
    
    
    func sortedServic(){
        for item in _services{
            if [item.dateApprovedOrders] == [_dictKey] {
                let serv = Servicess(title: item.title!, price: item.price!, userId: item.userId!, order: item.order!, status: item.status!, image: item.image!, dataTimeOrder: item.dataTimeOrder!, dateComplitionServ: item.dateComplitionServ!, dateApprovedOrders: item.dateApprovedOrders!, descriptionServ: item.descriptionServ!)
                self.sortedArrayServices.append(serv)
                self.sectionContent.append(serv)
                tableView.reloadData()
            }
        }
    }
    
    func sortedProfilefunc(){
        for itemProfile in _profile{
            for itemRooms in sortedArrayRooms{
                if itemProfile.email == itemRooms.userId {
                    let prof = userAndAdmin(email: itemProfile.email!, fullName: itemProfile.fullName!, isAdmin: itemProfile.isAdmin!, passport: itemProfile.passport!, password: itemProfile.password!, userId: itemProfile.userId!, phoneNumber: itemProfile.phoneNumber!, dataTimeOrder: itemProfile.dataTimeOrder!, dateApprovedOrders: itemProfile.dateApprovedOrders!)
                    self.sortedProfile.append(prof)
                    self.sectionContent.append(prof)
                    tableView.reloadData()
                }
            }
        }
    }
    
    
}

