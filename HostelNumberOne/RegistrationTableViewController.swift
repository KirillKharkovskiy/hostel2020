import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegistrationTableViewController: UITableViewController {
    
    var ref : DatabaseReference?
    var usersArray = Array<userAndAdmin>()
    var user : Users!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero) // мметод что бы не прорисовывались лишнии ячейки
        setupkeyboard()
        
    }
    func setupkeyboard(){
        emailTextField.keyboardType = .emailAddress
        phoneNumberField.keyboardType = .asciiCapableNumberPad
    }
    
    @IBAction func registerTapped(_ sender: UIBarButtonItem) {
        guard let fullName = fullNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let phoneNumber = phoneNumberField.text, !fullName.isEmpty , !email.isEmpty, !password.isEmpty, !phoneNumber.isEmpty else {
            showAlert(title: "Error!", message: "Вы заполнили не все поля!")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let databaseRef = Database.database().reference().child("users/\(uid)/profile")
            
            if error == nil && user != nil {
                print("User created!")
                let profil = userAndAdmin(email: email, fullName: fullName, isAdmin:"false", password: password, userId: uid, phoneNumber: phoneNumber, dataTimeOrder: "non", dateApprovedOrders: "non")
                if let fulname = profil.fullName{
                    let userRef = databaseRef.child(fulname.lowercased())
                    userRef.setValue(profil.convertToDictionary())
                }
            } else {
                self.showAlert(title: "Error", message: "\(error!.localizedDescription)")
            }
        }
    }
}
