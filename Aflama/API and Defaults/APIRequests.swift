//
//  APIRequests.swift
//  Aflama
//
//  Created by Esslam Emad on 24/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import Moya

enum APIRequests {
    
    
    case login(email: String, password: String)
    case editUser(user: User)
    case register(user: User)
    case forgotPassword(email: String)
    case updateToken(id: Int, token: String)
    case contactUs(object: ContactUs)
    case getPages
    case getPage(id: Int)
    case upload(image: UIImage?, file: URL?, video: URL?)
    case addActing(acting: Fashion)
    case addFashion(fashion: Fashion)
    case addVoice(voice: Voice)
    case getCategories
    case getCategory(id: Int)
    case getCategoriesBy(parentID: Int)
    case getForms(categoryID: Int)
    case getFormsBy(categoryID: Int, subCategoryID: Int)
    case getUserForms(userID: Int, categoryID: Int)
    case getUserFormsBy(categoryID: Int, subCategoryID: Int, userID: Int)
    case requestUser(formID: Int, userID: Int)
    case getNotifications
    case deleteForm(id: Int)
    case getUser(id: Int, viewerID: Int?)
    case addRating(companyID: Int, userID: Int, rate: Double)
    case addCelebrity(celebrity: Celebrity)
    case getWorkApps
    case getWorkAppBy(id: Int)
    case getWorkAppsBy(companyID: Int)
    case addWorkApp(companyID: Int, subCategoryID: Int, endDate: String)
    case getuserWorks(userID: Int)
    case searchWorkApps(search: String)
    
}


extension APIRequests: TargetType{
    var baseURL: URL{
       /* switch Auth.auth.language{
        case "en":
            return URL(string: "https://sh.alyomhost.net/vision/en/mobile")!
        default:*/
            return URL(string: "https://sh.alyomhost.me/aflama/ar/mobile")!
        
        
    }
    var path: String{
        switch self{
        case .register:
            return "register"
        case .login:
            return "login"
        case .editUser:
            return "editUser"
        case .forgotPassword:
            return "forgotPassword"
        case .updateToken:
            return "updateToken"
            
        case .contactUs:
            return "contactUs"
        case .getPages:
            return "pages"
        case .getPage(id: let id):
            return "pages/\(id)"
        case .upload:
            return "upload"
        case .getCategories:
            return "getCategory"
        case .getCategory(id: let id):
            return "getCategory/\(id)"
        case .getCategoriesBy(parentID: let id):
            return "getCategoryByParent/\(id)"
        case .addVoice:
            return "addVoice"
        case .addFashion:
            return "addFashion"
        case .addActing:
            return "addActing"
        case .addCelebrity:
            return "addCelebrity"
        case .requestUser:
            return "hireUser"
        case .getForms(categoryID: let catID):
            return "getForms/\(catID)"
        case .getFormsBy(categoryID: let id1, subCategoryID: let id2):
            return "getFormsSubCat/\(id1)/\(id2)"
        case .getUserForms(userID: let userID, categoryID: let catID):
            return "getForms/\(catID)/\(userID)"
        case .getUserFormsBy(categoryID: let id1, subCategoryID: let id2, userID: let id3):
            return "getUserFormsBySubCatID/\(id1)/\(id2)/\(id3)"
        case .getNotifications:
            return "notifications/\(Auth.auth.user!.id ?? 0)"
        case .deleteForm(id: let id):
            return "deleteForm/\(id)/\(Auth.auth.user!.id ?? 0)"
        case .getUser(id: let id, viewerID: let id2):
            return "getUserById/\(id)\(id2 != nil ? "/\(id2!)" : "")"
        case .addRating:
            return "addRating"
        case .getWorkAppsBy(companyID: let id):
            return "getWorkAppByCompanyId/\(id)"
        case .addWorkApp:
            return "addWorkApp"
        case .getWorkApps:
            return "getWorkApp"
        case .getWorkAppBy(id: let id):
            return "getWorkApp/\(id)"
        case .getuserWorks(userID: let id):
            return "myWorks/\(id)"
        case .searchWorkApps:
            return "searchWorkApp"
        }
    }
    
    
    var method: Moya.Method{
        switch self{
        case .upload, .contactUs,  .updateToken, .forgotPassword, .editUser, .login, .register, .addVoice, .addFashion, .addActing, .requestUser, .addRating, .addCelebrity, .addWorkApp, .searchWorkApps:
            return .post
            
        default:
            return .get
        }
    }
    
    
    
    var task: Task{
        switch self{
            
        case .register(user: let user1):
            return .requestJSONEncodable(user1)
        case .login(email: let email, password: let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case.editUser(user: let user):
            return .requestJSONEncodable(user)
        case .forgotPassword(email: let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        case .updateToken(id: let id , token: let token):
            return .requestParameters(parameters: ["user_id": id, "token": token], encoding: JSONEncoding.default)
        case .addActing(acting: let acting):
            return .requestJSONEncodable(acting)
        case .addVoice(voice: let voice):
            return .requestJSONEncodable(voice)
        case .addFashion(fashion: let fashion):
            return .requestJSONEncodable(fashion)
        case .contactUs(object: let cu):
            return .requestJSONEncodable(cu)
        case .upload(image: let image,file: let url, video: let videourl):
            if let image = image{
                let data = image.jpegData(compressionQuality: 0.75)!
                let imageData = MultipartFormData(provider: .data(data), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                let multipartData = [imageData]
                return .uploadMultipart(multipartData)
            }else if let url = url{
             if let data = NSData(contentsOfFile: url.path){
                let fileData = MultipartFormData(provider: .data(data as Data), name: "image", fileName: "record.m4a", mimeType: "audio/m4a")
                let multipartData = [fileData]
                return .uploadMultipart(multipartData)}
            }else if let data = NSData(contentsOfFile: videourl!.path){
                let fileData = MultipartFormData(provider: .data(data as Data), name: "image", fileName: "video.mov", mimeType: "video/quicktime")
                let multipartData = [fileData]
                return .uploadMultipart(multipartData)
            }
            return .requestPlain
        case .requestUser(formID: let formID, userID: let userID):
            return .requestParameters(parameters: ["company_id": Auth.auth.user!.id, "form_id": formID, "user_id": userID], encoding: JSONEncoding.default)
        case .addRating(companyID: let id1, userID: let id2, rate: let rate):
            return .requestParameters(parameters: ["company_id": id1, "user_id": id2, "rating": rate], encoding: JSONEncoding.default)
        case .addCelebrity(celebrity: let celebrity):
            return .requestJSONEncodable(celebrity)
        case .addWorkApp(companyID: let id1, subCategoryID: let id2, endDate: let date):
            return .requestParameters(parameters: ["company_id": id1, "sub_cat_id": id2, "end_date": date], encoding: JSONEncoding.default)
        case .searchWorkApps(search: let search):
            return .requestParameters(parameters: ["search": search], encoding: JSONEncoding.default)
        default:
            return .requestPlain
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json",
                "client": "bd774529461ec185caaa6e66054a25ea53b487e3",
                "secret": "4f2a196e7a53e45593779276da68b164cfe8b798"]
    }
}
