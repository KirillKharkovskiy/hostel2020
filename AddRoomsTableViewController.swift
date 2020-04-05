import UIKit
import Firebase
import FirebaseStorage

class AddRoomsTableViewController: UITableViewController {
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    var ref:DatabaseReference?
    let imagePicker = UIImagePickerController()
    
    @IBAction func saveNewRooms(_ sender: UIBarButtonItem) {
        uploadImagee()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFirebase()
        setupImageView()
    }
    func setupTableView(){
        tableView.tableFooterView = UIView(frame: CGRect.zero) // мметод что бы не прорисовывались лишнии ячейки
        priceLabel.keyboardType = .decimalPad //  цифровая клавиатура
    }
    func setupFirebase(){
        ref = Database.database().reference(withPath: "ROOMS")
    }
    func setupImageView(){
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(AddRoomsTableViewController.openGallery(tapGesture:)))
        imageLabel.isUserInteractionEnabled = true
        imageLabel.addGestureRecognizer(tapGesture)
    }
    @objc func openGallery(tapGesture:UITapGestureRecognizer){
        self.setypImagePicker()
    }
    

}
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddRoomsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func setypImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.isEditing = true
            imagePicker.allowsEditing = true //возможность редактировать изображение
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        imageLabel.image = image
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - ImageFunc
extension AddRoomsTableViewController{
    func uploadImagee(){
        let imageName = NSUUID().uuidString
        if let imgData = self.imageLabel.image?.pngData() {
            guard let name = nameLabel.text, let price = priceLabel.text,let desriptionRoom = descriptionLabel.text, name != "", price != "", desriptionRoom != "" else {
                print("Form is not valid")
                return
            }
            let storageRef = Storage.storage().reference().child("Rooms_images").child("\(imageName).png")
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            storageRef.putData(imgData, metadata: metaData) {(metadata, error) in
                if error == nil {
                    print("good")
                    storageRef.downloadURL(completion: {[weak self] (url, error) in
                        if error == nil {
                            print("Good")
                        }
                        guard let url = url else { return }
                        let rooms = Rooms(title: name, userId: "user - Id", price: price, status: false, order: false, image: url.absoluteString, dataTimeOrder: "nil", dateArrival: "nil", dateDeparture: "nil", dateApprovedOrders:"nil", descriptionRoom: desriptionRoom)
                        if let title = rooms.title {
                            let romsRef = self?.ref?.child(title.lowercased())
                            romsRef?.setValue(rooms.convertToDictionary())
                            self!.performSegue(withIdentifier: "cancel", sender: self)
                        }
                    })
                }
            }
        }
    }
}

