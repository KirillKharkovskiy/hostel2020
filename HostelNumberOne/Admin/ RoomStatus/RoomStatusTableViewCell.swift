//
//  RoomStatusTableViewCell.swift
//  HostelNumberOne
//
//  Created by Кирилл on 17.04.2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

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

}
