//
//  CategoriesModel.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 27/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import Foundation

struct CategoriesList {
    
    var categoriesArray: [Category] = []
    var totalToDoeeAmount: Int = 0
    
    mutating func move(item: Category, to index: Int) {
        guard let currentIndex = categoriesArray.firstIndex(of: item) else {return}
        categoriesArray.remove(at: currentIndex)
        categoriesArray.insert(item, at: index)
    }
    
    mutating func remove(items: [Category]) {
        for item in items {
            if let index = categoriesArray.firstIndex(of: item) {
                categoriesArray.remove(at: index)
            }
        }
    }
    
    func saveAtFile(element: [Category]) {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Categories.plist")
        //BUT WHAT IF I ALREADY HAVE A FILE WITH SUCH NAME???
        //FIX
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(element)
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
