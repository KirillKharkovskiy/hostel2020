import UIKit
import Firebase
class ViewController: UIViewController {
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registetionButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warnLabel.alpha = 0 // ошибка при загрузке не будет показываться те прозрачный
        button()
        textfieldSetup()
    }
    
    @IBAction func unwindToThisLOGIN(segue: UIStoryboardSegue){ // объявление сегвея для возврата на этот вью
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        loginTap()
    }
    
    func loginTap(){
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                // Do something after login
            } else {
                self.showAlert(title: "Error!", message: "\(error!.localizedDescription)")
            }
        }
    }
    func displayWarningLabel(withText text:String){
        warnLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {[weak self] in
            self?.warnLabel.alpha = 1
        }) {[weak self] comlete in
            self?.warnLabel.alpha = 0
        }
    }
}

// MARK: - design
extension ViewController {
    // MARK: - designTextField
    func textfieldSetup(){
        emailTextField.layer.cornerRadius = 5  /// радиус закругления закругление
        emailTextField.layer.borderWidth = 1.0   // толщина обводки
        emailTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        emailTextField.clipsToBounds = true  // не забудь это, а то не закруглиться
        
        emailTextField.layer.cornerRadius = 5  /// радиус закругления закругление
        passwordTextField.layer.borderWidth = 1.0   // толщина обводки
        passwordTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        passwordTextField.clipsToBounds = true  // не забудь это, а то не закруглиться
    }
    // MARK: - designButton
    func button(){
        loginButton.layer.cornerRadius = 14  /// радиус закругления закругление
        loginButton.layer.borderWidth = 1.0   // толщина обводки
        loginButton.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        loginButton.clipsToBounds = true  // не забудь это, а то не закруглиться
        
        registetionButton.layer.cornerRadius = 14    /// радиус закругления закругление
        registetionButton.layer.borderWidth = 2.0   // толщина обводки
        registetionButton.layer.borderColor = #colorLiteral(red: 0.6617645803, green: 0.2561969185, blue: 0.9686274529, alpha: 1)
        registetionButton.clipsToBounds = true  // не забудь это, а то не закруглиться
    }
}



