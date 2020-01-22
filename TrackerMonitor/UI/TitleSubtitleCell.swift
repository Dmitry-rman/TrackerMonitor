//
//  TitleSubtitleCell.swift
//
//  Created by Dmitry Kudryavtsev on 03/10/2018.
//

import UIKit
 
class TitleSubtitleCell: UITableViewCell, ConfigurableCell {
    
    typealias CellData = (title: String, subtitle: String, accessoryType: UITableViewCell.AccessoryType)
    
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var subtitleLabel: UILabel?
    
    func configure(with info: CellData) {
        titleLabel?.text = info.title
        subtitleLabel?.text = info.subtitle
        self.accessoryType = info.accessoryType
    }
    
    static var estimatedHeight: CGFloat? {
        return 44
    }

}
