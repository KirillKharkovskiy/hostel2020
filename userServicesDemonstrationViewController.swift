import UIKit
import Firebase
class userServicesDemonstrationViewController: UIViewController {
    @IBOutlet weak var titleServicesLabel: UILabel!
    @IBOutlet weak var priceServicesLabel: UILabel!
    @IBOutlet weak var textFieldDateOrder: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageViewLabel: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    var user: Users!
    var datePicker: UIDatePicker?
    var serv = Servicess()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerFunc()
        setupFirebase()
        navigationController()
        servicesArray()
        image()
        
    }
    
    // MARK: - DatrPicker Arrival
    func datePickerFunc(){
        datePicker = UIDatePicker()
       // datePicker?.datePickerMode = .date // если убрать будет дата с временем
        datePicker?.minimumDate = datePicker?.date
        textFieldDateOrder.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(roomsDemostretionViewController.dataChangetArrival(dataPicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(roomsDemostretionViewController.viewTappedArrival(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func viewTappedArrival(gestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func dataChangetArrival(dataPicker: UIDatePicker){
        let dataFormated = DateFormatter()
          dataFormated.dateFormat = "MM/dd - HH:mm"
        textFieldDateOrder.text = dataFormated.string(from: datePicker!.date)//minimumDate
        view.endEditing(true)
    }
    
    // MARK: - ViewDidload
    func servicesArray(){
        titleServicesLabel.text = serv.title
        priceServicesLabel.text = serv.price
        descriptionTextView.text = serv.descriptionServ
        descriptionTextView.isEditable = false
    }
    func setupFirebase(){
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser )
    }
    func navigationController(){
        title = serv.title
        self.navigationItem.backBarButtonItem=UIBarButtonItem(title:"", style:.plain, target: nil, action: nil)//с кнопки назад убирает название
    }
    func image(){
        if let imageLogo = serv.image{
            let url = URL(string: imageLogo)!
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    self.imageViewLabel?.image = UIImage(data: data!)
                }
                }.resume()
        }
    }
    

    @IBAction func buttonAddBuscet(_ sender: Any) {
        if textFieldDateOrder.text!.isEmpty{
            showAlert(title: "Выберите дату", message: "")
        }else{
            buscet()
            showAlert(title: "Услуга добавлена", message: "")
        }
    }
  
    func buscet(){
        let ref = Database.database().reference().child("users").child(user.uid!).child("Buscet").child("Services")
        if let title = serv.title {
            serv.dateComplitionServ = textFieldDateOrder.text
            let servRef = ref.child(title.lowercased())
            servRef.setValue(serv.convertToDictionary())
        }
    }
    
}
