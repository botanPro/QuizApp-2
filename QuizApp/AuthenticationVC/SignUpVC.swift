//
//  SignUpVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 23/06/2024.
//

import UIKit
import DropDown
import AVFoundation
import AudioToolbox
import SwiftyJSON
import BSImagePicker
import Photos
import PhoneNumberKit
import MHLoadingButton
import RSLoadingView
import PSMeter
import EFInternetIndicator
class SignUpVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, PasswordEstimator, InternetStatusIndicable{
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "بایو"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    @IBAction func PasswordDidChange(_ sender: Any) {
        let password = self.Password.text ?? ""
        StrongViewPassword.updateStrengthIndication(password: password)
    }
    
    @IBAction func ConfPasswordDidChange(_ sender: Any) {
        let password = self.ConfirmPassword.text ?? ""
        StrongViewConfirmPassword.updateStrengthIndication(password: password)
    }
    
    
    
    @IBOutlet weak var SendOTP: UIButton!
    
    @IBOutlet weak var OTP: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ProfileName: UITextField!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Phone: PhoneNumberTextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Bio: UITextView!
    @IBOutlet weak var TagsTextField: UITextField!
    @IBOutlet weak var TagsHeight: NSLayoutConstraint!
    @IBOutlet weak var TagsCollectionView: UICollectionView!
    var audioPlayer = AVAudioPlayer()
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var CreateAccount: UIButton!
    @IBOutlet weak var InfoStackView: UIStackView!
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var StackBottom: NSLayoutConstraint!
    
    @IBOutlet weak var StrongViewPassword: PSMeter!
    @IBOutlet weak var StrongViewConfirmPassword: PSMeter!
    
    let dropDown = DropDown()
    var forCollection: [String] = []
    var Tags : [TagsObject] = []
    var TagsID : [Int] = []
    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var numberOfItemsPerRow: CGFloat = 5
    let spacingBetweenCells: CGFloat = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StrongViewPassword.passwordEstimator = self
        StrongViewConfirmPassword.passwordEstimator = self
        ContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        ContainerView.layer.shadowOpacity = 0.3
        ContainerView.layer.shadowOffset = CGSize.zero
        ContainerView.layer.shadowRadius = 20
        self.Image.layer.cornerRadius = self.Image.bounds.width / 2
        dropDown.anchorView = self.TagsTextField
        self.TagsTextField.delegate = self
        self.Phone.placeHolderColor = .lightGray
        self.Phone.keyboardType = .asciiCapable
        self.Phone.withPrefix = true
        self.Phone.withFlag = true
        self.Phone.withExamplePlaceholder = true
        
        
        Bio.delegate = self
        Bio.text = "بایو"
        Bio.textColor = UIColor.lightGray
        
     
        TagsCollectionView.register(UINib(nibName: "CategoryCollectionViewcell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
        addDoneButtonOnKeyboard()

           // Set the delegate if needed
        Phone.delegate = self
        OTP.delegate = self
        ProfileName.delegate = self
        Name.delegate = self
        Bio.delegate = self
        Email.delegate = self
        Password.delegate = self
        ConfirmPassword.delegate = self
       }

       func addDoneButtonOnKeyboard() {
           let toolbar: UIToolbar = UIToolbar()
           toolbar.sizeToFit()

           let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))

           toolbar.setItems([flexSpace, done], animated: false)
           toolbar.isUserInteractionEnabled = true

