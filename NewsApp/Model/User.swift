//
//  User.swift
//  NewsApp
//
//  Created by Aarij Imam on 26/05/2024.
//

import Foundation

struct User {
     var id: String = UUID().uuidString
     var username: String = ""
     var password: String = ""
    
    static public var shared = User()
}
