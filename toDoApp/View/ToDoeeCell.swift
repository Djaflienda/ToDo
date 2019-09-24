//
//  ToDoeeCell.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 10/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

import UIKit

class ToDoeeCell: UITableViewCell {

    // MARK: - Properties
    
    let isCheckedButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.clipsToBounds =  true
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
//        label.text = "Sample text"
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addSubview(isCheckedButton)
        isCheckedButton.translatesAutoresizingMaskIntoConstraints = false
        isCheckedButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        isCheckedButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        isCheckedButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        isCheckedButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: isCheckedButton.rightAnchor, constant: 16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers



}
