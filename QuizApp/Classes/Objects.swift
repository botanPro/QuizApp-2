//
//  Objects.swift
//  QuizApp
//
//  Created by Botan Amedi on 19/07/2024.
//


import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import AlertToast

class openCartApi{
    static var  token = UserDefaults.standard.string(forKey: "token") ?? ""
    let IMAGEURL = "https://pdkone.com/"
    let URL = "https://pdkone.com/";
    let APP_TITLE = "PDK One"
}
let API = openCartApi();

let APP_TITLE = "PDK One"






class QuestionObjects{
    var question = ""
    var answer1 = ""
    var answer2 = ""
    var answer3 = ""
    var answer4 = ""
    
    var correct_answer = ""
    
    
    init(question: String , answer1: String, answer2: String , answer3: String, answer4: String , correct_answer: String ) {
        self.question = question
        self.answer1 = answer1
        self.answer2 = answer2
        self.answer3 = answer3
        self.answer4 = answer4
        self.correct_answer = correct_answer
    }
    
}


class ProfileData{
    var email = ""
    var image = ""
    var id = 0
    var name = ""
    var fullname = ""
    var bio = ""
    var tags : [Int : String] = [:]
    var phone = ""
    
    init(email: String, image: String, id: Int, name: String, fullname: String, bio: String, tags: [Int: String], phone: String) {
          self.email = email
          self.image = image
          self.id = id
          self.name = name
          self.fullname = fullname
          self.bio = bio
          self.tags = tags
          self.phone = phone
      }
}

class LoginAPi{
    
