import UIKit
import Firebase
class roomsDemostretionViewController: UIViewController {
    @IBOutlet weak var titleRoomLabel: UILabel!
    @IBOutlet weak var priceRoomLabel: UILabel!
    @IBOutlet weak var textFieldDateArrival: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var textFieldDateDeparture: UITextField!
    @IBOutlet weak var imageViewLabel: UIImageView!
    @IBOutlet weak var buscetButton: UIButton!
    var _rooms = [Rooms]()
    var sortedRooms = [Rooms]()
    var sortedProfile = [userAndAdmin]()
    var _services = [Servicess]()
    var _profile = [userAndAdmin]()
    var _buscet = [Category]()
    var _dictKey = [String]()
    
    var arrayOrderArrival = [String]()
    var arrayOrderDeparture = [String]()
    
    var rooms = Rooms() // конкретный номер переданный с прошлого TBV
    var user: Users!
    
    var datePicker: UIDatePicker?
    var datePickerDeparture: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController()
        setupFirebase()
        image()
        datePickerFunc()
        dataPickerDEparture()
        roomArray()
        downloadDate()
        setupButton()
        setupDescription()
    }
    
    // MARK: - OrderButton
    @IBAction func orderButton(_ sender: Any) {
        if (String(textFieldDateDeparture.text!)<=String(textFieldDateArrival.text!)) || textFieldDateDeparture.text!.isEmpty && ((textFieldDateArrival.text!.isEmpty) )  {//если дата выезда меньше даты заезда или поля пустые 
            self.showAlert(title: "Введенные данные некорректны", message: "")
        }else{
            reservationCheck()
        }
    }
    
    func reservationCheck(){
        arrayOrderArrival.removeAll()
        arrayOrderDeparture.removeAll()
        
        
        if _rooms.count == 0 { //если массив пустой то его нет в ветки брони
            buscet()
            self.showAlert(title: "Номер добавлен", message: "")
            
        } else { // если в нем лежит что-то идет проверка на даты
            for i in _rooms{
                if i.dateArrival == nil || i.dateDeparture == nil{
                    print("date = nil")
                }else{
                    arrayOrderArrival.append(i.dateArrival!)
                    arrayOrderDeparture.append(i.dateDeparture!)
                    if ((i.dateArrival!<=String(textFieldDateArrival.text!) && i.dateDeparture! >= String(textFieldDateArrival.text!)) || (i.dateArrival! <= String(textFieldDateDeparture.text!) && i.dateDeparture! >= String(textFieldDateDeparture.text!) )) || ((String(textFieldDateArrival.text!) <= i.dateArrival!) && (String(textFieldDateDeparture.text!) >= i.dateDeparture!)){
                        self.showAlert(title: "Номер занят" , message: "Номер в эти даты занят c \(arrayOrderArrival) по \(arrayOrderDeparture))")
                        break
                    }else{
                        //  buscet()
                        // self.showAlert(title: "Номер добавлен", message: "")
                    }
                }
            }
            buscet()
            self.showAlert(title: "Номер добавлен", message: "")
        }
    }
    func buscet(){
        let ref = Database.database().reference().child("users").child(user.uid!).child("Buscet").child("Rooms")
        if let title = rooms.title {
            rooms.dateArrival = textFieldDateArrival.text
            rooms.dateDeparture = textFieldDateDeparture.text
            let roomsRef = ref.child(title.lowercased())
            roomsRef.setValue(rooms.convertToDictionary())
        }
    }
    func setupButton(){
        buscetButton.layer.cornerRadius = 10  /// радиус закругления закругление
        buscetButton.layer.borderWidth = 1.0   // толщина обводки
        buscetButton.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        buscetButton.clipsToBounds = true  // не забудь это, а то не закруглиться
    }
}

