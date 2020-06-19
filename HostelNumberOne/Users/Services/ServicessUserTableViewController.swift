import UIKit
import Firebase

class ServicessUserTableViewController: UITableViewController {
    var ref : DatabaseReference?
    var user: Users!
    var servic = Array<Servicess>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFirebase()
        setupBackButton()
    }
    func setupBackButton(){
        self.navigationItem.backBarButtonItem=UIBarButtonItem(title:"", style: .plain, target: nil, action: nil)//с кнопки назад убирает название
        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
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
            var _services = Array<Servicess>()
            for item in snapshot.children {
                let serv = Servicess(snapshot: item as! DataSnapshot)
                _services.append(serv)
            }
            self?.servic = _services
            self?.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref?.removeAllObservers() // удаление наблюдателя
    }
}

// MARK: - Table view data source
extension ServicessUserTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servic.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServicessUserTableViewCell
        let _services = servic[indexPath.row]
        cell.configure(with: _services)
        return cell
    }
    func roomsToDisplay(indexPath : IndexPath) -> Servicess { 
        let _serv : Servicess
        _serv = servic[indexPath.row]
        return _serv
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // объявление сегвея передача данных
        if segue.identifier == "detailSegue"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let dvc = segue.destination as? userServicesDemonstrationViewController
                dvc?.serv = roomsToDisplay(indexPath: indexPath)
            }
        }
    }
}


