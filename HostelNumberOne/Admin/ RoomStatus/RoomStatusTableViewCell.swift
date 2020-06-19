import UIKit

class RoomStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var dateDepartureLabel: UILabel!
    @IBOutlet weak var imageViewLabel: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func configure( with roms: Rooms ){
        self.titileLabel.text = roms.title
         self.arrivalDateLabel.text = " Дата заезда: " + roms.dateArrival!
         self.dateDepartureLabel.text = " Дата выезда: " + roms.dateDeparture!
         self.imageViewLabel.contentMode = .scaleAspectFill
         self.imageViewLabel.layer.cornerRadius = 20
         self.imageViewLabel.clipsToBounds = true
         if let imageLogo = roms.image{
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
