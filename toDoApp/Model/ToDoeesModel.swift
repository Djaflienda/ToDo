//
//  ToDoeesModel.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 10/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import Foundation

enum SortingOption {
    //Add some more sort options
    case alphabeticSort
}

struct ToDoeesModel {
    
    var toDoeesArray: [ToDoee] = []
    
//    mutating func fillArrayWithDefaultData() {
//        for i in 0...100 {
//            let todoee = ToDoee(text: "toDoee #\(i)", description: "No description", checked: true, index: nil)
//            toDoeesArray.insert(todoee, at: 0)
//        }
//    }
    
    mutating func sortToDoeedArray( _ : SortingOption) {
        //sorting algorithms implementation will be here
        //all algorithms should be in their own files - study study algorithms
    }
    
    mutating func move(item: ToDoee, to index: Int) {
        guard let currentIndex = toDoeesArray.firstIndex(of: item) else {return}
        toDoeesArray.remove(at: currentIndex)
        toDoeesArray.insert(item, at: index)
    }
    
    mutating func remove(items: [ToDoee]) {
        for item in items {
            if let index = toDoeesArray.firstIndex(of: item) {
                toDoeesArray.remove(at: index)
            }
        }
    }
    
}
