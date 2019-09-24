//
//  MenuViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 10/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MenuOptionCell"

class MenuViewController: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var numberOfStaticMenuOptions = 4
    var dataModel: DataModel!
    weak var delegate: RootViewControllerDelegate?
    var addButton: UIButton!

    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureSupportingElements()
    }
    
    // MARK: - Handlers
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .blue
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        tableView.separatorStyle = .none
        
    }
    
    func configureSupportingElements() {
        addButton = UIButton(frame: CGRect(x: view.frame.width - 65 - 80, y: view.frame.height - 100, width: 65, height: 65))
        addButton.addTarget(self, action: #selector(createNewCategory), for: .touchUpInside)
        addButton.setImage(UIImage(named: "addButtonNormal"), for: .normal)
        addButton.layer.cornerRadius = 25
        view.addSubview(addButton)
    }
    
    @objc func createNewCategory() {
        let newItem =  Category.init(title: "New category", iconName: "face", index: nil, description: nil, toDoeeItems: [])
        dataModel.listOfCategories.insert(newItem, at: 0)
        let indexPath = IndexPath(row: 4, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfStaticMenuOptions + dataModel.listOfCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        
        if indexPath.row >= 0 && indexPath.row < numberOfStaticMenuOptions {
            let menuOption = MenuOption(rawValue: indexPath.row)
            cell.descriptionLabel.text = menuOption?.description
            cell.iconImageView.image = menuOption?.image
        } else {
            let source = dataModel.listOfCategories[indexPath.row - numberOfStaticMenuOptions]
            cell.descriptionLabel.text = source.title + configureDescriptionStringForCategory(at: indexPath.row - numberOfStaticMenuOptions)
            cell.iconImageView.image = UIImage(named: source.iconName)
            cell.accessoryType = .detailButton
        }
        return cell
    }
    
    func configureDescriptionStringForCategory(at index: Int) -> String {
        let allItems = dataModel.listOfCategories[index].toDoeeItems.count
        let uncheckedItems = dataModel.listOfCategories[index].countUncheckedItems()
        if allItems == 0 {
            return "(No items yet)"
        } else if allItems > 0 && uncheckedItems == 0 {
            return "All Done!"
        }
        return "\(allItems - uncheckedItems) of \(allItems) Done"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        dataModel.indexOfSelectedToDoeeList = indexPath.row
        delegate?.handleMenuToggle()

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= 0 && indexPath.row < numberOfStaticMenuOptions {
            return 80
        } else {
            return 44
        }
    }
}

extension MenuViewController: MenuViewControllerDelegate {
    func updateTableView() {
        tableView.reloadData()
    }
}
