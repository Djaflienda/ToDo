//
//  IconPickerViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 08/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    func changecategoryItem(_: IconPickerViewController, iconName: String)
}

class IconPickerViewController: UITableViewController {

    var iconsTitleArray = ["mario", "gost", "face", "sonic", "icon", "lion"]
    weak var delegate: IconPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Choose Icon"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        tableView.register(UINib(nibName: "IconPickerCell", bundle: nil), forCellReuseIdentifier: "iconCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconsTitleArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iconCell", for: indexPath) as! IconPickerCell
        cell.categoryIcon.image = UIImage(named: iconsTitleArray[indexPath.row])
        cell.categoryTitle.text = iconsTitleArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.changecategoryItem(self, iconName: iconsTitleArray[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
