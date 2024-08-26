//
//  ForgetPasswordVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 29/06/2024.
//

import UIKit
import MHLoadingButton
import Alamofire
import SwiftyJSON
import RSLoadingView
import PSMeter
import EFInternetIndicator
class ForgetPasswordVC: UIViewController , PasswordEstimator, InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?
    
    var IsPasswordStrong = false
    var IsConfPasswordStrong = false
    func estimatePassword(_ password: String) -> PasswordStrength {
            if password.count >= 8 {
                IsPasswordStrong = true
                IsConfPasswordStrong = true
                return .strong
            }else{
                IsPasswordStrong = false
                IsConfPasswordStrong = false
                return .weak
            }
        }
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    
    @IBOutlet weak var StackBottom: NSLayoutConstraint!
    @IBOutlet weak var Update: LoadingButton!
    @IBOutlet weak var ContainerView: UIView!
    var phone = ""
    var otp = ""
    
    @IBAction func PasswordDidChange(_ sender: Any) {
        let password = self.Password.text ?? ""
        StrongViewPassword.updateStrengthIndication(password: password)
    }
    
    @IBAction func ConfPasswordDidChange(_ sender: Any) {
        let password = self.ConfirmPassword.text ?? ""
        StrongViewConfirmPassword.updateStrengthIndication(password: password)
    }
    
    @IBOutlet weak var StrongViewPassword: PSMeter!
    @IBOutlet weak var StrongViewConfirmPassword: PSMeter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StrongViewPassword.passwordEstimator = self
        StrongViewConfirmPassword.passwordEstimator = self
        ContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        ContainerView.layer.shadowOpacity = 0.3
        ContainerView.layer.shadowOffset = CGSize.zero
        ContainerView.layer.shadowRadius = 20
    }
    
    let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
    
    @IBAction func Update(_ sender: Any) {
        if CheckInternet.Connection(){
        if self.Password.text?.trimmingCharacters(in: .whitespaces) != "" && self.ConfirmPassword.text?.trimmingCharacters(in: .whitespaces) != ""{
            self.view.endEditing(true)
            loadingView.show(on: view)
            
            if self.Password.text! != self.ConfirmPassword.text!{
                MessageBox.ShowMessage(Text: "وشا نهێنی وەکهەڤ نینە")
                RSLoadingView.hide(from: self.view)
                return
            }
            
            
            if self.IsPasswordStrong == false{
                MessageBox.ShowMessage(Text: "وشا نهێنی دڤێت کێمتر نە بیت  ژ ٨ پیتان")
                RSLoadingView.hide(from: self.view)
                return
            }
            
            if self.IsConfPasswordStrong == false{
                MessageBox.ShowMessage(Text: "وشا نهێنی دڤێت کێمتر نە بیت  ژ ٨ پیتان")
                RSLoadingView.hide(from: self.view)
                return
            }
            
            
            let phone = self.phone
            let otp = self.otp
            
            print(phone)
            print(otp)
            LoginAPi.ResetPassword(Phone: phone, Password: self.Password.text!, otp: (otp as NSString).integerValue, password_confirmation: self.ConfirmPassword.text!) { status in
                RSLoadingView.hide(from: self.view)
                
                    if status == "success"{
                        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    }

            }
        }else{
            if self.Password.text! == ""{
                MessageBox.ShowMessage(Text: "هیڤیە وشا نهێنی بنڤیسە")
            }
            
            if self.ConfirmPassword.text! == ""{
                MessageBox.ShowMessage(Text: "هیڤیە دوپاتکرنا وشا نهێنی بنڤیسە")
            }
        }
        }else{
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }
    }
    
    
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var PassIsHide = true
    var ConfPassIsHide = true
    @IBAction func HidePassword(_ sender: UIButton) {
        if sender.tag == 0{
            if self.PassIsHide == true{
                PassIsHide = false
                self.Password.isSecureTextEntry = false
            }else{
                PassIsHide = true
                self.Password.isSecureTextEntry = true
            }
        }else{
            if self.ConfPassIsHide == true{
                ConfPassIsHide = false
                self.ConfirmPassword.isSecureTextEntry = false
            }else{
                ConfPassIsHide = true
                self.ConfirmPassword.isSecureTextEntry = true
            }
        }
    }
    
}
