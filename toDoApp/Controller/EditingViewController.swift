//
//  EditingViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 10/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EditingCell"

class EditingViewController: UIViewController {

    // MARK: - Properties
    
    var tableView: UITableView!
    
    var titleCell: TitleCell!
//    var titleTextField: UITextField!

    var notificationCell: UITableViewCell!
    
    var descriptionCell: UITableViewCell!
//    var descriptionLabel: UILabel!
//    var descriptionTextView: UITextView!
    
    var editingItem: ToDoee?
    weak var delegate: EditingViewControllerDelegate?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureNavigationBar()
    }
    
    deinit {
        print("DEINIT SUCCESSFUL")
    }

    // MARK: - Handlers
    
    func configureTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.rowHeight = 44
        tableView.separatorStyle = .singleLine
    }
    
    func saveNewItem() {
        guard let title = titleCell.titleTextField.text, title != "" else {
            //shake titleTextField and boarder color is red
            return
        }
        let newItem =  ToDoee.init(title: title, description: description, checked: false, index: nil)
        delegate?.addNewToDoee(self, newItem: newItem)
        navigationController?.popViewController(animated: true)
    }
    
    func saveChangestoTheItem() {
        guard let title = titleCell.titleTextField.text, title != "",
            var editingItem = editingItem
            /*let editingItemIndex = editingItemIndex*/ else {
                //also shake
                return
        }
//        guard let description = descriptionTextField.text else {return}
        editingItem.title = title
        editingItem.description = description
        editingItem.index = 0
        delegate?.addNewToDoee(self, editedItem: editingItem)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveChanges() {
        if editingItem == nil {
            saveNewItem()
        } else {
            saveChangestoTheItem()
        }
    }
    
    func configureSaveBarButton() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveChanges))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func configureNavigationBarTitle() {
        if let editingItem = editingItem {
            title = editingItem.title
        } else {
            title = "Create new item"
        }
    }
    
    func configureNavigationBar() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        configureNavigationBarTitle()
        configureSaveBarButton()
    }
}

// MARK: - Table view data source
extension EditingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 1
        default: fatalError("Unknown number of sections")
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            titleCell = TitleCell()
            if let editingItem = editingItem {
                titleCell.titleTextField.text = editingItem.title
            }
            return titleCell
        case 1:
            notificationCell = UITableViewCell()
            return notificationCell
        case 2:
            descriptionCell = UITableViewCell()
            return descriptionCell
        default:
            fatalError("Unknown number of sections")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}
