//
//  DeviceCell.swift
//  TrackerMonitor
//
//  Created by Dmitry on 19.01.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var countTitleLabel: UILabel!
    @IBOutlet var timeTitleLabel: UILabel!
    @IBOutlet var amounTitletLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
