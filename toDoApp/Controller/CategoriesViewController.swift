//
//  CategoriesViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 20/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController {
    
    var arrayOfCategories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listViewController = storyboard?.instantiateViewController(withIdentifier: "ToDoeeList") as! ToDoeeListViewController
        
        
    }
}

// MARK: - tableViewDataSource Methods
extension CategoriesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCategories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text = arrayOfCategories[indexPath.row].title

        return cell
    }
}
