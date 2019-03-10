//
//  UserNotification.swift
//  Aflama
//
//  Created by Esslam Emad on 24/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct UserNotification: Codable{
    var id: Int!
    var message: String!
    var userID: Int!
    var viewerID: Int!
    var dateTime: String!
    
    enum CodingKeys: String, CodingKey{
        case id
        case message
        case userID = "user_id"
        case viewerID = "viewer_id"
        case dateTime
    }
}
