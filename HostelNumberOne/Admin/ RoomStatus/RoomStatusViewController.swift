import UIKit
import Firebase

class RoomStatusViewController: UIViewController, DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
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
        setupView()
    }
    func setupView(){
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }
    
    func setupTableView(){
        tableView.tableFooterView = UIView(frame: CGRect.zero) // мметод что бы не прорисовывались лишнии ячейки
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) { // включаем свайп
        super.viewWillAppear(true)
        observdata()
        tableView.reloadData()
    }
}
// MARK: - TBV

extension RoomStatusViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RoomStatusTableViewCell
        let room = rooms[indexPath.row]
        print(rooms.count)
        cell.titileLabel.text = room.title
        cell.arrivalDateLabel.text = " Дата заезда: " + room.dateArrival!
        cell.dateDepartureLabel.text = " Дата выезда: " + room.dateDeparture!
        cell.imageViewLabel.contentMode = .scaleAspectFill
        cell.imageViewLabel.layer.cornerRadius = 20
        cell.imageViewLabel.clipsToBounds = true
        if let imageLogo = room.image{
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

// MARK: - download child"ApprovedOrders"
extension RoomStatusViewController{
    func observdata(){
        let ref = Database.database().reference(withPath: "ApprovedOrders")
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
                            print("Key-----------",self.dictKey)
                            
                            if key != "" {
                                for item in value.Rooms{
                                    if key == item.value.dataTimeOrder {
                                        // мб благодаря этому условию можно будет избежать дополнительной сортировки, но не факт
                                    }
                                    let _rooms = Rooms(title: item.value.title!, userId: item.value.userId!, price: item.value.price!, status: item.value.status!, order: item.value.order!, image: item.value.image!, dataTimeOrder:item.value.dataTimeOrder!, dateArrival: item.value.dateArrival!, dateDeparture: item.value.dateDeparture!, dateApprovedOrders: item.value.dateApprovedOrders!, descriptionRoom: item.value.descriptionRoom!)
                                    self.rooms.append(_rooms)
                                    self.tableView.reloadData()
                                }
                                for item in value.Services{
                                    let _serv = Servicess(title: item.value.title!, price: item.value.price!, userId: item.value.userId!, order: item.value.order!, status: item.value.status!, image: item.value.image!, dataTimeOrder: item.value.dataTimeOrder!, dateComplitionServ: item.value.dateComplitionServ!, dateApprovedOrders: item.value.dateApprovedOrders!, descriptionServ: item.value.descriptionServ!)
                                    self.services.append(_serv)
                                    self.tableView.reloadData()
                                }
                                for item in value.Profile{
                                    let _profil = userAndAdmin(email: item.value.email!, fullName: item.value.fullName!, isAdmin: item.value.isAdmin!, passport: item.value.passport!, password: item.value.password!, userId: item.value.userId!, phoneNumber: item.value.phoneNumber!, dataTimeOrder: item.value.dataTimeOrder!, dateApprovedOrders:item.value.dateApprovedOrders!)
                                    self.profile.append(_profil)
                                    self.tableView.reloadData()
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

// MARK:- DZNEmptyDataSet
extension RoomStatusViewController{

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Все номера свободны"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Пока вы не одобрите заказ, номер будет свободен"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "roms35")
    }
    
    
}
