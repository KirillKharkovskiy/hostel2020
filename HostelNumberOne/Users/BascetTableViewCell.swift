import UIKit

class BascetTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configureRooms ( with rooms: Rooms ) {
        self.titleLabel.text = rooms.title
        self.priceLabel.text = rooms.price! + " руб"
        self.imageLogo.contentMode = .scaleAspectFill
        self.imageLogo.layer.cornerRadius = 20
        self.imageLogo.clipsToBounds = true
        if let imageLogo = rooms.image{
            let url = URL(string: imageLogo)!
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    self.imageLogo?.image = UIImage(data: data!)
                }
            }.resume()
        }
    }
    func configureService ( with service: Servicess ){
        self.titleLabel.text = service.title
        self.priceLabel.text = service.price! + " руб"
        self.imageLogo.contentMode = .scaleAspectFill
        self.imageLogo.layer.cornerRadius = 20
        self.imageLogo.clipsToBounds = true
        
        if let imageLogo = service.image{
            let url = URL(string: imageLogo)!
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    self.imageLogo?.image = UIImage(data: data!)
                }
            }.resume()
        }
    }

}
