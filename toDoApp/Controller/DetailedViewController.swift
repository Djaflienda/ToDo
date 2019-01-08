//
//  DetailedViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 04/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

import UIKit

enum TypesOfChangesToPerform: String {
    case createCategory = "Create new Category"
    case createToDoee = "Create new ToDoee"
    case editCategory = "Edit Category"
    case editToDoee = "Edit ToDoee"
}

protocol DetailedViewControllerDelegate: class {
    func addNewToDoee(_: DetailedCategoryViewController, newItem: ToDoee)
    func addNewToDoee(_: DetailedCategoryViewController, editedItem: ToDoee)
    func addNewToDoee(_: DetailedCategoryViewController, newItem: Category)
    func addNewToDoee(_: DetailedCategoryViewController, editedItem: Category)
}

//to make all DelegateProtocol methods optional
extension DetailedViewControllerDelegate {
    func addNewToDoee(_: DetailedCategoryViewController, newItem: ToDoee) {}
    func addNewToDoee(_: DetailedCategoryViewController, editedItem: ToDoee) {}
    func addNewToDoee(_: DetailedCategoryViewController, newItem: Category) {}
    func addNewToDoee(_: DetailedCategoryViewController, editedItem: Category) {}
}

class DetailedCategoryViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    var isCreatingItem: Bool!
    weak var delegate: DetailedViewControllerDelegate?
    var editingItem: AnyObject?
    var editingItemRowIndex: Int?
    
//    var titleForSection = [
//        "First Section Title will be changed while openning this screen",
//        "Notification",
//        "Description"
//    ]
//    var tableViewSectionContent = [
//        //section 0
//        ["title"],
//        //section 1
//        ["editing information", "one more edit info"],
//        //section 2
//        ["description"]
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "detailedCell")
//        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
       

    }
    
    func configureInitialViewWhenEditing(_ item: AnyObject) {
       
    }
    

    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if title == TypesOfChangesToPerform.createCategory.rawValue {
            createNewCategoryItem()
        } else if title == TypesOfChangesToPerform.createToDoee.rawValue {
            createNewToDoeeItem()
        }
    }
    
    func createNewCategoryItem() {
        guard let title = titleTextField.text, title != "" else {return}
        let newCategory = Category.init(title: title, toDoeeItems: [])
        delegate?.addNewToDoee(self, newItem: newCategory)
        navigationController?.popViewController(animated: true)
    }
    
    func createNewToDoeeItem() {
        guard let title = titleTextField.text, title != "" else {return}
        let newToDoee = ToDoee.init(title: title, description: "", checked: false, index: nil)
        delegate?.addNewToDoee(self, newItem: newToDoee)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isCreatingItem ? 1 : 1
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return isCreatingItem ? 1 : tableViewSectionContent.count
//    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return titleForSection[section]
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableViewSectionContent[section].count
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.section == 0 && indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "detailedCell", for: indexPath) as! TitleTableViewCell
//            return cell
//        } else if indexPath.section == 1 && indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
//            return cell
//        }
//
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "detailedCell", for: indexPath)
//        return cell
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
