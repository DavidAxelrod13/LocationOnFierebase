//
//  MainTabController.swift
//  GeoConnect
//
//  Created by David on 09/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginController())
                self.present(navController, animated: true, completion: nil)
            }
            return
        } else {
            setupTabBarViewControllers()
        }
    }
    
    func setupTabBarViewControllers() {
        
        let userFinderController = UserFinderController()
        let navController = UINavigationController(rootViewController: userFinderController)
        navController.tabBarItem.title = "Finder"
        
        viewControllers = [navController]
        
    }
}
