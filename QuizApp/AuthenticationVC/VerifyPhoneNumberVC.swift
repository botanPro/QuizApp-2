//
//  VerifyPhoneNumberVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 29/06/2024.
//

import UIKit
import Alamofire
import SwiftyJSON
import MHLoadingButton
import PhoneNumberKit
import RSLoadingView
import EFInternetIndicator

class VerifyPhoneNumberVC: UIViewController, UITextFieldDelegate , InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var Verify: UIButton!
    @IBOutlet weak var OTP: UITextField!
    @IBOutlet weak var SendOtp: UIButton!
    @IBOutlet weak var Phone: PhoneNumberTextField!
    @IBOutlet weak var StackBottom: NSLayoutConstraint!
    
    let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Phone.placeHolderColor = .lightGray
        self.Phone.keyboardType = .asciiCapable
        self.Phone.withPrefix = true
        self.Phone.withFlag = true
        self.Phone.withExamplePlaceholder = true

        ContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        ContainerView.layer.shadowOpacity = 0.3
        ContainerView.layer.shadowOffset = CGSize.zero
        ContainerView.layer.shadowRadius = 20

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
        addDoneButtonOnKeyboard()

        Phone.delegate = self
        OTP.delegate = self
       }

       func addDoneButtonOnKeyboard() {
           let toolbar: UIToolbar = UIToolbar()
           toolbar.sizeToFit()

           let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))

           toolbar.setItems([flexSpace, done], animated: false)
           toolbar.isUserInteractionEnabled = true

           Phone.inputAccessoryView = toolbar
           OTP.inputAccessoryView = toolbar
       }

       @objc func doneButtonAction() {
           Phone.resignFirstResponder()
           OTP.resignFirstResponder()
       }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    var count = 1
    @objc func keyboardWasShown(notification: NSNotification) {
        if count == 1{
           count += 1
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.StackBottom.constant += keyboardFrame.height - 50
        }
    }
    
    @objc func keyboardWasHiden(notification: NSNotification) {
        count = 1
        self.StackBottom.constant = 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Phone.becomeFirstResponder()
    }


    
    
    var phone = ""
    @IBAction func Verify(_ sender: Any) {
        if CheckInternet.Connection(){
            if self.Phone.text?.trimmingCharacters(in: .whitespaces) !=  "" && self.OTP.text?.trimmingCharacters(in: .whitespaces) != ""{
                let ResetPassURL = URL(string: "\(API.URL)api/reset_pass_check");
                self.view.endEditing(true)
                loadingView.show(on: view)
                let str = self.Phone.text!
                if str.count > 5{
                    let index = str.index(str.startIndex, offsetBy: 5)
                    if str[index] == "0" && self.Phone.currentRegion == "IQ"{
                        self.phone = self.Phone.text!
                        self.phone.remove(at: index)
                    }else{
                        self.phone = self.Phone.text!
                    }
                }
                
                self.phone = self.Phone.text!.convertedDigitsToLocale(Locale(identifier: "EN")).replace(string: " ", replacement: "");
                
                let param: [String: Any] = [
                    "phone": self.phone,
                    "otp": self.OTP.text!
                ]
                
                
                AF.request(ResetPassURL!, method: .post, parameters: param).responseData { response in
                    switch response.result
                    {
                    case .success:
                        let jsonData = JSON(response.data ?? "")
                        print(jsonData)
                        RSLoadingView.hide(from: self.view)
                        if(jsonData[0] == "error"){
                            MessageBox.ShowMessage(Text: "\(jsonData[0])")
                        }else{
                            if jsonData["status"] != "success"{
                                MessageBox.ShowMessage(Text: jsonData["message"].string ?? "")
                            }else{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
                                vc.modalPresentationStyle = .fullScreen
                                vc.phone = self.phone
                                vc.otp = self.OTP.text!
                                self.present(vc, animated: true)
                            }
                        }
                        
                        
                    case .failure(let error):
                        RSLoadingView.hide(from: self.view)
                        print(error);
                    }
                }
            }else{
                RSLoadingView.hide(from: self.view)
                if self.Phone.text == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە ژمارا موبایلێ بنڤیسە")
                    
                }
                
                if self.OTP.text == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە کودێ پشتراستکرنێ بنڤیسە")
                    
                }
            }
        }else{
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }
    }
    
    
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func SendOTP(_ sender: Any) {
        if CheckInternet.Connection(){
        if self.Phone.text?.trimmingCharacters(in: .whitespaces) != ""{
            loadingView.show(on: view)
            if self.Phone.text == ""{
                RSLoadingView.hide(from: self.view)
                MessageBox.ShowMessage(Text: "هیڤیە ژمارا موبایلێ بنڤیسە")
            }else{
                let SendOTPURL = URL(string: "\(API.URL)api/send_otp_pass_reset");
                let param: [String: Any] = [
                    "phone":self.Phone.text!.convertedDigitsToLocale(Locale(identifier: "EN")).replace(string: " ", replacement: "")
                ]
                
                AF.request(SendOTPURL!, method: .post, parameters: param).responseData { response in
                    switch response.result
                    {
                    case .success:
                        let jsonData = JSON(response.data ?? "")
                        print(jsonData)
                        if(jsonData[0] == "error"){
                            RSLoadingView.hide(from: self.view)
                            MessageBox.ShowMessage(Text: "\(jsonData[0])")
                        }else{
                                if jsonData["otp"].int != 0{
                                    self.OTP.becomeFirstResponder()
                                    RSLoadingView.hide(from: self.view)
                                }
                        }
                    case .failure(let error):
                        RSLoadingView.hide(from: self.view)
                        print(error);
                    }
                }
            }
        }else{
            RSLoadingView.hide(from: self.view)
            if self.Phone.text == ""{
                MessageBox.ShowMessage(Text: "هیڤیە ژمارا موبایلێ بنڤیسە")
            }
        }
    }else{
        self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
    }
    }
    
}
