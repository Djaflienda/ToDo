//
//  ContainerViewController.swift
//  toDoApp
//
//  Created by MacBook-Игорь on 10/01/2019.
//  Copyright © 2019 MacBook-Игорь. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    // MARK: - Properties
    
    var menuController: MenuViewController!
    var centerController: UIViewController!
    var isExpanded = false
    var dataModel: DataModel!
    
    weak var delegate: MenuViewControllerDelegate?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureRootViewController()
        
        print(dataModel)
        print("_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+")
        
    }
    

    
    // MARK: - Handlers
    
    func configureRootViewController() {
        
        print(dataModel.indexOfSelectedToDoeeList)
        
        let rootViewController = RootViewController()
        
        rootViewController.dataModel = dataModel
        
        centerController = UINavigationController(rootViewController: rootViewController)
        rootViewController.delegate = self
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuViewController() {
        if menuController == nil {
            menuController = MenuViewController()
            menuController.dataModel = dataModel
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
            print("Did add menu controller ..")
        }
    }
    
    func showMenuViewController(shouldExpand: Bool) {
        if shouldExpand {
            // show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
                
                
                
            }) { (_) in
                print("1")
            }
        } else {
            // hide menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.centerController.view.frame.origin.x = 0
            })
        }
    }
}

extension ContainerViewController: RootViewControllerDelegate {
    func handleMenuToggle() {
        
        if !isExpanded {
            configureMenuViewController()
            delegate?.updateTableView()
        }
        
        isExpanded = !isExpanded
        showMenuViewController(shouldExpand: isExpanded)
    }
}
