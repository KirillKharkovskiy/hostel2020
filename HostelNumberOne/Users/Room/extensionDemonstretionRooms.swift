import Foundation
import Firebase
extension roomsDemostretionViewController{
    
    // MARK: - Download Date
    func downloadDate(){
        let ref = Database.database().reference(withPath: "ApprovedOrders")
        ref.observe(.value, with: { (snapshot) in
            self._rooms.removeAll()
            self._services.removeAll()
            self._dictKey.removeAll()
            let s = snapshot.value
            if s == nil {
                print("error")
                return
            }else {
                let b = s as? [String: AnyObject]
                if b == nil {
                    print("error")
                }else{
                
                let theJSONData = try! JSONSerialization.data(
                    withJSONObject: b!,
                    options: [])
                let decoder = JSONDecoder()
                let decodedDict = try? decoder.decode( [String: Category].self, from: theJSONData)
                    if decodedDict?.values == nil {
                        print("error decodedDict == nil")
                    }else{
                        decodedDict!.forEach({ (arg0) in
                            let (key, value) = arg0
                            self._dictKey.append(key)
                            self._dictKey.sort(by:{$0 > $1})
                            
                            print("key-------",key)
                            if key != "" {
                                for item in value.Rooms{
                                    if self.rooms.title == item.value.title{
                                        let _roomss = Rooms(title: item.value.title!, userId: item.value.userId!, price: item.value.price!, status: item.value.status!, order: item.value.order!, image: item.value.image!, dataTimeOrder:item.value.dataTimeOrder!, dateArrival: item.value.dateArrival!, dateDeparture: item.value.dateDeparture!, dateApprovedOrders: item.value.dateApprovedOrders!, descriptionRoom: item.value.descriptionRoom!)
                                        self._rooms.append(_roomss)
                                        //сортировка по имени если совпадение то добавляется иначе выход с цикла
                                    }
                                    else {
                                        break
                                    }
                                }
                            } else{
                                print("key isEmpty")
                            }
                        })
                    }
                }
            }
        })
    }
    
    // MARK: - DataPicker Departure
    func dataPickerDEparture(){
        datePickerDeparture = UIDatePicker()
        datePickerDeparture?.datePickerMode = .date
        datePickerDeparture?.minimumDate = datePicker?.date
        textFieldDateDeparture.inputView = datePickerDeparture
        datePickerDeparture?.addTarget(self, action: #selector(dataChangetDeparture(dataPicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(roomsDemostretionViewController.viewTappedDeparture(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func viewTappedDeparture(gestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func dataChangetDeparture(dataPicker: UIDatePicker){
        let dataFormated = DateFormatter()
        dataFormated.dateFormat = "MM/dd/yyyy"
        textFieldDateDeparture.text = dataFormated.string(from: (datePickerDeparture!.date))//maximumDate
        print("_____________________",textFieldDateDeparture.text!)
        view.endEditing(true)
    }
    
    // MARK: - DatrPicker Arrival
    func datePickerFunc(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date // если убрать будет дата с временем
        datePicker?.minimumDate = datePicker?.date
        textFieldDateArrival.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(roomsDemostretionViewController.dataChangetArrival(dataPicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(roomsDemostretionViewController.viewTappedArrival(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func viewTappedArrival(gestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func dataChangetArrival(dataPicker: UIDatePicker){
        let dataFormated = DateFormatter()
        dataFormated.dateFormat = "MM/dd/yyyy"
        textFieldDateArrival.text = dataFormated.string(from: datePicker!.date)//minimumDate
        print("_____________________",textFieldDateArrival.text!)
        view.endEditing(true)
        
    }
    
    // MARK: - ViewDidload
    func roomArray(){
        titleRoomLabel.text = rooms.title
        priceRoomLabel.text = rooms.price! + " руб"
        descriptionTextView.text = rooms.descriptionRoom
        descriptionTextView.isEditable = false 

    }
    func setupDescription(){
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.borderWidth = 1.2
        descriptionTextView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        descriptionTextView.clipsToBounds = true
    }
    func setupFirebase(){
        guard let currentUser = Auth.auth().currentUser else {return}
        user = Users(user: currentUser )
    }
    func navigationController(){
        title = rooms.title
        self.navigationItem.backBarButtonItem=UIBarButtonItem(title:"", style:.plain, target: nil, action: nil)//с кнопки назад убирает название
    }
    func image(){
        if let imageLogo = rooms.image{
            let url = URL(string: imageLogo)!
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    self.imageViewLabel?.image = UIImage(data: data!)
                    self.imageViewLabel.layer.cornerRadius = 20
                    self.imageViewLabel.clipsToBounds = true
                }
                }.resume()
        }
    }
}












