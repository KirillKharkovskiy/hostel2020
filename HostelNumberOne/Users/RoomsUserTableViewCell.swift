import UIKit
class RoomsUserTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with roms: Rooms){
        self.accessoryType = .disclosureIndicator
        self.imageViewLabel.contentMode = .scaleAspectFill
        self.imageViewLabel.layer.cornerRadius = 20
        self.imageViewLabel.layer.borderWidth = 1
        self.imageViewLabel.layer.borderColor = #colorLiteral(red: 0.9196520798, green: 0.4756047404, blue: 1, alpha: 0.4773651541)
        self.imageViewLabel.clipsToBounds = true
        self.titleLabel.text = roms.title
        self.priceLabel.text = roms.price! + " руб"
        if let imageLogo = roms.image{
            let url = URL(string: imageLogo)!
            URLSession.shared.dataTask(with: url){ ( data, response, error ) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    self.imageViewLabel.image = UIImage(data: data!)
                }
            }.resume()
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
