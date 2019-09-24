//
//  RootViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 10/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ToDoeeCell"

class RootViewController: UIViewController {
    
    // MARK: - Properties
    
    var dataModel: DataModel!
//    var selectedCategoryIndex: Int!
    weak var delegate: RootViewControllerDelegate?
    var tableView: UITableView!
    var addButton: UIButton!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar()
        configureTableView()
        configureSupportingElements()
        
        print(dataModel)
        print("-=======-")
        
    }
    
    // MARK: - Handlers
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ToDoeeCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .singleLine
        
        
    }
    
    func configureSupportingElements() {
        addButton = UIButton(frame: CGRect(x: view.frame.width - 100, y: view.frame.height - 100, width: 65, height: 65))
        addButton.addTarget(self, action: #selector(showEditingViewController), for: .touchUpInside)
        addButton.setImage(UIImage(named: "addButtonNormal"), for: .normal)
        addButton.layer.cornerRadius = 25
        view.addSubview(addButton)
    }
    
    @objc func showEditingViewController() {
        let editingViewController = EditingViewController()
        editingViewController.delegate = self
        navigationController?.pushViewController(editingViewController, animated: true)
    }
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle()
    }
 
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .lightGray
        navigationController?.navigationBar.barStyle = .default
        navigationItem.title = dataModel.listOfCategories[dataModel.indexOfSelectedToDoeeList].title
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menuIcon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.listOfCategories[dataModel.indexOfSelectedToDoeeList].toDoeeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ToDoeeCell
        
        cell.descriptionLabel.text = dataModel.listOfCategories[dataModel.indexOfSelectedToDoeeList].toDoeeItems[indexPath.row].title
        if dataModel.listOfCategories[dataModel.indexOfSelectedToDoeeList].toDoeeItems[indexPath.row].checked {
            cell.isCheckedButton.setImage(UIImage(named: "checked"), for: .normal)
            
            cell.descriptionLabel.textColor = UIColor.lightGray
            
        } else {
            cell.isCheckedButton.setImage(UIImage(named: "unchecked"), for: .normal)
            cell.descriptionLabel.textColor = UIColor.black
            
        }
        cell.accessoryType = .detailButton
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let editingViewController = EditingViewController()
        editingViewController.delegate = self
        let categoryIndex = dataModel.indexOfSelectedToDoeeList
        editingViewController.editingItem = dataModel.listOfCategories[categoryIndex].toDoeeItems[indexPath.row]
        navigationController?.pushViewController(editingViewController, animated: true)
    }
    
    
}

extension RootViewController: EditingViewControllerDelegate {
    func addNewToDoee(_: EditingViewController, newItem: ToDoee) {
        dataModel.listOfCategories[dataModel.indexOfSelectedToDoeeList].toDoeeItems.insert(newItem, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func addNewToDoee(_: EditingViewController, editedItem: ToDoee) {
        guard let index = editedItem.index else {return}
        dataModel.listOfCategories[dataModel.indexOfSelectedToDoeeList].toDoeeItems[index] = editedItem
        self.tableView.reloadData()
    }
}
