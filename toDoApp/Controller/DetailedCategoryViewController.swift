//
//  DetailedCategoryViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 06/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

import UIKit

protocol DetailedCategoryViewControllerDelegate: class {
    func addNewToDoee(_: DetailedCategoryViewController, newItem: Category)
    func addNewToDoee(_: DetailedCategoryViewController, editedItem: Category)
}

class DetailedCategoryViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    var editingItem: Category?
    var editingItemIndex: Int?
    weak var delegate: DetailedCategoryViewControllerDelegate?
    
    let titleForSectionHeader = ["Category Title", "Description"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New Category Item"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        if editingItem != nil {
            configureInitialViewWhenEditing()
        }
        
    }
    
    func configureInitialViewWhenEditing() {
        guard let editingItem = editingItem else {return}
        self.title = editingItem.title
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return editingItem == nil ? 1 : 2
//    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForSectionHeader[section]
    }
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        if editingItem == nil {
            saveNewItem()
        } else {
            saveChangestoTheItem()
        }
    }
    
    func saveNewItem() {
        guard let title = titleTextField.text else  {return}
        let newItem =  Category.init(title: title, index: editingItemIndex, description: nil, toDoeeItems: [])
        delegate?.addNewToDoee(self, newItem: newItem)
        navigationController?.popViewController(animated: true)
    }
    
    func saveChangestoTheItem() {
        guard let title = titleTextField.text,
            var editingItem = editingItem,
            let editingItemIndex = editingItemIndex else {return}
        editingItem.title = title
        editingItem.index = editingItemIndex
        delegate?.addNewToDoee(self, editedItem: editingItem)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
