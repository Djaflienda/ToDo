//
//  MenuOptions.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 10/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

//WELL THIS IS MODEL - WHY IMPORT UIKIT???
import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case Profile
    case Inbox
    case Notifications
    case Settings
    
    var description: String {
        switch self {
        case .Profile: return "Profile"
        case .Inbox: return "Inbox"
        case .Notifications: return "Notifications"
        case .Settings: return "Settings"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Profile: return UIImage(named: "checked") ?? UIImage()
        case .Inbox: return UIImage(named: "checked") ?? UIImage()
        case .Notifications: return UIImage(named: "checked") ?? UIImage()
        case .Settings: return UIImage(named: "checked") ?? UIImage()
        }
    }
}

