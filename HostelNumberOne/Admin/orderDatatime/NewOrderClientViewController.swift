import UIKit
import Firebase

class NewOrderClientViewController: UIViewController {
    @IBAction func unwindToThisOrderMain(segue: UIStoryboardSegue){ // объявление сегвея для возврата на этот вью
     }
    @IBOutlet weak var tableView: UITableView!
    var rooms = [Rooms]()
    var services = [Servicess]()
    var profile = [userAndAdmin]()
    var buscet = [Category]()
    var dictKey = [String]()
    var arrayRooms = [Rooms].self
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    func setupTableView(){
        tableView.tableFooterView = UIView(frame: CGRect.zero) // мметод что бы не прорисовывались лишнии ячейки
        tableView.reloadData()
//        NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification, object: .none, queue: OperationQueue.main) { [weak self] _ in
//                  self?.tableView.reloadData()
//              }
    }
    override func viewWillAppear(_ animated: Bool) { // включаем свайп
        super.viewWillAppear(true)
        tableView.reloadData()
        observdata()
        tableView.reloadData()
    }
}
// MARK: - Table view data source
extension NewOrderClientViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dictKey.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OrderUserTableViewCell
        let dictIndex = dictKey[indexPath.row]
            cell.mailLabel.text = dictIndex
            cell.accessoryType = .disclosureIndicator
        return cell
    }
}


// MARK: - download child"Buscet"
extension NewOrderClientViewController{
    func observdata(){
        let ref = Database.database().reference(withPath: "Buscet")
        ref.observe(.value, with: { (snapshot) in
            self.rooms.removeAll()
            self.services.removeAll()
            self.dictKey.removeAll()
            
            let s = snapshot.value
            if s == nil {
                print("Error")
            }else{
                let b = s as? [String: AnyObject] // TODO: переделай на as? и на обычный try с отловом ошибок и их распечаткой? что бы случайно в продакшене не
                if b == nil {
                    print("error")
                }else{
                    let theJSONData = try? JSONSerialization.data(
                        withJSONObject: b!,
                        options: [])
                    let decoder = JSONDecoder()
                    let decodedDict = try? decoder.decode( [String: Category].self, from: theJSONData!)
                    if decodedDict?.values == nil{
                        print("decodedDict == nil error")
                    }else{
                        decodedDict!.forEach({ (arg0) in
                            let (key, value) = arg0
                            self.dictKey.append(key)
                            
                            self.dictKey.sort(by:{$0 > $1})
                            
                            if key != "" {
                                for item in value.Rooms{
                                    if key == item.value.dataTimeOrder {
                                        // мб благодаря этому условию можно будет избежать дополнительной сортировки, но не факт
                                    
                                    let _rooms = Rooms(title: item.value.title!, userId: item.value.userId!, price: item.value.price!, status: item.value.status!, order: item.value.order!, image: item.value.image!, dataTimeOrder:item.value.dataTimeOrder!, dateArrival: item.value.dateArrival!, dateDeparture: item.value.dateDeparture!, dateApprovedOrders: item.value.dateApprovedOrders!, descriptionRoom: item.value.descriptionRoom!)
                                    self.rooms.append(_rooms)
                                    self.tableView.reloadData()
                                    }
                                }
                                for item in value.Services{
                                     if key == item.value.dataTimeOrder {
                                    let _serv = Servicess(title: item.value.title!, price: item.value.price!, userId: item.value.userId!, order: item.value.order!, status: item.value.status!, image: item.value.image!, dataTimeOrder: item.value.dataTimeOrder!, dateComplitionServ: item.value.dateComplitionServ!, dateApprovedOrders: item.value.dateApprovedOrders!, descriptionServ: item.value.descriptionServ!)
                                    self.services.append(_serv)
                                    self.tableView.reloadData()
                                    }
                                }
                                for item in value.Profile{
                                     if key == item.value.dataTimeOrder {
                                    let _profil = userAndAdmin(email: item.value.email!, fullName: item.value.fullName!, isAdmin: item.value.isAdmin!, passport: item.value.passport!, password: item.value.password!, userId: item.value.userId!, phoneNumber: item.value.phoneNumber!, dataTimeOrder: item.value.dataTimeOrder!, dateApprovedOrders: item.value.dateApprovedOrders!)
                                    self.profile.append(_profil)
                                    self.tableView.reloadData()
                                    }
                                }
                            } else{
                                print("key isEmpty")
                            }
                        })
                    }
                }
            }
        })
    }
    
}
// MARK: - segue
extension NewOrderClientViewController{
    func toDisplayServ(indexPath : IndexPath) -> String {
        var _dickKey: String = ""
        _dickKey = dictKey[indexPath.row]
        return _dickKey
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // объявление сегвея передача данных
        if segue.identifier == "detailSegue"{
            let dvc = segue.destination as? OrderAllViewController
            
            let indexPath = tableView.indexPathForSelectedRow
            dvc?._rooms.append(contentsOf: rooms)
            dvc?._services.append(contentsOf: services)
            dvc?._profile.append(contentsOf: profile)
            if dvc?._dictKey == nil {
                print("error")
            }else{
                dvc?._dictKey = toDisplayServ(indexPath: (indexPath!))
                
            }
        }
        
    }
}



