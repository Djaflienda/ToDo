//
//  TitleCell.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 10/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter new item title here"
        textField.contentMode = .scaleAspectFit
        textField.clipsToBounds =  true
        return textField
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers

}
