import UIKit
import Firebase

class HistoryOrderViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var arrayRooms = [Rooms]()
    var arrayService = [Servicess]()
     var user: Users!
     let sectionHeaders = ["Room","Services"]
    var sectionContent = [[Rooms]().self,[Servicess]().self] as [Any]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupFirebase()
    }
    func setupFirebase(){
           
           guard let currentUser = Auth.auth().currentUser else {return}
           user = Users(user: currentUser)
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeDataRooms()
        observeDataServices()
        
    }
    
    
    func observeDataRooms(){
        let refRoomsBuscet = Database.database().reference(withPath:"users").child(user.uid!).child("HistoryOrder").child("Rooms")
        refRoomsBuscet.observe(.value, with: { [weak self](snapshot) in
            var _rooms = Array<Rooms>()
            for item in snapshot.children {
                let rooms = Rooms(snapshot: item as! DataSnapshot)
                _rooms.append(rooms)
            }
            self?.arrayRooms = _rooms
            self?.tableView.reloadData()
        })
    }
    func observeDataServices(){
        let refServicesBuscet = Database.database().reference(withPath:"users").child(user.uid!).child("HistoryOrder").child("Services")
        refServicesBuscet.observe(.value, with: { [weak self](snapshot) in
            var _services = Array<Servicess>()
            for item in snapshot.children {
                let serv = Servicess(snapshot: item as! DataSnapshot)
                _services.append(serv)
            }
            self?.arrayService = _services
            self?.tableView.reloadData()
        })
    }
    
    
}

// MARK: - TableViewController

extension HistoryOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            return arrayRooms.count
        }else {
            return arrayService.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellRoom", for: indexPath) as! HistoryOrderTableViewCell
            let rooms = arrayRooms[indexPath.row]
            cell.titleLabel.text = rooms.title
            cell.priceLabel.text = rooms.price! + " Руб."
            cell.arrivalLabel.text = rooms.dateArrival
            cell.departureLabel.text = rooms.dateDeparture
            cell.imageViewLabel.contentMode = .scaleAspectFill
               cell.imageViewLabel.layer.cornerRadius = 10
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
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellService", for: indexPath) as! HistoryOrderTableViewCell
            let serv = arrayService[indexPath.row]
            cell.titleLabel.text = serv.title
            cell.priceLabel.text = serv.price! + " Руб."
            cell.arrivalLabel.text = serv.dataTimeOrder
            cell.imageViewLabel.contentMode = .scaleAspectFill
            cell.imageViewLabel.layer.cornerRadius = 10
            cell.imageViewLabel.clipsToBounds = true
            if let imageLogo = serv.image{
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
