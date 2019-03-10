//
//  Celebrity.swift
//  Aflama
//
//  Created by Esslam Emad on 24/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct Celebrity: Codable{
    var id: Int!
    var userID: Int!
    var user: User!
    var workAppID: Int!
    var workApp: WorkApplication!
    var subCategory: Int!
    var contentType: String!
    
    enum CodingKeys: String, CodingKey{
        case id
        case userID = "user_id"
        case user
        case workAppID = "work_app_id"
        case workApp = "work_app"
        case subCategory = "sub_category"
        case contentType = "content_type"
    }
}
