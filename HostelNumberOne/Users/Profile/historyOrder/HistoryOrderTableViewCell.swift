//
//  HistoryOrderTableViewCell.swift
//  HostelNumberOne
//
//  Created by Кирилл on 28.04.2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit

class HistoryOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
