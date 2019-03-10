//
//  ContactUs.swift
//  Aflama
//
//  Created by Esslam Emad on 24/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct ContactUs: Codable{
    var name: String!
    var email: String!
    var message: String!
    
    enum CodingKeys: String, CodingKey{
        case name
        case email
        case message
    }
}
