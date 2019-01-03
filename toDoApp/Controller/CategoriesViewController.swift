//
//  CategoriesViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 20/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController {
    
    var categories = CategoriesList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List of Categories"
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.rightBarButtonItems?.append(editButtonItem)
        tableView.allowsMultipleSelectionDuringEditing = true
        
        loadToDoeeItems()
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
                items.append(categories.categoriesArray[indexPath.row])
            }
            categories.remove(items: items)
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
        categories.saveAtFile(element: categories.categoriesArray)
    }
    
    func loadToDoeeItems() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Categories.plist")
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                categories.categoriesArray = try decoder.decode([Category].self, from: data)
            } catch {
                print("Error decoding item array")
            }
        }
    }
    
    @IBAction func createNewCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        //assign random generated name for any categories that user created
        //so user can create a categories with same titles
        //FIX
        
        let alert = UIAlertController(title: "Create new category", message: "Enter new category title", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new category title"
        }
        let action = UIAlertAction(title: "Create", style: .cancel, handler: { (action) in
            guard let textFields = alert.textFields, let text = textFields[0].text, text != "" else {return}
            let newCategory = Category.init(title: text)
            self.categories.categoriesArray.insert(newCategory, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            print(self.categories.categoriesArray.count)
            self.categories.saveAtFile(element: self.categories.categoriesArray)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - tableViewDataSource Methods
extension CategoriesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.categoriesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text = categories.categoriesArray[indexPath.row].title
        cell.detailTextLabel?.text = "\(categories.totalToDoeeAmount) ToDoees in this list"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            return
        }
        let listViewController = storyboard?.instantiateViewController(withIdentifier: "ToDoeeList") as! ToDoeeListViewController
        listViewController.categoryTitle = categories.categoriesArray[indexPath.row].title
        listViewController.delegate = self
        self.navigationController?.pushViewController(listViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        categories.deleteFileWith(name: categories.categoriesArray[indexPath.row].title)
        categories.categoriesArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        categories.saveAtFile(element: self.categories.categoriesArray)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        categories.move(item: categories.categoriesArray[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let categoryDetailedViewController = storyboard?.instantiateViewController(withIdentifier: "CategoryDetailViewController") as! CategoryDetailTableViewController
        navigationController?.pushViewController(categoryDetailedViewController, animated: true)
    }
}

extension CategoriesViewController: ToDoeeListViewControllerDelegate {
    func increaseToDoeeAmountByOne(_: ToDoeeListViewController) {
        categories.totalToDoeeAmount += 1
        tableView.reloadData()
    }
    
    func decreaseToDoeeAmountByOne(_: ToDoeeListViewController) {
        categories.totalToDoeeAmount -= 1
        tableView.reloadData()
    }
}


