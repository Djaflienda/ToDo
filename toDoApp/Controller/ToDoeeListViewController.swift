//
//  ViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 08/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import UIKit

protocol ToDoeeListViewControllerDelegate: class {
    func increaseToDoeeAmountByOne(_: ToDoeeListViewController)
    func decreaseToDoeeAmountByOne(_: ToDoeeListViewController)
}

class ToDoeeListViewController: UITableViewController {
    
//    @IBOutlet weak var deleteRowsButton: UIBarButtonItem!
    
    var toDoees = ToDoeesModel()
    var categoryTitle: String!
    
    weak var delegate: ToDoeeListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryTitle
        
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
            var items = [ToDoee]()
            for indexPath in selectedRows {
                items.append(toDoees.toDoeesArray[indexPath.row])
            }
            toDoees.remove(items: items)
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
        
        //HERE DELETE DELEGATE
        delegate?.decreaseToDoeeAmountByOne(self)
        
        toDoees.saveAtFile(name: categoryTitle, element: toDoees.toDoeesArray)
    }

    @IBAction
    func createNewToDoeeButtonPressed(_ sender: UIBarButtonItem) {
        let detailedToDoeeViewController = self.storyboard?.instantiateViewController(withIdentifier: "ToDoeeDetailed") as! ItemDetailViewController
        detailedToDoeeViewController.delegate = self
        self.navigationController?.pushViewController(detailedToDoeeViewController, animated: true)
    }
    
    func loadToDoeeItems() {
        //HOW TO INCAPSULATE IT INSIDE MODEL??
//        guard let urlToLoad = dataFilePath() else {return}
        guard let categoryTitle = categoryTitle else {return}
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(categoryTitle).plist")
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            
            do {
                toDoees.toDoeesArray = try decoder.decode([ToDoee].self, from: data)
            } catch {
                print("Error decoding item array")
            }
        }
    }
}

// MARK: TableViewDataSource and Delegate Methods
extension ToDoeeListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoees.toDoeesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ToDoeeTableViewCell
        cell.titleLabel.text = toDoees.toDoeesArray[indexPath.row].title
        if toDoees.toDoeesArray[indexPath.row].checked {
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
        toDoees.toDoeesArray[indexPath.row].toggleState()
        tableView.reloadData()
        toDoees.saveAtFile(name: categoryTitle, element: toDoees.toDoeesArray)
    }
    
    //provide an ability to 'swipe to delete'
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        toDoees.toDoeesArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        toDoees.saveAtFile(name: categoryTitle, element: toDoees.toDoeesArray)
    }
    
    //during editingMode provide an ability to move rows. A 'move' indicator is also shown on the right hand side
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        toDoees.move(item: toDoees.toDoeesArray[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let detailedToDoeeViewController = storyboard?.instantiateViewController(withIdentifier: "ToDoeeDetailed") as! ItemDetailViewController
        detailedToDoeeViewController.delegate = self
        detailedToDoeeViewController.editingItem = toDoees.toDoeesArray[indexPath.row]
        detailedToDoeeViewController.editingItem?.index = indexPath.row
        navigationController?.pushViewController(detailedToDoeeViewController, animated: true)
    }
}

// MARK: ItemDetailViewControllerDelegate Methods
//using to create or edit ToDoee item through the ItemDetailViewController
extension ToDoeeListViewController: ItemDetailViewControllerDelegate {
    func addNewToDoee(_: ItemDetailViewController, newItem: ToDoee) {
        //during a new ToDoee item creation I can set a different 'index' property
        //so that I can insert new item at 'index' position
        guard let index = newItem.index else {return}
        //assign ToDoee item 'index' property to nil is NOT neccessary
        //it uses to store the 'index' while editing to place edited item back in place
        //it replaces with new value every time we decide to edit an item
        toDoees.toDoeesArray.insert(newItem, at: index)
        toDoees.toDoeesArray[index].index = nil
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        delegate?.increaseToDoeeAmountByOne(self)
        toDoees.saveAtFile(name: categoryTitle, element: toDoees.toDoeesArray)
    }
    
    func addNewToDoee(_: ItemDetailViewController, editedItem: ToDoee) {
        toDoees.toDoeesArray[editedItem.index!] = editedItem
        toDoees.toDoeesArray[editedItem.index!].index = nil
        tableView.reloadData()
        toDoees.saveAtFile(name: categoryTitle, element: toDoees.toDoeesArray)
    }
}
