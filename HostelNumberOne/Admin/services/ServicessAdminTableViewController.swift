import UIKit
import Firebase

class ServicessAdminTableViewController: UITableViewController {
    var ref:DatabaseReference?
    var user: Users!
    var servicess = Array<Servicess>()
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
    }
    @IBAction func unwindToThisAdminServicess(segue: UIStoryboardSegue){ // объявление сегвея для возврата на этот вью
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFirebase()
    }
    func setupTableView(){
        tableView.tableFooterView = UIView(frame: CGRect.zero) // мметод что бы не прорисовывались лишнии ячейки
    }
    func setupFirebase(){
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser)
        ref = Database.database().reference(withPath: "SERVICES")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeData()
    }
    func observeData(){
        ref!.observe(.value, with: { [weak self](snapshot) in
            var _servicess = Array<Servicess>()
            for item in snapshot.children {
                let servicess = Servicess(snapshot: item as! DataSnapshot)
                _servicess.append(servicess)
            }
            self?.servicess = _servicess
            self?.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref?.removeAllObservers()
    }
}
// MARK: - Table view data source
extension ServicessAdminTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicess.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServicessAdminTableViewCell
        let _services = servicess[indexPath.row]
        cell.titleTextLabel.text = _services.title
        cell.priceTextLabel.text = _services.price! + " руб"
        cell.imageLabel.contentMode = .scaleAspectFill
        cell.imageLabel.layer.cornerRadius = 20
        cell.imageLabel.clipsToBounds = true
        if let imageLogo = _services.image{
            let url = URL(string: imageLogo)!
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    cell.imageLabel?.image = UIImage(data: data!)
                }
            }.resume()
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let listToBeDeleted = self.servicess[indexPath.row].title!
        let deleteAction = UITableViewRowAction(style: .default, title: "Удалить"){_,_ in
            self.ref?.child(listToBeDeleted).removeValue()
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        return [deleteAction]
    }
}


