//
//  LoginVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 23/06/2024.
//

import UIKit
import PhoneNumberKit
import Alamofire
import SwiftyJSON
import MHLoadingButton
import RSLoadingView
import EFInternetIndicator
class LoginVC: UIViewController , UITextFieldDelegate, InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Login: UIButton!
    
    @IBOutlet weak var StackButtom: NSLayoutConstraint!
    @IBOutlet weak var Phone: PhoneNumberTextField!
    @IBOutlet weak var ContainerView: UIView!
    
    
    
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
        
        Phone.delegate = self
        Password.delegate = self
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.Phone.becomeFirstResponder()
    }
    
    
    func addDoneButtonOnKeyboard() {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))

        toolbar.setItems([flexSpace, done], animated: false)
        toolbar.isUserInteractionEnabled = true

        Phone.inputAccessoryView = toolbar
        Password.inputAccessoryView = toolbar
    }

    @objc func doneButtonAction() {
        Phone.resignFirstResponder()
        Password.resignFirstResponder()
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
        self.StackButtom.constant += keyboardFrame.height - 50
        }
    }
    
    @objc func keyboardWasHiden(notification: NSNotification) {
        count = 1
        self.StackButtom.constant = 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func Close(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
    
    var phone = ""
    @IBAction func Login(_ sender: Any) {
        if CheckInternet.Connection(){
            if self.Phone.text?.trimmingCharacters(in: .whitespaces) != "" && self.Password.text?.trimmingCharacters(in: .whitespaces) != ""{
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
                LoginAPi.Login(Phone:  self.phone, Password: self.Password.text!) { status in
                    
                    RSLoadingView.hide(from: self.view)
                    print("------")
                    print(status)
                    if status == "success"{
                        UserDefaults.standard.setValue("true", forKey: "login")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        vc.modalPresentationStyle = .fullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        self.present(vc, animated: true)
                    }
                    
                }
            }else{
                RSLoadingView.hide(from: self.view)
                if self.Phone.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە ژمارا موبایلێ بنڤیسە")
                }
                
                if self.Password.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە وشا نهێنی بنڤیسە")
                }
            }
        }else{
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }
    }
    
    
    
    
    
    var PassIsHide = true
    @IBAction func HidePass(_ sender: Any) {
        if self.PassIsHide == true{
            PassIsHide = false
            self.Password.isSecureTextEntry = false
        }else{
            PassIsHide = true
            self.Password.isSecureTextEntry = true
        }
    }
    
    
}
