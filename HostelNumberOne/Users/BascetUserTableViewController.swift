import UIKit
import Firebase

class BascetUserTableViewController: UITableViewController {
   
    var user: Users!
    var rooms = [Rooms]()
    var serv = [Servicess]()
    var profile = [userAndAdmin]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero) // мметод что бы не прорисовывались лишнии ячейки
        tableView.reloadData()
        setupFirebase()
    }
    
   
    func setupFirebase(){
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser )
    }
    //  MARK: - Download "(userBuscet)"
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        observeDataRooms()
        observeDataServices()
        observeDataProfile()
    }
    func observeDataRooms(){
        let refRoomsBuscet = Database.database().reference(withPath:"users").child(user.uid!).child("Buscet").child("Rooms")
        refRoomsBuscet.observe(.value, with: { [weak self](snapshot) in
            var _rooms = Array<Rooms>()
            for item in snapshot.children {
                let rooms = Rooms(snapshot: item as! DataSnapshot)
                _rooms.append(rooms)
            }
            self?.rooms = _rooms
            self?.tableView.reloadData()
        })
    }
    func observeDataServices(){
        let refServicesBuscet = Database.database().reference(withPath:"users").child(user.uid!).child("Buscet").child("Services")
        refServicesBuscet.observe(.value, with: { [weak self](snapshot) in
            var _services = Array<Servicess>()
            for item in snapshot.children {
                let serv = Servicess(snapshot: item as! DataSnapshot)
                _services.append(serv)
            }
            self?.serv = _services
            self?.tableView.reloadData()
        })
    }
    func observeDataProfile(){
        let refProfile = Database.database().reference(withPath:"users").child(user.uid!).child("profile")
        refProfile.observe(.value, with: { [weak self](snapshot) in
            var _profile = Array<userAndAdmin>()
            for item in snapshot.children{
                let allProfile = userAndAdmin(snapshot: item as! DataSnapshot)
                _profile.append(allProfile)
                print(_profile)
            }
            self?.profile = _profile
            self?.tableView.reloadData()
        })
    }
    

    //  MARK: - Order
    @IBAction func toOrder(_ sender: UIBarButtonItem) {
        if rooms.isEmpty && serv.isEmpty {
            self.showAlert(title: "Ваша корзина пуста", message:"")
        }else{
        orderBuscet()
        self.showAlert(title:"Заказ успешно выполнен", message: "В скором времени с вами свяжется администратор")
        
         Database.database().reference(withPath:"users").child(user.uid!).child("Buscet").removeValue()
        }
    }
    
    func orderBuscet(){
        let refHistoryOrderRoom = Database.database().reference(withPath:"users").child(user.uid!).child("HistoryOrder").child("Rooms")
        let refHostoryOrderServ = Database.database().reference(withPath:"users").child(user.uid!).child("HistoryOrder").child("Services")
        
        let ref = Database.database().reference().child("Buscet").child(datatime()).child("Rooms")
        let reff = Database.database().reference().child("Buscet").child(datatime()).child("Services")
        
        let refProfile = Database.database().reference().child("Buscet").child(datatime()).child("Profile")
        
        for i in rooms {
            if let title = i.title{
                i.userId = user.email
                i.dataTimeOrder = datatime()
                let romsRef = ref.child(title.lowercased())
                let historyRom = refHistoryOrderRoom.child(title.lowercased())
                historyRom.setValue(i.convertToDictionary())
                romsRef.setValue(i.convertToDictionary())
            }
        }
        for i in serv {
            if let title = i.title{
                i.userId = user.email
                i.dataTimeOrder = datatime()
                let servRef = reff.child(title.lowercased())
                let historyServ = refHostoryOrderServ.child(title.lowercased())
                historyServ.setValue(i.convertToDictionary())
                servRef.setValue(i.convertToDictionary())
            }
        }
        for i in profile {
            if let pofile = i.fullName{
                i.dataTimeOrder = datatime()
                let profRef = refProfile.child(pofile.lowercased())
                profRef.setValue(i.convertToDictionary())
            }
        }
    }
}

//  MARK: - TableView
extension BascetUserTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return rooms.count
        }else{
            return serv.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // first section
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BascetTableViewCell
            let _rooms = rooms[indexPath.row]
            cell.titleLabel.text = _rooms.title
            cell.priceLabel.text = _rooms.price
            cell.imageLogo.contentMode = .scaleAspectFill
            cell.imageLogo.layer.cornerRadius = 20
            cell.imageLogo.clipsToBounds = true
            if let imageLogo = _rooms.image{
                let url = URL(string: imageLogo)!
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageLogo?.image = UIImage(data: data!)
                    }
                    }.resume()
            }
            return cell
        } else { // other section (second)
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellServ", for: indexPath) as! BascetTableViewCell
            let _serv = serv[indexPath.row]
            
            
//            if let customView = Bundle.main.loadNibNamed("QuantityView", owner: self, options: nil)?.first as? QuantityView {
//                return customView
//            }
             
            cell.titleLabel.text = _serv.title
            cell.priceLabel.text = _serv.price
            cell.imageLogo.contentMode = .scaleAspectFill
            cell.imageLogo.layer.cornerRadius = 20
            cell.imageLogo.clipsToBounds = true
            
            if let imageLogo = _serv.image{
                let url = URL(string: imageLogo)!
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageLogo?.image = UIImage(data: data!)
                    }
                    }.resume()
            }
            return cell
            //сделать через case
        }
    }
    func datatime()->String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: now)
        return dateString
    }
}
