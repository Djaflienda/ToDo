//
//  CategoriesModel.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 27/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import Foundation

class DataModel {
    
    var listOfCategories: [Category] = []
    var indexOfSelectedToDoeeList: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ToDoeeListViewController")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ToDoeeListViewController")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        loadToDoeeItems()
        registerDefaults()
        handleFirstRun()
    }
    
    func loadToDoeeItems() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Categories.plist")
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                listOfCategories = try decoder.decode([Category].self, from: data)
            } catch {
                print("Error decoding item array")
            }
        }
    }
    
    func registerDefaults() {
        let dictionary: [String : Any] = ["ToDoeeListViewController": -1,
                          "isFirstRun": true]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstRun() {
        let firstRun = UserDefaults.standard.bool(forKey: "isFirstRun")
        if firstRun {
            let newCategory = Category.init(title: "New Category", iconName: "default", index: nil, description: nil, toDoeeItems: [])
            listOfCategories.append(newCategory)
            indexOfSelectedToDoeeList = 0
            UserDefaults.standard.set(false, forKey: "isFirstRun")
            UserDefaults.standard.synchronize()
        }
    }
    
    func move(item: Category, to index: Int) {
        guard let currentIndex = listOfCategories.firstIndex(of: item) else {return}
        listOfCategories.remove(at: currentIndex)
        listOfCategories.insert(item, at: index)
    }
    
    func remove(items: [Category]) {
        for item in items {
            if let index = listOfCategories.firstIndex(of: item) {
                listOfCategories.remove(at: index)
            }
        }
    }

    func saveAtFile() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Categories.plist")
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(listOfCategories)
            try data.write(to: path, options: .atomic)
        } catch {
            print("Error encoding otem array")
        }
    }
    
    func deleteFileWith(name: String) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(name).plist")
        do {
            try FileManager.default.removeItem(at: path)
        } catch {
            print("Error while deleting category nested list")
        }
    }

}
