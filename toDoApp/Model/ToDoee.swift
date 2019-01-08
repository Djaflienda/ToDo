//
//  File.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 08/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import Foundation

struct ToDoee: Equatable, Codable {
    var title: String
    
    var description: String?
    var checked: Bool
    var index: Int?
    
//    init?(title: String, description: String, checked: Bool, index: Int?) {
//        self.title = title
//        self.description = description
//        self.checked = false
//        self.index = 0
//        //if add/save button will not be available while titleTextField isEmpty ->
//        //I do nor need failable init anymore 
//        if title == "" {
//            return nil
//        }
//    }
    
    mutating func toggleState() {
        checked = !checked
    }
}
