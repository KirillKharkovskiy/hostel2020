import UIKit
import Firebase
import FirebaseStorage

class AddServicessAdminTableViewController: UITableViewController {
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var nameServicessLabel: UITextField!
    @IBOutlet weak var descriptionServicessLabel: UITextField!
    @IBOutlet weak var priceServicessLabel: UITextField!
    var ref:DatabaseReference?
    let imagePicker = UIImagePickerController()
    
    @IBAction func saveNewServicess(_ sender: UIBarButtonItem) {
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
        priceServicessLabel.keyboardType = .decimalPad //  цифровая клавиатура
    }
    func setupFirebase(){
        ref = Database.database().reference(withPath: "SERVICES")
    }
    func setupImageView(){
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(AddServicessAdminTableViewController.openGallery(tapGesture:)))
        imageViewLogo.isUserInteractionEnabled = true
        imageViewLogo.addGestureRecognizer(tapGesture)
    }
    @objc func openGallery(tapGesture:UITapGestureRecognizer){
        self.setypImagePicker()
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddServicessAdminTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
        imageViewLogo.image = image
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - ImageFunc
extension AddServicessAdminTableViewController{
    func uploadImagee(){
        let imageName = NSUUID().uuidString
        if let imgData = self.imageViewLogo.image?.pngData() {
            guard let name = nameServicessLabel.text, let price = priceServicessLabel.text, let descriptionServ = descriptionServicessLabel.text , name != "", price != "", descriptionServ != "" else {
                print("Form is not valid")
                return
            }
           let storageRef = Storage.storage().reference().child("services_images").child("\(imageName).png")
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
                        let serv = Servicess(title:name,price:price,userId:"userId",order:false,status:false,image: url.absoluteString, dataTimeOrder:"", dateComplitionServ:"", dateApprovedOrders:"", descriptionServ:descriptionServ)
                        if let title = serv.title {
                            let servRef = self?.ref?.child(title.lowercased())
                            servRef?.setValue(serv.convertToDictionary())
                            self!.performSegue(withIdentifier: "back", sender: self)
                        }
                    })
                }
            }
        }
    }
}
