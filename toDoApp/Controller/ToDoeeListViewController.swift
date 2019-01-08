//
//  ViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 08/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import UIKit

protocol ToDoeeListViewControllerDelegate: class {
    func updateCategoryViewControllerData(_: ToDoeeListViewController)
}

class ToDoeeListViewController: UITableViewController {
        
    var categoryTitle: String!
    var categoryIndex: Int!

    var dataModel: DataModel!
    weak var delegate: ToDoeeListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryTitle
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.rightBarButtonItems?.append(editButtonItem)
        tableView.allowsMultipleSelectionDuringEditing = true
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
            var items = [ToDoee]()
            for indexPath in selectedRows {
                items.append(dataModel.listOfCategories[categoryIndex].toDoeeItems[indexPath.row])
            }
            dataModel.listOfCategories[categoryIndex].remove(items: items)
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
        delegate?.updateCategoryViewControllerData(self)
    }

    @IBAction
    func createNewToDoeeButtonPressed(_ sender: UIBarButtonItem) {
        let destinationViewController = storyboard?.instantiateViewController(withIdentifier: "DetailedToDoeeViewController") as! DetailedToDoeeViewController
        destinationViewController.delegate = self
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

// MARK: TableViewDataSource and Delegate Methods
extension ToDoeeListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.listOfCategories[categoryIndex].toDoeeItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ToDoeeTableViewCell

        cell.titleLabel.text = dataModel.listOfCategories[categoryIndex].toDoeeItems[indexPath.row].title
        if dataModel.listOfCategories[categoryIndex].toDoeeItems[indexPath.row].checked {
            cell.checkMarkButton.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            cell.checkMarkButton.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        return cell
    }
    
    //configure a behavior when touching a tableView cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        dataModel.listOfCategories[categoryIndex].toDoeeItems[indexPath.row].toggleState()
        tableView.reloadData()
    }
    
    //provide an ability to 'swipe to delete'
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.listOfCategories[categoryIndex].toDoeeItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        delegate?.updateCategoryViewControllerData(self)
    }
    
    //during editingMode provide an ability to move rows. A 'move' indicator is also shown on the right hand side
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataModel.listOfCategories[categoryIndex].move(item:dataModel.listOfCategories[categoryIndex].toDoeeItems[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let destinationViewController = storyboard?.instantiateViewController(withIdentifier: "DetailedToDoeeViewController") as! DetailedToDoeeViewController
        destinationViewController.editingItem = dataModel.listOfCategories[categoryIndex].toDoeeItems[indexPath.row]
        destinationViewController.editingItemIndex = indexPath.row
        destinationViewController.delegate = self
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

extension ToDoeeListViewController: DetailedToDoeeViewControllerDelegate {
    func addNewToDoee(_: DetailedToDoeeViewController, newItem: ToDoee) {
        dataModel.listOfCategories[categoryIndex].toDoeeItems.insert(newItem, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        delegate?.updateCategoryViewControllerData(self)
    }
    
    func addNewToDoee(_: DetailedToDoeeViewController, editedItem: ToDoee) {
        guard let index = editedItem.index else {return}
        dataModel.listOfCategories[categoryIndex].toDoeeItems[index] = editedItem
        self.tableView.reloadData()
    }
}
