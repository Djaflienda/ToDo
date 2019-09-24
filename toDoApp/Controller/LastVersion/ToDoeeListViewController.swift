//
//  ViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 08/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import UIKit

class ToDoeeListViewController: UITableViewController {
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    
    var categoryIndex: Int!
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = dataModel.listOfCategories[categoryIndex].title
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.rightBarButtonItems?.append(editButtonItem)
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
        deleteBarButton.isEnabled = editing ? true : false
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
    }

    @IBAction
    func createNewToDoeeButtonPressed(_ sender: UIBarButtonItem) {
        configureSegueToDetailedToDoeeFromRow(at: nil)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        configureSegueToDetailedToDoeeFromRow(at: indexPath.row)
    }
    
    func configureSegueToDetailedToDoeeFromRow(at index: Int?) {
        let destinationViewController = storyboard?.instantiateViewController(withIdentifier: "DetailedToDoeeViewController") as! DetailedToDoeeViewController
        destinationViewController.delegate = self
        if let index = index {
            destinationViewController.editingItem = dataModel.listOfCategories[categoryIndex].toDoeeItems[index]
            destinationViewController.editingItemIndex = index
        }
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.listOfCategories[categoryIndex].toDoeeItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ToDoeeTableViewCell
        cell.titleLabel.text = dataModel.listOfCategories[categoryIndex].toDoeeItems[indexPath.row].title
        if dataModel.listOfCategories[categoryIndex].toDoeeItems[indexPath.row].checked {
            cell.checkMarkButton.setImage(UIImage(named: "checked"), for: .normal)
            
            cell.titleLabel.textColor = UIColor.lightGray
            
        } else {
            cell.checkMarkButton.setImage(UIImage(named: "unchecked"), for: .normal)
            cell.titleLabel.textColor = UIColor.black

        }
        return cell
    }
    
    //configure a behavior when touching a tableView cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {return}
        tableView.deselectRow(at: indexPath, animated: true)
        dataModel.listOfCategories[categoryIndex].toDoeeItems[indexPath.row].toggleState()
        //next block move checked item to the bottom of the table view
        //and move it back to position 0 if item is unchecked
        let toDoeeItems = dataModel.listOfCategories[categoryIndex].toDoeeItems
        switch toDoeeItems[indexPath.row].checked {
        case true:
            let lastArrayPosition = toDoeeItems.count
            dataModel.listOfCategories[categoryIndex].move(item: toDoeeItems[indexPath.row], to: lastArrayPosition - 1)
        case false:
            dataModel.listOfCategories[categoryIndex].move(item: toDoeeItems[indexPath.row], to: 0)
        }
        
        tableView.reloadData()
    }
    
    //provide an ability to 'swipe to delete'
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.listOfCategories[categoryIndex].toDoeeItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    //during editingMode provide an ability to move rows. A 'move' indicator is also shown on the right hand side
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    dataModel.listOfCategories[categoryIndex].move(item:dataModel.listOfCategories[categoryIndex].toDoeeItems[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }
}

extension ToDoeeListViewController: DetailedToDoeeViewControllerDelegate {
    func addNewToDoee(_: DetailedToDoeeViewController, newItem: ToDoee) {
        dataModel.listOfCategories[categoryIndex].toDoeeItems.insert(newItem, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func addNewToDoee(_: DetailedToDoeeViewController, editedItem: ToDoee) {
        guard let index = editedItem.index else {return}
        dataModel.listOfCategories[categoryIndex].toDoeeItems[index] = editedItem
        self.tableView.reloadData()
    }
}
