//
//  Settings.swift
//  QuizApp
//
//  Created by Botan Amedi on 19/07/2024.
//

import UIKit
import EFInternetIndicator
class Settings: UIViewController , InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?

    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var NotificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        // Do any additional setup after loading the view.
    }

    @IBAction func DeleteAccount(_ sender: Any) {
        if !CheckInternet.Connection(){
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }else{
            self.logoutT = "ژێبرنا هژمارێ"
            self.logoutM = "ئەرێ تو  یێ پشتراستی تە دڤێت هژمارا خو ژەببەی؟"
            self.Action = "بەلێ"
            self.cancel = "نەخێر"
            let myAlert = UIAlertController(title: logoutT, message: logoutM, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: Action, style: .default, handler: { (UIAlertAction) in
                QuizObjectApi.delete_account { delete in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let myVC = storyboard.instantiateViewController(withIdentifier: "ChooseWayToLoginVC") as! ChooseWayToLoginVC
                    myVC.modalPresentationStyle = .overFullScreen
                    self.present(myVC, animated: true)
                }
            }))
            myAlert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            
        }
    }
    
    
    
    var messagee = ""
    var Action = ""
    var cancel = ""
    var logoutT = ""
    var logoutM = ""
    @IBAction func LogOut(_ sender: Any) {
        if !CheckInternet.Connection(){
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }else{
            self.logoutT = "چوونە دەر"
            self.logoutM = "ئەرێ تو یێ پشتراستی؟"
            self.Action = "بەلێ"
            self.cancel = "نەخێر"
            let myAlert = UIAlertController(title: logoutT, message: logoutM, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: Action, style: .default, handler: { (UIAlertAction) in
                QuizObjectApi.logout { logout in
                    UserDefaults.standard.set("false", forKey: "login")
                    UserDefaults.standard.set("", forKey: "token")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let myVC = storyboard.instantiateViewController(withIdentifier: "ChooseWayToLoginVC") as! ChooseWayToLoginVC
                    myVC.modalPresentationStyle = .overFullScreen
                    self.present(myVC, animated: true)
                }
            }))
            myAlert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            
        }
    }
    
}
