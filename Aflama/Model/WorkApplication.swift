//
//  WorkApplication.swift
//  Aflama
//
//  Created by Esslam Emad on 24/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct WorkApplication: Codable{
    var id: Int!
    var companyID: Int!
    var company: User!
    var subCategoryID: Int!
    var subCategory: Category!
    var endDate: String!
    var categoryID: Int!
    var startDate: String!
    var title: String!
    var details: String!
    var scenario: String!
    var address: String!
    var photos: [String]!
    var videos: [String]!
    var voiceType: Int!
    var travel: Int!
    var gender: Int!
    var ageFrom: Int!
    var ageTo: Int!
    var skinColor: String!
    var hairColor: String!
    var eyeColor: String!
    var bodyType: String!
    var hairType: String!
    var heightFrom: Int!
    var heightTo: Int!
    var weightFrom: Int!
    var weightTo: Int!
    var bootSizeFrom: Int!
    var bootSizeTo: Int!
    var abayaSizeFrom: Int!
    var abayaSizeTo: Int!
    var tshirtSizeFrom: Int!
    var tshirtSizeTo: Int!
    var jeansLengthFrom: Int!
    var jeansLengthTo: Int!
    var jeansWidthFrom: Int!
    var jeansWidthTo: Int!
    var views: Int!
    var applicants: Int!
    var status: Bool!
    
    enum CodingKeys: String, CodingKey{
        case id
        case companyID = "company_id"
        case company
        case subCategoryID = "sub_cat_id"
        case subCategory = "sub_cat"
        case endDate = "end_date"
        case categoryID = "cat_id"
        case startDate = "start_date"
        case title
        case details
        case scenario
        case photos
        case videos
        case voiceType = "voice_type"
        case travel
        case gender
        case ageFrom = "age_from"
        case ageTo = "age_to"
        case skinColor = "skinColor"
        case hairColor = "hair_color"
        case eyeColor = "eye_color"
        case bodyType = "body_type"
        case hairType = "hair_type"
        case heightFrom = "height_from"
        case heightTo = "height_to"
        case weightFrom = "weight_from"
        case weightTo = "weight_to"
        case bootSizeFrom = "pot_size_from"
        case bootSizeTo = "pot_size_to"
        case abayaSizeFrom = "abaya_size_from"
        case abayaSizeTo = "abaya_size_to"
        case tshirtSizeFrom = "tshirt_size_from"
        case tshirtSizeTo = "tshirt_size_to"
        case jeansLengthFrom = "jeans_length_from"
        case jeansLengthTo =  "jeans_length_to"
        case jeansWidthFrom = "jeans_width_from"
        case jeansWidthTo = "jeans_width_to"
        case views
        case applicants
        case status
    }
}