           Phone.inputAccessoryView = toolbar
           ProfileName.inputAccessoryView = toolbar
           Name.inputAccessoryView = toolbar
           Bio.inputAccessoryView = toolbar
           Email.inputAccessoryView = toolbar
           Password.inputAccessoryView = toolbar
           ConfirmPassword.inputAccessoryView = toolbar
           OTP.inputAccessoryView = toolbar
           TagsTextField.inputAccessoryView = toolbar
       }

       @objc func doneButtonAction() {
           Phone.resignFirstResponder()
           ProfileName.resignFirstResponder()
           Name.resignFirstResponder()
           Bio.resignFirstResponder()
           Email.resignFirstResponder()
           Password.resignFirstResponder()
           ConfirmPassword.resignFirstResponder()
           OTP.resignFirstResponder()
           TagsTextField.resignFirstResponder()
       }
    
    
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")

        if number.count > 15 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 14)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }

        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }

        if number.count < 8 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "$1 ($2)", options: .regularExpression, range: range)

        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{3})(\\d{2})(\\d+)", with: "$1 ($2) $3 $4 $5", options: .regularExpression, range: range)
        }

        return number
    }
    
    
    func formatBack(phoneNumber: String) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        let end = number.index(number.startIndex, offsetBy: number.count)
        let range = number.startIndex..<end
        number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{3})(\\d{2})(\\d+)", with: "$1$2$3$4$5", options: .regularExpression, range: range)
        return number
    }
    
    
    let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
    @IBAction func SendOTP(_ sender: Any) {
        if CheckInternet.Connection(){
            if self.Phone.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
                loadingView.show(on: view)
                LoginAPi.SendOTP(Phone: self.Phone.text!.convertedDigitsToLocale(Locale(identifier: "EN")).replace(string: " ", replacement: "")) { Send in
                    RSLoadingView.hide(from: self.view)
                    self.OTP.becomeFirstResponder()
//                    MessageBox.ShowMessage(Text: "کودێ پشتراسکرنێ هاتە هنارتن")
                }
            }else{
                RSLoadingView.hide(from: self.view)
                MessageBox.ShowMessage(Text: "هیڤیە ژمارا موبایلێ بنڤیسە")
            }
        }else{
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }
        
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
    
    
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.TagsTextField{
            if CheckInternet.Connection(){
                self.dropDown.dataSource.removeAll()
                TagsObjectApi.GetTags(text: string) { TagsObject in
                    self.Tags = TagsObject
                    for Tag in TagsObject {
                        self.dropDown.dataSource.append(Tag.name)
                    }
                    self.dropDown.show()
                }
                
                self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    print("-------\(item)-------")
                    self.forCollection.append(item)
                    self.TagsCollectionView.reloadData()
                    self.TagsTextField.text = ""
                    self.view.endEditing(true)
                    if self.forCollection.count != 0{
                        self.TagsHeight.constant = 26
                    }
                    dropDown.hide()
                }
            }
        }
        return true
    }
    
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    
    var phone = ""
    @IBAction func CreateAccount(_ sender: Any) {
        if CheckInternet.Connection(){
            if self.Phone.text?.trimmingCharacters(in: .whitespaces) != "" && self.ProfileName.text?.trimmingCharacters(in: .whitespaces) != "" && self.Name.text?.trimmingCharacters(in: .whitespaces) != "" && self.Password.text?.trimmingCharacters(in: .whitespaces) != "" && self.ConfirmPassword.text?.trimmingCharacters(in: .whitespaces) != "" && self.OTP.text?.trimmingCharacters(in: .whitespaces) != "" && self.forCollection.count != 0 && self.Email.text?.trimmingCharacters(in: .whitespaces) != "" && self.Bio.text?.trimmingCharacters(in: .whitespaces) != ""{
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
                
                
                if self.validateEmail(enteredEmail: self.Email.text!) == false{
                    MessageBox.ShowMessage(Text: "ئیمێلێ تە نە یێ دروستە")
                    RSLoadingView.hide(from: self.view)
                    return
                }
                
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
                
                var TagsId : [Int] = []
                for Tag in Tags {
                    for (j, _) in forCollection.enumerated() {
                        if self.forCollection[j] == Tag.name{
                            TagsId.append(Tag.id)
                        }
                    }
                }
                
                LoginAPi.CreateAccount(image: self.Image.image ?? UIImage(), profile_name: self.ProfileName.text!, full_name: self.Name.text!, bio: self.Bio.text!, tags: TagsId, password: self.Password.text!, phone: self.phone, otp: self.OTP.text!, email: self.Email.text!) { status in
                    RSLoadingView.hide(from: self.view)
                    
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
                if self.ProfileName.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە ناڤێ پروفایلی بنڤیسە")
                    return
                }
                
                if self.Name.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە ناڤێ تەمام بنڤیسە")
                    return
                }
                
                if self.forCollection.count == 0{
                    MessageBox.ShowMessage(Text: "هیڤیە تا ٥ تاگسان هەلبژێرە")
                    return
                }
                
                if self.Phone.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە ژمارا موبایلێ بنڤیسە")
                    return
                }
                
                if self.OTP.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە کودێ پشتراستکرنێ بنڤیسە")
                    return
                }
                
                if self.Password.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە وشا نهێنی بنڤیسە")
                    return
                }
                
                if self.ConfirmPassword.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە دوپاتکرنا وشا نهێنی بنڤیسە")
                    return
                }
                
                if self.Email.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە ئیمایلی بنڤیسە")
                    return
                }
                
                if self.Bio.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە بایۆ پربکە")
                    return
                }
            }
        }else{
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }
    }
    
    
    
    var SelectedAssets = [PHAsset]()
    var Images : [UIImage] = []
    @IBAction func EditImage(_ sender: Any) {
        self.SelectedAssets.removeAll()
        let vc = BSImagePickerViewController()
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
        }, deselect: { (asset: PHAsset) -> Void in
        }, cancel: { (assets: [PHAsset]) -> Void in
        }, finish: { (assets: [PHAsset]) -> Void in
            for i in 0..<assets.count{
                self.SelectedAssets.append(assets[i])
                print(self.SelectedAssets)
            }
            self.getAllImages()
        }, completion: nil)
    }
    
    
    
    func getAllImages() -> Void {
        if SelectedAssets.count != 0{
            for i in 0..<SelectedAssets.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 512, height: 512), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                })
                self.Images.append(thumbnail)
                self.Image.image = thumbnail
            }
        }
    }
    
    
}




extension SignUpVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if self.forCollection.count == 0{
                return 0
            }else if self.forCollection.count >= 5{
                return 5
            }
        print(self.forCollection.count)
            return self.forCollection.count
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewcell
            cell.CategoryName.text = "#\(self.forCollection[indexPath.row])"
        cell.CategoryName.textColor = .black
            cell.SmallView.isHidden = true
            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(indexPath.row)
            let text = self.forCollection[indexPath.row]
            let width = self.estimatedFrame(text: text, font: UIFont.systemFont(ofSize: 14)).width
            return CGSize(width: width + 20, height: 25)
    }

    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }


     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

            return sectionInsets
        
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

            return spacingBetweenCells
        
     }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let soundURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "note11", ofType: "mp3")!)

                do{
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL as URL)

                }catch {
                    print("there was some error. The error was \(error)")
                }
                audioPlayer.play()
                AudioServicesPlaySystemSound(1519)
        
        self.forCollection.remove(at: indexPath.row)
        self.TagsCollectionView.reloadData()
        
    }
    
}