    static func UpdateInfo(name: String, profile_name : String, bio:String, email:String, image: UIImage, tags : Array<Int>, completion : @escaping (_ Info : String)->()){
        print(openCartApi.token)
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)", "Content-Type": "application/json"]
        guard let stringUrl = URL(string: "\(API.URL)api/update_account") else {
            MessageBox.ShowMessage(Text:"Connection interrupted with server")
            return
        }
        var jsonDict: [String: Any] = [:]

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            MessageBox.ShowMessage(Text:"Could not convert image to data, choose another one")
            return
        }
        
        
        AF.upload(multipartFormData: { multipartFormData in

            multipartFormData.append(imageData, withName: "image", fileName: "profile_image.jpg", mimeType: "image/jpeg")

            for (i, tag) in tags.enumerated() {
                let tagName = "tags[\(i)]"
                multipartFormData.append(String(tag).data(using: .utf8)!, withName: tagName)

                jsonDict[tagName] = tag
            }
            
            
            multipartFormData.append(profile_name.data(using: .utf8)!, withName: "name");jsonDict["name"] = profile_name
            multipartFormData.append(name.data(using: .utf8)!, withName: "fullname");jsonDict["full_name"] = name
            multipartFormData.append(bio.data(using: .utf8)!, withName: "bio");jsonDict["bio"] = bio
            multipartFormData.append(email.data(using: .utf8)!, withName: "email");jsonDict["email"] = email
            
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
                   if let jsonString = String(data: jsonData, encoding: .utf8) {
                       print(jsonString)
                   }
               }
           
            
        }, to: stringUrl, method: .post, headers: headers)
        .responseData { response in
            switch response.result {
            case .success:
                let jsonData = JSON(response.data ?? Data())
                print(jsonData)
                if(jsonData[0] == "error"){
                    completion("")
                    MessageBox.ShowMessage(Text: "\(jsonData[0])")
                }else{
                    completion(jsonData["status"].string ?? "")
                    MessageBox.ShowMessage(Text: jsonData["message"].string ?? "")
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion("")
            }
        }
        
       
    }
    
    static func GetProfileInfo( completion : @escaping (_ Info : ProfileData)->()){
        let stringUrl = URL(string: "\("\(API.URL)api/my_profile")");
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)", "Content-Type": "application/json"]
        AF.request(stringUrl!, method: .get, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                if(jsonData[0] == "error"){
                    completion(ProfileData(email: "", image: "", id: 0, name: "", fullname: "", bio: "", tags: [:], phone: ""))
                    MessageBox.ShowMessage(Text: "\(jsonData[0])")
                }else{
                    let profile = jsonData["profile"]
                    
                 
                    var tags: [Int: String] = [:]
                    for tag in profile["tags"].arrayValue {
                        let id = tag["id"].intValue
                        let name = tag["name"].stringValue
                        tags[id] = name
                    }
                    
                    let profileData = ProfileData(
                        email: profile["email"].stringValue,
                        image: profile["image"].stringValue,
                        id: profile["id"].intValue,
                        name: profile["name"].stringValue,
                        fullname: profile["fullname"].stringValue,
                        bio: profile["bio"].string ?? "",
                        tags: tags,
                        phone: profile["phone"].stringValue
                    )
                    
                    completion(profileData)
                }
            case .failure(let error):
                print(error);
            }
        }
    }
    
    static func GetSlides( completion : @escaping (_ lol : String)->()){
        let stringUrl = URL(string: "\("\(API.URL)api/get_slider")");
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)", "Content-Type": "application/json"]
        AF.request(stringUrl!, method: .get, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                if(jsonData[0] == "error"){
                    completion("")
                    MessageBox.ShowMessage(Text: "\(jsonData[0])")
                }else{
                        
                }
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func SendOTP(Phone : String, completion : @escaping (_ lol : String)->()){
        let stringUrl = URL(string: "\("\(API.URL)api/send_otp")");
        let param: [String: Any] = [
            "phone":Phone
        ]
        print(Phone)
        AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                if(jsonData[0] == "error"){
                    completion("")
                    MessageBox.ShowMessage(Text: "\(jsonData[0])")
                }else{
                        MessageBox.ShowMessage(Text: jsonData["message"].string ?? "")
                        completion("")
                }
            case .failure(let error):
                print(error);
            }
        }
    }
    
    static func Login(Phone : String, Password: String , completion : @escaping (_ lol : String)->()){
        let stringUrl = URL(string: "\("\(API.URL)api/login")");
        let param: [String: Any] = [
            "phone":Phone,
            "password" : Password
        ]
        var status = ""
        AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                if(jsonData[0] == "error"){print("999999")
                    completion("")
                    MessageBox.ShowMessage(Text: "\(jsonData[0])")
                }else{
                    status = jsonData["status"].string ?? ""
                    if status != "success"{
                        MessageBox.ShowMessage(Text: jsonData["message"].string ?? "")
                        completion("")
                    }else{
                        UserDefaults.standard.setValue(jsonData["token"].string ?? "", forKey: "token")
                        UserDefaults.standard.setValue(jsonData["user_id"].string ?? "", forKey: "user_id")
                        openCartApi.token = UserDefaults.standard.string(forKey: "token") ?? ""
                        completion(status)
                    }
                }
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func ResetPassword(Phone : String, Password: String , otp: Int , password_confirmation: String , completion : @escaping (_ statu : String)->()){
        let stringUrl = URL(string: "\("\(API.URL)api/reset_password")");
        var status = ""
        let param: [String: Any] = [
            "phone":Phone,
            "password" : Password,
            "otp" : otp,
            "password_confirmation" : password_confirmation
            
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                if(jsonData[0] == "error"){
                    completion("")
                    MessageBox.ShowMessage(Text: "\(jsonData[0])")
                }else{
                    status = jsonData["status"].string ?? ""
                    if status != "success"{
                        MessageBox.ShowMessage(Text: jsonData["message"].string ?? "")
                        completion("")
                    }else{
                        print(jsonData["status"].string ?? "")
                        completion(status)
                    }
                    
                }
            case .failure(let error):
                completion("")
                print(error);
            }
        }
    }
    


    static func CreateAccount(image: UIImage, profile_name: String, full_name: String, bio: String, tags: Array<Int>, password: String, phone: String, otp: String ,email: String,  completion : @escaping (_ lol : String)->()) {
        guard let stringUrl = URL(string: "\(API.URL)api/create_account") else {
            MessageBox.ShowMessage(Text:"Invalid URL")
            return
        }
        var jsonDict: [String: Any] = [:]

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            MessageBox.ShowMessage(Text:"Could not convert image to data")
            return
        }
        
        
        AF.upload(multipartFormData: { multipartFormData in

            multipartFormData.append(imageData, withName: "image", fileName: "profile_image.jpg", mimeType: "image/jpeg")

            for (i, tag) in tags.enumerated() {
                let tagName = "tags[\(i)]"
                multipartFormData.append(String(tag).data(using: .utf8)!, withName: tagName)

                jsonDict[tagName] = tag
            }
            
            
            multipartFormData.append(profile_name.data(using: .utf8)!, withName: "name");jsonDict["name"] = profile_name
            multipartFormData.append(full_name.data(using: .utf8)!, withName: "fullname");jsonDict["full_name"] = full_name
            multipartFormData.append(bio.data(using: .utf8)!, withName: "bio");jsonDict["bio"] = bio
            multipartFormData.append(password.data(using: .utf8)!, withName: "password");jsonDict["password"] = password
            multipartFormData.append(phone.data(using: .utf8)!, withName: "phone");jsonDict["phone"] = phone
            multipartFormData.append(email.data(using: .utf8)!, withName: "email");jsonDict["email"] = phone
            multipartFormData.append(otp.data(using: .utf8)!, withName: "otp");jsonDict["otp"] = otp
            
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
                   if let jsonString = String(data: jsonData, encoding: .utf8) {
                       print(jsonString)
                   }
               }
           
            
        }, to: stringUrl, method: .post)
        .responseData { response in
            switch response.result {
            case .success:
                var status = ""
                let jsonData = JSON(response.data ?? Data())
                print(jsonData)
                if(jsonData[0] == "error"){
                    completion("")
                    MessageBox.ShowMessage(Text: "\(jsonData[0])")
                }else{

                    status = jsonData["status"].string ?? ""
                    
                    if status != "success"{
                        MessageBox.ShowMessage(Text: jsonData["message"].string ?? "")
                        completion("")
                    }else{
                        UserDefaults.standard.setValue(jsonData["token"].string ?? "", forKey: "token")
                        UserDefaults.standard.setValue(jsonData["user_id"].string ?? "", forKey: "user_id")
                        openCartApi.token = UserDefaults.standard.string(forKey: "token") ?? ""
                        completion(status)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion("")
            }
        }
    }

}



