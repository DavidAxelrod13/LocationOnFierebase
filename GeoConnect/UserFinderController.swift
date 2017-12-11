//
//  UserFinderController.swift
//  GeoConnect
//
//  Created by David on 08/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class UserFinderController: UITableViewController {
    
    var user: User? {
        didSet{
            guard let email = user?.email else { return }
            navigationItem.title = email
            
            getLocation()
        }
    }
    
    var firstLoad = true
    let locationManager = CLLocationManager()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = logoutBarButton
        
        fetchUser()
        
        determineUserLocation()
    }
    
    private func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            guard let dict = snapshot.value as? [String: AnyObject] else { return }
            
            print("User fetched")
            let user = User(dict: dict)
            self.user = user

        }) { (error) in
            print("Error fetching User: \(error)")
        }
    }
    
    @objc private func handleLogout() {
        
        do {
            try Auth.auth().signOut()
            
            let navController = UINavigationController(rootViewController: LoginController())
            self.present(navController, animated: true, completion: nil)
        } catch let error {
            print("Error signing out: ", error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
}
