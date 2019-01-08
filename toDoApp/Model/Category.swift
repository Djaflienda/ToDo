//
//  CategoryModel.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 20/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import Foundation

struct Category: Equatable, Codable {
//class Category: Codable {

    var title: String
    var index: Int?
    var description: String?
    var toDoeeItems: [ToDoee] = []
    
    mutating func move(item: ToDoee, to index: Int) {
        guard let currentIndex = toDoeeItems.firstIndex(of: item) else {return}
        toDoeeItems.remove(at: currentIndex)
        toDoeeItems.insert(item, at: index)
    }
    
    mutating func remove(items: [ToDoee]) {
        for item in items {
            if let index = toDoeeItems.firstIndex(of: item) {
                toDoeeItems.remove(at: index)
            }
        }
    }
    
    
}
