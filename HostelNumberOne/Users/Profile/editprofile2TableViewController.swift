import UIKit
import Firebase
class editprofile2TableViewController: UITableViewController {
    var user: Users!
    var profile = [userAndAdmin]()
    @IBOutlet weak var fullnametextField: UITextField!
    @IBOutlet weak var passportTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        setupFirebase()
        
    }
    func setupFirebase(){
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser)
    }
    // MARK: - saveButton
    @IBAction func saveButton(_ sender: Any) {
        let ref = Database.database().reference().child("users").child(user.uid!).child("profile").child(name)
        ref.updateChildValues([
            "passport" : passportTextField.text as Any,
            "phoneNumber" : telephoneTextField.text as Any])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeDataProfile()
    }
    // MARK: - observerData
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
            self?.demonstration()
            self?.tableView.reloadData()
        })
    }
    func demonstration(){
        for item in profile {
            fullnametextField.text = item.fullName
            fullnametextField.isUserInteractionEnabled = false
            passportTextField.text = item.passport
            telephoneTextField.text = item.phoneNumber
            emailTextField.text = item.email
            emailTextField.isUserInteractionEnabled = false
            name.append(contentsOf: item.fullName ?? "non")
        }
    }
}
