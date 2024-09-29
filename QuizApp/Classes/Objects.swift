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



class  SlidesObject {
    var id = ""
    var link = ""
    var image = ""
    
    init(id : String ,link : String , image : String) {
        self.id = id
        self.link = link
        self.image = image
    }
}


class SlidesObjectAPI {
    static func GetSlideImage(completion :@escaping (_ SlideImage : [SlidesObject])->()){
        let stringUrl = URL(string: "\(API.URL)api/get_slider");
        var Slide = [SlidesObject]()
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)"]
        AF.request(stringUrl!, method: .get, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                    let slids = jsonData["data"].arrayValue
                    
                    for sld in slids {
                        let slide = SlidesObject(id: sld["id"].string ?? "",
                                                    link: sld["link"].string ?? "",
                                                    image: sld["image"].string ?? "")
                           Slide.append(slide)
                    }
                 
                completion(Slide)
            case .failure(let error):
                print(error);
            }
        }
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
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)"]
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
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)"]
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
    
    
    
    
    
    static func profile_serach_by_tag(tag_id:Int, completion : @escaping (_ Info : ProfileData)->()){
        let stringUrl = URL(string: "\("\(API.URL)api/profile_serach_by_tag")");
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)"]
        
        let param: [String: Any] = [
            "tag_id":tag_id
        ]
        
        AF.request(stringUrl!, method: .get, parameters: param, headers: headers).responseData { response in
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
        let param: [String: Any] = [
            "text":text
        ]
        AF.request(stringUrl!, method: .get,parameters: param).responseData { response in
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



class QuizObject{
    var gift_name = ""
    var link = ""
    var id = 0
    var youtube_link = ""
    var description = ""
    var title = ""
    var gift_winners = 0
    var start_time = ""
    var imagee = ""
    
    init(gift_name: String, link: String, id: Int, youtube_link: String, description: String, title: String, gift_winners: Int, start_time: String,imagee : String) {
        self.gift_name = gift_name
        self.link = link
        self.id = id
        self.youtube_link = youtube_link
        self.description = description
        self.title = title
        self.gift_winners = gift_winners
        self.start_time = start_time
        self.imagee = imagee
    }
}


class QuestionObject {
    var enrollId: Int
    var status: String
    var level: Int
    var message: String
    var remain_users: String
    var total_users: String
    init(enrollId: Int, status: String, level: Int, message: String, remain_users: String, total_users: String) {
        self.enrollId = enrollId
        self.status = status
        self.level = level
        self.message = message
        self.remain_users = remain_users
        self.total_users = total_users
    }
}

class Question {
    var title: String
    var time: Int
    var answer: String
    var id: Int

    init(title: String, time: Int, answer: String, id: Int) {
        self.title = title
        self.time = time
        self.answer = answer
        self.id = id
    }
}

class OptionsObject {
    var a: String
    var b: String
    var c: String
    var d: String

    init(a: String, b: String, c: String, d: String) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
}



class Winner {
    var name: String
    var image: String
    var level: Int
    var date = ""
    
    init(name: String, image: String, level: Int, date : String) {
        self.name = name
        self.image = image
        self.level = level
        self.date = date
    }
}


class QuizObjectApi{
    static func GetQuizs(completion :@escaping (_ Quiz : [QuizObject])->()){
        
        let stringUrl = URL(string: "\("\(API.URL)api/get_quizzes")");
        
        var quizs : [QuizObject] = []
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)"]
 
        AF.request(stringUrl!, method: .get, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                for (_,val) in jsonData["data"]{
                    let quiz = QuizObject(gift_name: val["gift_name"].string ?? "",
                                          link: val["link"].string ?? "",
                                          id: val["id"].int ?? 0,
                                          youtube_link: val["youtube_link"].string ?? "",
                                          description: val["description"].string ?? "",
                                          title: val["title"].string ?? "",
                                          gift_winners: val["gift_winners"].int ?? 0,
                                          start_time: val["start_time"].string ?? "",imagee: val["image"].string ?? "")
                    quizs.append(quiz);
                }
                completion(quizs)
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func EnrollQuizs(quiz_id : Int,completion :@escaping (_ sms : String)->()){
        let stringUrl = URL(string: "\(API.URL)api/enroll_quiz");
        
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)"]
        let param: [String: Any] = [
            "quiz_id": quiz_id
        ]
        
        
        AF.request(stringUrl!, method: .post, parameters: param, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print("jsonData---------")
                print(jsonData)
                
                completion(jsonData["status"].stringValue)
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    
    
    
    static func start_quiz(quiz_id : Int,completion :@escaping (_ question_object : QuestionObject, _ question: Question, _ options: [(key: String, value: String)])->()){
        let stringUrl = URL(string: "\(API.URL)api/start_quiz");
        
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)"]
        let param: [String: Any] = [
            "quiz_id": quiz_id
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print("jsonData---------")
                print(jsonData)
                let question = Question(
                    title: jsonData["question"]["title"].stringValue,
                    time: jsonData["question"]["time"].intValue,
                    answer: jsonData["question"]["answer"].stringValue,
                    id: jsonData["question"]["id"].intValue
                )
                
                
                var optionsArray: [(key: String, value: String)] = []
                // Parse the options object
                if let options = jsonData["options"].dictionary {
                    // Iterate through the dictionary and append to the array
                    for (key, value) in options {
                        optionsArray.append((key: key, value: value.stringValue))
                    }
                }
                    
                    
                
                // Create the final QuestionObject
                let questionObject = QuestionObject(
                    enrollId: jsonData["enrollid"].intValue,
                    status: jsonData["status"].stringValue,
                    level: jsonData["level"].intValue,
                    message: jsonData["message"].stringValue,
                    remain_users: jsonData["remain_users"].stringValue,
                    total_users: jsonData["total_users"].stringValue
                )
                completion(questionObject, question, optionsArray)
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func next_question(quiz_id : Int,completion :@escaping (_ question_object : QuestionObject, _ question: Question, _ options: [(key: String, value: String)], _ Statue: String)->()){
        let stringUrl = URL(string: "\(API.URL)api/next_question");
        
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)"]
        let param: [String: Any] = [
            "quiz_id": quiz_id
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print("First---------")
                print(jsonData)
                let question = Question(
                    title: jsonData["question"]["title"].stringValue,
                    time: jsonData["question"]["time"].intValue,
                    answer: jsonData["question"]["answer"].stringValue,
                    id: jsonData["question"]["id"].intValue
                )
                
                
                var optionsArray: [(key: String, value: String)] = []
                // Parse the options object
                if let options = jsonData["options"].dictionary {
                    // Iterate through the dictionary and append to the array
                    for (key, value) in options {
                        optionsArray.append((key: key, value: value.stringValue))
                    }
                }
                    
                
                // Create the final QuestionObject
                let questionObject = QuestionObject(
                    enrollId: jsonData["enrollid"].intValue,
                    status: jsonData["status"].stringValue,
                    level: jsonData["level"].intValue,
                    message: jsonData["message"].stringValue,
                    remain_users: jsonData["remain_users"].stringValue,
                    total_users: jsonData["total_users"].stringValue
                )
                
                let statue = jsonData["status"].stringValue
                
                completion(questionObject, question, optionsArray,statue)
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    
    
    
    static func SubmitAnswer(quiz_id : Int,question_id: Int,answer:String,completion :@escaping (_ Info : String)->()){
        let stringUrl = URL(string: "\(API.URL)api/submit_answer");
        
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)"]
        let param: [String: Any] = [
            "quiz_id": quiz_id,
            "question_id":question_id,
            "answer": answer
        ]
        AF.request(stringUrl!, method: .post, parameters: param, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print("Submit--------------Submit")
                print(jsonData)
                
                completion(jsonData["status"].stringValue)
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    static func get_last_quiz_winner(completion :@escaping (_ winner : [Winner],_ others : [Winner])->()){

        let url = "https://pdkone.com/api/get_last_quiz_winner"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(openCartApi.token)",
            "Content-Type": "multipart/form-data"
        ]

     
        let parameters: [[String: Any]] = [
            // Your parameters here
        ]

        AF.upload(multipartFormData: { multipartFormData in
            for param in parameters {
                if param["disabled"] != nil { continue }
                
                let paramName = param["key"] as! String
                let paramType = param["type"] as! String
                
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    multipartFormData.append(Data(paramValue.utf8), withName: paramName)
                } else if paramType == "file" {
                    let paramSrc = param["src"] as! String
                    let fileURL = URL(fileURLWithPath: paramSrc)
                    if let fileData = try? Data(contentsOf: fileURL) {
                        multipartFormData.append(fileData, withName: paramName, fileName: paramSrc, mimeType: param["contentType"] as? String)
                    }
                }
            }
        }, to: url, method: .get, headers: headers).response { response in
            switch response.result {
            case .success:
                let jsonData = JSON(response.data ?? "")
                
                    let topWinnersArray = jsonData["top_winners"].arrayValue
                    let other_participants = jsonData["other_participants"].arrayValue
                    var winners: [Winner] = []
                    var other_part : [Winner] = []
                    for winnerJSON in topWinnersArray {
                            let name = winnerJSON["name"].stringValue
                            let image = winnerJSON["image"].stringValue
                            let level = winnerJSON["level"].intValue
                            
                        let winner = Winner(name: name, image: image, level: level, date: "")
                            winners.append(winner)
                        }
                    
                    for winnerJSON in other_participants {
                            let name = winnerJSON["name"].stringValue
                            let image = winnerJSON["image"].stringValue
                            let level = winnerJSON["level"].intValue
                            
                        let other = Winner(name: name, image: image, level: level, date: "")
                            other_part.append(other)
                        }
                    print(topWinnersArray)
                    completion(winners, other_part)
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }

    }
    
    
    static func profile_serach_by_tag(tag_id: Int,completion :@escaping (_ infoo : [ProfileData])->()){
        let stringUrl = URL(string: "\(API.URL)api/profile_serach_by_tag");
        let param: [String: Any] = [
            "tag_id": tag_id
        ]
        var profiles : [ProfileData] = []
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)", "Content-Type": "multipart/form-data"]
        AF.request(stringUrl!, method: .get, parameters: param, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print("profile_serach_by_tag--------------Submit")
                print(jsonData)
                
                for (_,val) in jsonData["data"]{
                    
                    var tags: [Int: String] = [:]
                    for tag in val["tags"].arrayValue {
                        let id = tag["id"].intValue
                        let name = tag["name"].stringValue
                        tags[id] = name
                    }
                    
                    let profileData = ProfileData(
                        email: "",
                        image: val["image"].stringValue,
                        id: 0,
                        name: val["name"].stringValue,
                        fullname: "",
                        bio: "",
                        tags: tags,
                        phone: ""
                    )
                    
                    profiles.append(profileData)
                    
                }
                
                completion(profiles)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    static func logout(completion :@escaping (_ Info : String)->()){
        let stringUrl = URL(string: "\(API.URL)api/logout");
        
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)", "Content-Type": "multipart/form-data"]
        AF.request(stringUrl!, method: .get, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print("logout--------------Submit")
                print(jsonData)
                
                completion("kkkkk")
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func delete_account(completion :@escaping (_ Info : String)->()){
        let stringUrl = URL(string: "\(API.URL)api/delete_account");
        
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)", "Content-Type": "multipart/form-data"]
        AF.request(stringUrl!, method: .get, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print("delete_account--------------Submit")
                print(jsonData)
                
                completion("kkkkk")
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func profile_serach(text: String, completion :@escaping (_ Info : [ProfileData])->()){
        let stringUrl = URL(string: "\(API.URL)api/profile_serach");
        let param: [String: Any] = [
            "text": text
        ]
        var profiles : [ProfileData] = []
        let headers : HTTPHeaders = ["Authorization": "Bearer \(openCartApi.token)", "Content-Type": "multipart/form-data"]
        AF.request(stringUrl!, method: .get, parameters: param, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print("text--------------Submit")
                print(jsonData)
                
                for (_,val) in jsonData["data"]{
                    
                    var tags: [Int: String] = [:]
                    for tag in val["tags"].arrayValue {
                        let id = tag["id"].intValue
                        let name = tag["name"].stringValue
                        tags[id] = name
                    }
                    
                    let profileData = ProfileData(
                        email: "",
                        image: val["image"].stringValue,
                        id: 0,
                        name: val["name"].stringValue,
                        fullname: "",
                        bio: "",
                        tags: tags,
                        phone: ""
                    )
                    
                    profiles.append(profileData)
                    
                }
                
                completion(profiles)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    static func get_week_quiz_winner(completion :@escaping (_ Saturday : [Winner], _ Sunday : [Winner], _ Monday : [Winner], _ Tuesday : [Winner], _ Wednesday : [Winner], _ Thursday : [Winner],  _ Friday : [Winner])->()){
        let url = "https://pdkone.com/api/get_week_quiz_winner"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(openCartApi.token)",
            "Content-Type": "multipart/form-data"
        ]

        let parameters: [[String: Any]] = [
            // Your parameters here
        ]

        AF.upload(multipartFormData: { multipartFormData in
            for param in parameters {
                if param["disabled"] != nil { continue }
                
                let paramName = param["key"] as! String
                let paramType = param["type"] as! String
                
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    multipartFormData.append(Data(paramValue.utf8), withName: paramName)
                } else if paramType == "file" {
                    let paramSrc = param["src"] as! String
                    let fileURL = URL(fileURLWithPath: paramSrc)
                    if let fileData = try? Data(contentsOf: fileURL) {
                        multipartFormData.append(fileData, withName: paramName, fileName: paramSrc, mimeType: param["contentType"] as? String)
                    }
                }
            }
        }, to: url, method: .get, headers: headers).response { response in
            switch response.result {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                var SaturdayWinners: [Winner] = []
                var SundayWinners: [Winner] = []
                var MondayWinners: [Winner] = []
                var TuesdayWinners: [Winner] = []
                var WednesdayWinners: [Winner] = []
                var ThursdayWinners: [Winner] = []
                var FridayWinners: [Winner] = []
                
                let Saturday = jsonData["top_winners"]["Saturday"].arrayValue
                let Sunday = jsonData["top_winners"]["Sunday"].arrayValue
                let Monday = jsonData["top_winners"]["Monday"].arrayValue
                let Tuesday = jsonData["top_winners"]["Tuesday"].arrayValue
                let Wednesday = jsonData["top_winners"]["Wednesday"].arrayValue
                let Thursday = jsonData["top_winners"]["Thursday"].arrayValue
                let Friday = jsonData["top_winners"]["Friday"].arrayValue
                
                
                for winwers in Saturday{
                    let win = Winner(name: winwers["name"].stringValue, image: winwers["image"].stringValue, level: winwers["level"].intValue, date: winwers["date"].stringValue)
                    SaturdayWinners.append(win)
                }
                
                for winwers in Sunday{
                    let win = Winner(name: winwers["name"].stringValue, image: winwers["image"].stringValue, level: winwers["level"].intValue, date: winwers["date"].stringValue)
                    SundayWinners.append(win)
                }
                
                for winwers in Monday{
                    let win = Winner(name: winwers["name"].stringValue, image: winwers["image"].stringValue, level: winwers["level"].intValue, date: winwers["date"].stringValue)
                    MondayWinners.append(win)
                }
                
                for winwers in Tuesday{
                    let win = Winner(name: winwers["name"].stringValue, image: winwers["image"].stringValue, level: winwers["level"].intValue, date: winwers["date"].stringValue)
                    TuesdayWinners.append(win)
                }
                
                for winwers in Wednesday{
                    let win = Winner(name: winwers["name"].stringValue, image: winwers["image"].stringValue, level: winwers["level"].intValue, date: winwers["date"].stringValue)
                    WednesdayWinners.append(win)
                }
                
                for winwers in Thursday{
                    let win = Winner(name: winwers["name"].stringValue, image: winwers["image"].stringValue, level: winwers["level"].intValue, date: winwers["date"].stringValue)
                    ThursdayWinners.append(win)
                }
                
                for winwers in Friday{
                    let win = Winner(name: winwers["name"].stringValue, image: winwers["image"].stringValue, level: winwers["level"].intValue, date: winwers["date"].stringValue)
                    FridayWinners.append(win)
                }
                
                completion(SaturdayWinners, SundayWinners, MondayWinners, TuesdayWinners, WednesdayWinners, ThursdayWinners, FridayWinners)
            
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
    static func get_about(completion :@escaping (_ term_condition : String, _ about_project : String, _ about_us : String)->()){
        let stringUrl = URL(string: "\(API.URL)api/get_about");
        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print("get_about--------------Submit")
                print(jsonData)
                let term_condition = jsonData["term_conditions"].stringValue
                let about_project = jsonData["about_project"].stringValue
                let about_us = jsonData["about_us"].stringValue
                completion(term_condition, about_project, about_us)
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
}
