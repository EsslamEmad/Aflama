//
//  Category.swift
//  Aflama
//
//  Created by Esslam Emad on 24/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct Category: Codable{
    var id: Int!
    var title: String!
    var parent: Int!
    var photo: String!
    var subCategories = [Category]()
    var scinario: String!
    
    enum CodingKeys: String, CodingKey{
        case id
        case title
        case parent
        case photo
        case scinario
    }
}

struct SubCategory: Codable {
    var id: Int!
    var title: String!
    var parent: Int!
    var photo: String!
    
    enum CodingKeys: String, CodingKey{
        case id
        case title
        case parent
        case photo
    }
}
