import UIKit
import Firebase
class RoomsAdminTableViewController: UITableViewController {
    @IBAction func unwindToThisAdminRooms(segue: UIStoryboardSegue){ // объявление сегвея для возврата на этот вью
    }
    var ref : DatabaseReference?
    var user: Users!
    var rooms = Array<Rooms>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFirebase()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeData()
    }
    func setupTableView(){
        tableView.tableFooterView = UIView(frame: CGRect.zero) // мметод что бы не прорисовывались лишнии ячейки
    }
    func setupFirebase(){
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser )
        ref = Database.database().reference(withPath: "ROOMS")
    }
    func observeData(){
        ref?.observe(.value, with: {[weak self] (snapshot) in
            var _rooms = Array<Rooms>()
            for item in snapshot.children {
                let rooms = Rooms(snapshot: item as! DataSnapshot)
                _rooms.append(rooms)
            }
            self?.rooms = _rooms
            self?.tableView.reloadData()
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref?.removeAllObservers()
        tableView.reloadData()
    }
    
}
// MARK: - TableView
extension RoomsAdminTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RoomsAdminTableViewCell
        let _rooms = rooms[indexPath.row]
        cell.titleLabel.text = _rooms.title
        cell.priceLabel.text = _rooms.price! + " руб"
        cell.imageViewLabel.contentMode = .scaleAspectFill
        cell.imageViewLabel.layer.cornerRadius = 20
        cell.imageViewLabel.clipsToBounds = true
        if let imageLogo = _rooms.image{
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
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let listToBeDeleted = self.rooms[indexPath.row].title!
        let deleteAction = UITableViewRowAction(style: .default, title: "Удалить"){_,_ in
            self.ref?.child(listToBeDeleted).removeValue()
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        return [deleteAction]
    }
}


