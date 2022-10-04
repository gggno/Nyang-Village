//
//  SettingTableViewCell.swift
//  Nyang Village
//
//  Created by 정근호 on 2022/09/18.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var settingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
