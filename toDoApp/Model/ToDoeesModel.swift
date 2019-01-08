//
//  ToDoeesModel.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 10/12/2018.
//  Copyright © 2018 MacBook-Игорь. All rights reserved.
//

import Foundation

//SHOULD I USE SINGLETON HERE???
struct ToDoeesModel {
    
    var toDoeesArray = [ToDoee]()
    
    
    
    func saveAtFile(name: String, element: [ToDoee]) {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(name).plist")
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

}
