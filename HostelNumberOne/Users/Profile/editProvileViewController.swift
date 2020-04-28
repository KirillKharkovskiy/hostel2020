import UIKit
import Firebase

class editProvileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var user: Users!
    var profile = [userAndAdmin]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirebase()
        tableView.tableFooterView = UIView(frame: CGRect.zero) // мметод что бы не прорисовывались лишнии ячейки
    }
    func setupFirebase(){
        
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser)
    }
    
    @IBAction func buttonSave(_ sender: Any) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeDataProfile()
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
    
    
    
    
}

// MARK: - TableViewController
extension editProvileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrProfile = profile[indexPath.row]
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellFullName", for: indexPath) as! editProfileTableViewCell
            cell.fullNameTextField.text = arrProfile.fullName
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellPasport", for: indexPath) as! editProfileTableViewCell
            cell.passportTextField.text = arrProfile.passport
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellPhone", for: indexPath) as! editProfileTableViewCell
            cell.telephoneTextField.text = arrProfile.phoneNumber
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellEmail", for: indexPath) as! editProfileTableViewCell
            cell.emailLabel.text = arrProfile.email
            return cell
        }
    }
    
}


