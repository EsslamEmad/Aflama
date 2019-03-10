//
//  Acting.swift
//  Aflama
//
//  Created by Esslam Emad on 24/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct Acting: Codable{
    var id: Int!
    var height: Double!
    var weight: Double!
    var skinColor: String!
    var hairColor: String!
    var eyeColor: String!
    var bootSize: Int!
    var userID: Int!
    var user: User!
    var subCategory: Int!
    var bodyType: String!
    var hairType: String!
    var tshirtSize: Int!
    var jeansLength: Int!
    var jeansWidth: Int!
    var abayaSize: Int!
    var video: String!
    var photos = [String]()
    var workAppID: Int!
    var workApp: WorkApplication!
    
    enum CodingKeys: String, CodingKey{
        case id
        case height
        case weight
        case skinColor = "skin_color"
        case hairColor = "hair_color"
        case eyeColor = "eye_color"
        case bootSize = "pot_size"
        case userID = "user_id"
        case user
        case subCategory = "sub_category"
        case bodyType = "body_type"
        case hairType = "hair_type"
        case tshirtSize = "tshirt_size"
        case jeansLength = "jeans_length"
        case jeansWidth = "jeans_width"
        case abayaSize = "abaya_size"
        case video
        case workAppID = "work_app_id"
        case workApp = "work_app"
    }
    
}
