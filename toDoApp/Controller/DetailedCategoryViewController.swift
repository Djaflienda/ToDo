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
    @IBOutlet weak var iconImageView: UIImageView!
    
    var editingItem: Category?
    var editingItemIndex: Int?
    var iconName = "default"

    weak var delegate: DetailedCategoryViewControllerDelegate?
    
//    let titleForSectionHeader = ["Category Title", "Description"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New Category Item"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        if editingItem != nil {
            configureInitialViewWhenEditing()
        } else {
            configureInitialView()
        }
    }
    
    func configureInitialView() {
        iconImageView.image = UIImage(named: iconName)
    }
    
    func configureInitialViewWhenEditing() {
        guard let editingItem = editingItem else {return}
        self.title = editingItem.title
        titleTextField.text = editingItem.title
        iconImageView.image = UIImage(named: editingItem.iconName)
    }
    
    //I do not actually need this method as soon as I set titles in storyboard
    //Useful if I would like to change section title dynamicly
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return titleForSectionHeader[section]
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //As soon as I have only one row in section I do not need to check for row index
        if indexPath.section == 1 {
            let destinationViewController = storyboard?.instantiateViewController(withIdentifier: "IconPickerViewController") as! IconPickerViewController
            destinationViewController.delegate = self
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        if editingItem == nil {
            saveNewItem()
        } else {
            saveChangestoTheItem()
        }
    }
    
    //Can I do something instead of guard in the next two methods???
    //PAY ATTANTION
    func saveNewItem() {
        guard let title = titleTextField.text, title != "" else  {return}
        let newItem =  Category.init(title: title, iconName: iconName, index: editingItemIndex, description: nil, toDoeeItems: [])
        delegate?.addNewToDoee(self, newItem: newItem)
        navigationController?.popViewController(animated: true)
    }
    
    func saveChangestoTheItem() {
        guard let title = titleTextField.text, title != "",
            var editingItem = editingItem,
            let editingItemIndex = editingItemIndex else {return}
        editingItem.title = title
        editingItem.index = editingItemIndex
        editingItem.iconName = iconName
        delegate?.addNewToDoee(self, editedItem: editingItem)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailedCategoryViewController: IconPickerViewControllerDelegate {
    func changecategoryItem(_: IconPickerViewController, iconName: String) {
        self.iconName = iconName
        self.iconImageView.image = UIImage(named: iconName)
    }
}
