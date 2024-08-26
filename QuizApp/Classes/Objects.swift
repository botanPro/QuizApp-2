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




class LoginAPi{
    
    
    
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
        
        print(profile_name)
        print(full_name)
        print(bio)
        print(tags)
        print(phone)
        print(otp)

        // Convert UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            MessageBox.ShowMessage(Text:"Could not convert image to data")
            return
        }
        
        // Make the request using multipart form data
        AF.upload(multipartFormData: { multipartFormData in

            multipartFormData.append(imageData, withName: "image", fileName: "profile_image.jpg", mimeType: "image/jpeg")
           
//            if let tagsData = try? JSONSerialization.data(withJSONObject: tags, options: []) {
//                   multipartFormData.append(tagsData, withName: "tags")
//               }
            
            for (i, tag) in tags.enumerated() {
                let tagName = "tags[\(i)]"
                multipartFormData.append(String(tag).data(using: .utf8)!, withName: tagName)

                jsonDict[tagName] = tag
            }
            
            // Append text parameters
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
    var tag = ""
    
    init(id: Int, tag: String) {
        self.id = id
        self.tag = tag
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
                    let tag = TagsObject(id: val["id"].int ?? 0, tag: val["name"].string ?? "")
                    tags.append(tag);
                }
                completion(tags)
            case .failure(let error):
                print(error);
            }
        }
    }
}

