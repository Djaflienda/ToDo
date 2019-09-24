//
//  EditingViewControllerDelegate.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 10/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

protocol EditingViewControllerDelegate: class {
    func addNewToDoee(_: EditingViewController, newItem: ToDoee)
    func addNewToDoee(_: EditingViewController, editedItem: ToDoee)
}
