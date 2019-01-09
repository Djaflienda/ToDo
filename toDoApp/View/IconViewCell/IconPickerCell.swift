//
//  IconPickerCell.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 08/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

import UIKit

class IconPickerCell: UITableViewCell {

    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
