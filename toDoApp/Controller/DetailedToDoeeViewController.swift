//
//  DetailedToDoeeViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 06/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

import UIKit

protocol DetailedToDoeeViewControllerDelegate: class {
    func addNewToDoee(_: DetailedToDoeeViewController, newItem: ToDoee)
    func addNewToDoee(_: DetailedToDoeeViewController, editedItem: ToDoee)
}

class DetailedToDoeeViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var notificationSwitcher: UISwitch!
    
    var editingItem: ToDoee?
    var editingItemIndex: Int?
    weak var delegate: DetailedToDoeeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New ToDoee Item"
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
        titleTextField.text = editingItem.title
        descriptionTextField.text = editingItem.description
    }
        
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        if editingItem == nil {
            saveNewItem()
        } else {
            saveChangestoTheItem()
        }
    }
    
    //seems that I can combine next two methods into one
    //PAY ATTANTION
    func saveNewItem() {
        guard let title = titleTextField.text, title != "" else {
            titleTextField.borderStyle = .roundedRect
            
            //shake titleTextField and boarder color is red
            return
        }
        guard let description = descriptionTextField.text else {return}
        let newItem =  ToDoee.init(title: title, description: description, checked: false, index: nil)
        delegate?.addNewToDoee(self, newItem: newItem)
        navigationController?.popViewController(animated: true)
    }
    
    func saveChangestoTheItem() {
        guard let title = titleTextField.text, title != "",
                var editingItem = editingItem,
                let editingItemIndex = editingItemIndex else {
                    //also shake
                    return
        }
        guard let description = descriptionTextField.text else {return}
        editingItem.title = title
        editingItem.description = description
        editingItem.index = editingItemIndex
        delegate?.addNewToDoee(self, editedItem: editingItem)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationSwitcherToggle(_ sender: UISwitch) {
        
    }
}

