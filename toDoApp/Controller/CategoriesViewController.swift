//
//  CategoriesViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 20/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController {
    
    var dataModel: DataModel!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "List of Categories"
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.rightBarButtonItems?.append(editButtonItem)
        tableView.allowsMultipleSelectionDuringEditing = true
        
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedToDoeeList
        if index >= 0 && index < dataModel.listOfCategories.count {
            configureSegueForRow(at: index)
        }
    }
    
    //Apple Documentation tells not to use this method with tableView commit editingStyle
    //Do not know how to fix it right now
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
        
        if editing {
            let deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteRows))
            deleteBarButton.tintColor = UIColor.red
            
            self.navigationItem.rightBarButtonItems?.insert(deleteBarButton, at: 1)
            //I dont like this line - should change
            self.navigationItem.rightBarButtonItems?[0].isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItems?.remove(at: 1)
            //The same here
            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
        }
    }
    
    @objc
    func deleteRows() {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            var items = [Category]()
            for indexPath in selectedRows {
                items.append(dataModel.listOfCategories[indexPath.row])
            }
            dataModel.remove(items: items)
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    @IBAction func createNewCategoryButtonPressed(_ sender: UIBarButtonItem) {
        configureSegueToDetailedCategoryFromRow(at: nil)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        configureSegueToDetailedCategoryFromRow(at: indexPath.row)
    }
    
    func configureSegueToDetailedCategoryFromRow(at index: Int?) {
        let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailedCategoryViewController") as! DetailedCategoryViewController
        destinationViewController.delegate = self
        if let index = index {
            destinationViewController.editingItemIndex = index
            destinationViewController.editingItem = dataModel.listOfCategories[index]
            destinationViewController.iconName = dataModel.listOfCategories[index].iconName
        }
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

// MARK: - tableView Data Source Methods
extension CategoriesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.listOfCategories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        cell.accessoryType = .detailDisclosureButton
        cell.categoryTitle.text = dataModel.listOfCategories[indexPath.row].title
        cell.categoryDetail.text = configureDescriptionStringForCategory(at: indexPath.row)
        cell.iconImage.image = UIImage(named: dataModel.listOfCategories[indexPath.row].iconName)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {return}
        dataModel.indexOfSelectedToDoeeList = indexPath.row
        configureSegueForRow(at: indexPath.row)
    }
    
    func configureSegueForRow(at index: Int) {
        let listViewController = storyboard?.instantiateViewController(withIdentifier: "ToDoeeList") as! ToDoeeListViewController
        listViewController.dataModel = dataModel
        listViewController.categoryIndex = index
        self.navigationController?.pushViewController(listViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.deleteFileWith(name: dataModel.listOfCategories[indexPath.row].title)
        dataModel.listOfCategories.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataModel.move(item: dataModel.listOfCategories[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }
}

extension CategoriesViewController: DetailedCategoryViewControllerDelegate {
    func addNewToDoee(_: DetailedCategoryViewController, newItem: Category)  {
        dataModel.listOfCategories.insert(newItem, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func addNewToDoee(_: DetailedCategoryViewController, editedItem: Category) {
        guard let index = editedItem.index else {return}
        dataModel.listOfCategories[index] = editedItem
        self.tableView.reloadData()
    }
}

extension CategoriesViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedToDoeeList = -1
        }
    }
}


