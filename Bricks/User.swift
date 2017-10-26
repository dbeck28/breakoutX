//
//  User.swift
//  Bricks
//
//  Created by Dayne Beck on 10/25/17.
//  Copyright © 2017 Dayne Beck. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
}

struct User {
    var name: String
    var username: String
    var email: String
    var password: String
    
//    init(json: [String: Any]) throws {
//        guard let name = json["name"] as? String else {
//            // [3]
//            throw SerializationError.missing("name")
//        }
//        self.name = name
//        
//        guard let username = json["username"] as? String else {
//            // [3]
//            throw SerializationError.missing("username")
//        }
//        self.username = username
//        
//        guard let email = json["email"] as? String else {
//            // [3]
//            throw SerializationError.missing("email")
//        }
//        self.email = email
//        
//        guard let password = json["password"] as? String else {
//            // [3]
//            throw SerializationError.missing("password")
//        }
//        self.password = password
//    }
}

