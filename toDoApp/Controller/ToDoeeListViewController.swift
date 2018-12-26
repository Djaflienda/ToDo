//
//  ViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 08/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import UIKit

class ToDoeeListViewController: UITableViewController {
    
    @IBOutlet weak var deleteRowsButton: UIBarButtonItem!
    
    var toDoees = ToDoeesModel()
    
    //DO I REALLY NEED THIS INIT? REMOVE IT LATER!!!
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        print("Data file path is \(dataFilePath())")
//        print("Documents folder is \(documentsDirectory())")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My ToDoee"
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
//        toDoees.fillArrayWithDefaultData()
        loadToDoeeItems()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
        deleteRowsButton.isEnabled = !deleteRowsButton.isEnabled
    }
    
    //figure out how to perform transition without Storyboard segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "disclosureSegue" {
            let detailedToDoeeViewController = segue.destination as! ItemDetailViewController
            detailedToDoeeViewController.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                detailedToDoeeViewController.editingItem = toDoees.toDoeesArray[indexPath.row]
                detailedToDoeeViewController.editingItem?.index = indexPath.row
            }
        }
    }

    @IBAction func createNewToDoeeButtonPressed(_ sender: UIBarButtonItem) {
        let detailedToDoeeViewController = self.storyboard?.instantiateViewController(withIdentifier: "ToDoeeDetailed") as! ItemDetailViewController
        detailedToDoeeViewController.delegate = self
        self.navigationController?.pushViewController(detailedToDoeeViewController, animated: true)
    }
    
    @IBAction func deleteRows(_ sender: UIBarButtonItem) {
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
        saveToDoeeItems()
    }
    
    //Saving data using FileManager
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("ToDoeeList.plist")
    }
    
    func saveToDoeeItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(toDoees.toDoeesArray)
            
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error encoding otem array")
        }
    }
    
    func loadToDoeeItems() {
        if let data = try? Data(contentsOf: dataFilePath()) {
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
    
    //next TWO methods configure a tableView
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
        saveToDoeeItems()
    }
    
    //provide an ability to 'swipe to delete'
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        toDoees.toDoeesArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveToDoeeItems()
    }
    
    //during editingMode provide an ability to move rows. A 'move' indicator is also shown on the right hand side
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        toDoees.move(item: toDoees.toDoeesArray[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
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
        saveToDoeeItems()
    }
    
    func addNewToDoee(_: ItemDetailViewController, editedItem: ToDoee) {
        toDoees.toDoeesArray[editedItem.index!] = editedItem
        toDoees.toDoeesArray[editedItem.index!].index = nil
        tableView.reloadData()
        saveToDoeeItems()
    }
}
