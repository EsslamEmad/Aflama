//
//  User.swift
//  Aflama
//
//  Created by Esslam Emad on 24/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct User: Codable{
    var id: Int!
    var name: String!
    var email: String!
    var phone: String!
    var photo: String!
    var token: String!
    var gender: Int!
    var nationality: String!
    var age: Int!
    var type: Int!
    var rating: Double!
    var about: String!
    var travel: Int!
    var country: String!
    var city: String!
    var view: Int!
    var idForEdit: Int!
    var password: String!
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case email
        case phone
        case photo
        case token
        case gender
        case nationality
        case age
        case type
        case rating
        case about
        case travel
        case country
        case city
        case view
        case idForEdit = "user_id"
        case password
    }
}
