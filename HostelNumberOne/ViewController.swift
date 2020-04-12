import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registetionButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    var ref : DatabaseReference!
    
    @IBAction func unwindToThisLOGIN(segue: UIStoryboardSegue){ // объявление сегвея для возврата на этот вью
    }
    
    func displayWarningLabel(withText text:String){
        warnLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {[weak self] in
            self?.warnLabel.alpha = 1
        }) {[weak self] comlete in
            self?.warnLabel.alpha = 0
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        warnLabel.alpha = 0 // ошибка при загрузке не будет показываться те прозрачный
        button()
        
    }
   // MARK: - designButton
    func button(){
        loginButton.layer.cornerRadius = 14  /// радиус закругления закругление
        loginButton.layer.borderWidth = 1.0   // толщина обводки
        loginButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        loginButton.clipsToBounds = true  // не забудь это, а то не закруглиться
        
        registetionButton.layer.cornerRadius = 14    /// радиус закругления закругление
        registetionButton.layer.borderWidth = 1.0   // толщина обводки
        registetionButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        registetionButton.clipsToBounds = true  // не забудь это, а то не закруглиться
    }
}


