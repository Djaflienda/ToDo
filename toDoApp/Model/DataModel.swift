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
    
    init() {
        loadToDoeeItems()
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
