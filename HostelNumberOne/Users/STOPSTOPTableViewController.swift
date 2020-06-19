import UIKit
import Firebase
import FirebaseAuth

class RoomsUserTableViewController: UITableViewController {
    @IBAction func unwindToThisUserRooms(segue: UIStoryboardSegue){ // объявление сегвея для возврата на этот вью
    }
    @IBAction func enterLoginRegister(segue: UIStoryboardSegue){ // объявление сегвея для возврата на этот вью
    }
    
    @IBAction func exitButton(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    var ref : DatabaseReference?
    var user: Users!
    var rooms = Array<Rooms>()
    
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
        tableView.reloadData()
    }
    func setupFirebase(){
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser )
        ref = Database.database().reference(withPath:"ROOMS")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeData()
    }
    func observeData(){
        ref!.observe(.value, with: { [weak self](snapshot) in
            var _rooms = Array<Rooms>()
            for item in snapshot.children {
                let rooms = Rooms(snapshot: item as! DataSnapshot)
                _rooms.append(rooms)
            }
            self?.rooms = _rooms
            
            self?.tableView.reloadData()
        })
    }
}

// MARK: - Table view data source
extension RoomsUserTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RoomsUserTableViewCell
        let _rooms = rooms[indexPath.row]
        cell.configure(with: _rooms)
        return cell
    }
    
    func roomsToDisplay(indexPath : IndexPath) -> Rooms { //метод для понимания что выводить на экран /либо по поиску либо все рестораны
        let _rooms : Rooms
        _rooms = rooms[indexPath.row]
        return _rooms
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // объявление сегвея передача данных
        if segue.identifier == "detailSegue"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let dvc = segue.destination as? roomsDemostretionViewController
                dvc?.rooms = roomsToDisplay(indexPath: indexPath)
            }
        }
    }
}



