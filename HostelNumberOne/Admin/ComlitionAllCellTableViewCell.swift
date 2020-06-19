import UIKit
class ComlitionAllCellTableViewCell: UITableViewCell {
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passportLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var imageViewLabel: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func configureProfile( with profile: userAndAdmin){
        self.fullNameLabel.text = profile.fullName
        self.emailLabel.text = profile.email
        self.telephoneLabel.text = profile.phoneNumber
        self.userIdLabel.text = profile.userId
    }
    func configureRooms( with rooms: Rooms ){
        self.priceLabel.text = rooms.price! + " руб."
        self.statusLabel.text = "\(rooms.dateArrival!)-\(rooms.dateDeparture!)"
        self.imageViewLabel.contentMode = .scaleAspectFill
        self.imageViewLabel.layer.cornerRadius = 20
        self.imageViewLabel.clipsToBounds = true
        if let imageLogo = rooms.image{
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
    func configureService( with service: Servicess ){
        self.titleLabel.text = service.title!
        self.priceLabel.text = service.price! + " руб."
        self.statusLabel.text = service.dateComplitionServ
        self.imageViewLabel.contentMode = .scaleAspectFill
        self.imageViewLabel.layer.cornerRadius = 20
        self.imageViewLabel.clipsToBounds = true
        if let imageLogo = service.image{
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
    
}
