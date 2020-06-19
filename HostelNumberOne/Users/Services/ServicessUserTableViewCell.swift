import UIKit

class ServicessUserTableViewCell: UITableViewCell {
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var priceTextLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure( with service: Servicess ){
        self.titleTextLabel.text = service.title
        self.priceTextLabel.text =  service.price! + " руб"
        self.accessoryType = .disclosureIndicator
        self.imageLabel.contentMode = .scaleAspectFill
        self.imageLabel.layer.cornerRadius = 20
        self.imageLabel.clipsToBounds = true
        if let imageLogo = service.image{
            let url = URL(string: imageLogo)!
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    self.imageLabel?.image = UIImage(data: data!)
                }
            }.resume()
        }
    }

}
