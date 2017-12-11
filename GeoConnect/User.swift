//
//  User.swift
//  GeoConnect
//
//  Created by David on 08/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation

class User {
    
    var id: String?
    var email: String?
    
    init(dict: [String: AnyObject]) {
        id = dict["id"] as? String
        email = dict["email"] as? String
    }
}
