//
//  UserData.swift
//  Authentication
//
//  Created by Rashika Gupta on 26/04/25.
//

import Foundation

struct UserData: Codable, Sendable {
    var user_id = UUID()
    let first_name: String
    let middle_name: String?
    let last_name: String
    let profession: String
    let age : Int
    let email: String
    let date_of_birth: Date
    let gender: String
    let address: String
    let phone_number: String
    let password: String
    let userPoints: Int

    init(first_name: String, middle_name: String? = nil, last_name: String, profession: String, age:Int, email: String, date_of_birth: Date, gender: String, address: String, phone_number: String, password: String, userPoints: Int) {
            
        self.first_name = first_name
        self.middle_name = middle_name
        self.last_name = last_name
        self.profession = profession
        self.age = age
        self.email = email
        self.date_of_birth = date_of_birth
        self.gender = gender
        self.address = address
        self.phone_number = phone_number
        self.password = password
        self.userPoints = userPoints
    }
}