class TagsObject{
    var id = 0
    var name = ""
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}


class TagsObjectApi{
    static func GetTags(text: String,completion : @escaping (_ TagsObject : [TagsObject])->()){
        
        let stringUrl = URL(string: "\("\(API.URL)api/search_tag")");

        var tags : [TagsObject] = []
//        let headers : HTTPHeaders = ["Authorization": "Bearer your_generated_token", "Content-Type": "application/json"]
        let param: [String: Any] = [
            "text":text
        ]
        AF.request(stringUrl!, method: .get,parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                //print(jsonData)
                for (_,val) in jsonData["data"]{
                    let tag = TagsObject(id: val["id"].int ?? 0, name: val["name"].string ?? "")
                    tags.append(tag);
                }
                completion(tags)
            case .failure(let error):
                print(error);
            }
        }
    }
    
    static func GetAllTags(completion : @escaping (_ TagsObject : [TagsObject])->()){
        let stringUrl = URL(string: "\("\(API.URL)api/search_tag")");
        var tags : [TagsObject] = []
        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                for (_,val) in jsonData["data"]{
                    let tag = TagsObject(id: val["id"].int ?? 0, name: val["name"].string ?? "")
                    tags.append(tag);
                }
                completion(tags)
            case .failure(let error):
                print(error);
            }
        }
    }
}

