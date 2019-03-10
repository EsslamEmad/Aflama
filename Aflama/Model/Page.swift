//
//  Page.swift
//  Aflama
//
//  Created by Esslam Emad on 24/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct Page: Codable{
    var id: Int!
    var title: String!
    var content: String!
    
    enum CodingKeys: String, CodingKey{
        case id
        case title
        case content
    }
}
