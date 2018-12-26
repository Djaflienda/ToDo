//
//  ToDoeeTableViewCell.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 18/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import UIKit

class ToDoeeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkMarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
