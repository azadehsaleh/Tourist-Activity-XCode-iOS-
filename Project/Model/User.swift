//
//  User.swift
//  Project
//
//  Created by Azadeh Saleh on 2022-03-27.
//

import Foundation
class User{
    var userId: Int
    var emailAdrees:String
    var password:String
    init(userId: Int, emailAdrees:String, password:String)
    {
        self.userId = userId
        self.emailAdrees = emailAdrees
        self.password = password
    }
}
