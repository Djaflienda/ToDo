//
//  TableViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 09/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func addNewToDoee(_: ItemDetailViewController, newItem: ToDoee)
    func addNewToDoee(_: ItemDetailViewController, editedItem: ToDoee)
}

class ItemDetailViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    
    var editingItem: ToDoee?
    weak var delegate: ItemDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        descriptionField.delegate = self
        
        configureInitialView()
    }
    
    func configureInitialView() {
        if let editingItem = editingItem {
            title = editingItem.title
            navigationItem.rightBarButtonItem?.title = "Save"
            titleTextField.text = editingItem.title
            descriptionField.text = editingItem.description
        } else {
            title = "Add new Item"
            navigationItem.rightBarButtonItem?.title = "Add"
            titleTextField.placeholder = "Enter new ToDoee Title"
        }
    }
        
    //keyBoard toolBar with done button to resignFirstResponder from textView
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(textViewDidEndEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        descriptionField.inputAccessoryView = keyboardToolbar
    }
    
    @IBAction func submitChanges(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text,
            let description = descriptionField.text else {return}
        if editingItem == nil, let toDoee = ToDoee(title: title, description: description, checked: false, index: 0) {
            delegate?.addNewToDoee(self, newItem: toDoee)
        }
        if var editingItem = editingItem {
            editingItem.title = title
            editingItem.description  = description
            delegate?.addNewToDoee(self, editedItem: editingItem)
        }
        navigationController?.popViewController(animated: true)
    }
}

//MARK: TableViewDelegate Methods
extension ItemDetailViewController {
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

//MARK: TextField/TextViewDelegate Methods
//to resignFirstResponder from TextView to hide keyboard toolbar
//toolbar is needed to hide keyboard while 'return' button provide a new line movement
extension ItemDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        titleTextField.resignFirstResponder()
    }
}
    
extension ItemDetailViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        setDoneOnKeyboard()
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        descriptionField.resignFirstResponder()
    }
}
