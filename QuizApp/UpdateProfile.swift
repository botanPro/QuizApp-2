//
//  UpdateProfile.swift
//  QuizApp
//
//  Created by Botan Amedi on 19/07/2024.
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
class UpdateProfile: UIViewController , UITextFieldDelegate, UITextViewDelegate, InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?
    

    @IBOutlet weak var Bio: UITextView!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var ProfileName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var TagsCollectionView: UICollectionView!
    @IBOutlet weak var StackBottom: NSLayoutConstraint!
    @IBOutlet weak var TagsTextField: UITextField!
    @IBOutlet weak var TagsHeight: NSLayoutConstraint!
    var audioPlayer = AVAudioPlayer()
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
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    let dropDown = DropDown()
    var forCollection: [TagsObject] = []
    var Tags : [TagsObject] = []
    var SearchedTags : [TagsObject] = []
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var numberOfItemsPerRow: CGFloat = 5
    let spacingBetweenCells: CGFloat = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.Image.layer.cornerRadius = self.Image.bounds.width / 2
        TagsCollectionView.register(UINib(nibName: "CategoryCollectionViewcell", bundle: nil), forCellWithReuseIdentifier: "Cell")

        LoginAPi.GetProfileInfo { [self] info in
           
            
            if let imageUrl = URL(string: "https://pdkone.com/storage/user_images/1724686291_66cc9fd3216e4.jpg") {
                self.Image.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "account-avatar-profile-user-svgrepo-com"))
            }else{
                self.Image.image = UIImage(named: "account-avatar-profile-user-svgrepo-com")
            }
            
            if info.fullname != ""{
                self.Name.text = info.fullname
            }
            if info.bio != ""{
                self.Bio.text = info.bio
            }else{
                Bio.delegate = self
                Bio.text = "بایو"
                Bio.textColor = UIColor.lightGray
            }
            if info.name != ""{
                self.ProfileName.text = info.name
            }
            if info.email != ""{
                self.Email.text = info.email
            }
            
            for (id, name) in info.tags {
                self.Tags.append(TagsObject(id: id, name: name))
            }
            if self.Tags.count != 0{
                self.TagsCollectionView.reloadData()
                self.TagsHeight.constant = 26
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
        addDoneButtonOnKeyboard()

           // Set the delegate if needed
        self.TagsTextField.delegate = self
        ProfileName.delegate = self
        Name.delegate = self
        Bio.delegate = self
        Email.delegate = self
        
        
       }

       func addDoneButtonOnKeyboard() {
           let toolbar: UIToolbar = UIToolbar()
           toolbar.sizeToFit()

           let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))

           toolbar.setItems([flexSpace, done], animated: false)
           toolbar.isUserInteractionEnabled = true

           ProfileName.inputAccessoryView = toolbar
           Name.inputAccessoryView = toolbar
           Bio.inputAccessoryView = toolbar
           Email.inputAccessoryView = toolbar
           TagsTextField.inputAccessoryView = toolbar
       }

       @objc func doneButtonAction() {
           ProfileName.resignFirstResponder()
           Name.resignFirstResponder()
           Bio.resignFirstResponder()
           Email.resignFirstResponder()
           TagsTextField.resignFirstResponder()
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
                self.SearchedTags.removeAll()
                
                TagsObjectApi.GetTags(text: string) { TagsObject in
                    self.SearchedTags = TagsObject
                    for Tag in TagsObject {
                        self.dropDown.dataSource.append(Tag.name)
                    }
                    self.dropDown.show()
                }
                
                self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    print("-------\(item)-------")
                    
                    for Tag in self.Tags {
                        if Tag.name == item{
                            return
                        }
                    }
                    
                    
                    for Tag in self.SearchedTags {
                        if Tag.name == item{
                            self.Tags.append(TagsObject(id: Tag.id, name: item))
                        }
                    }
                    
                    
                    self.TagsCollectionView.reloadData()
                    self.TagsTextField.text = ""
                    self.view.endEditing(true)
                    if self.Tags.count != 0{
                        self.TagsHeight.constant = 26
                    }
                    dropDown.hide()
                }
            }
        }
        return true
    }
    

    
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
    @IBAction func Update(_ sender: Any) {
        if CheckInternet.Connection(){
            if self.ProfileName.text?.trimmingCharacters(in: .whitespaces) != "" && self.Name.text?.trimmingCharacters(in: .whitespaces) != "" && self.Bio.text?.trimmingCharacters(in: .whitespaces) != "" && self.Email.text?.trimmingCharacters(in: .whitespaces) != "" && self.Tags.count != 0{
                self.view.endEditing(true)
                loadingView.show(on: view)
                if self.validateEmail(enteredEmail: self.Email.text!) == false{
                    MessageBox.ShowMessage(Text: "ئیمێلێ تە نە یێ دروستە")
                    RSLoadingView.hide(from: self.view)
                    return
                }
                
                
                var tagsId : [Int] = []
                
                for tags in self.Tags {
                    tagsId.append(tags.id)
                }
                
                
                LoginAPi.UpdateInfo(name: self.Name.text!, profile_name: self.ProfileName.text!, bio: self.Bio.text!, email: self.Email.text!, image: self.Image.image ?? UIImage(), tags: tagsId) { Info in
                    RSLoadingView.hide(from: self.view)
                }
            }else{
                RSLoadingView.hide(from: self.view)
                if self.ProfileName.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە ناڤێ پروفایلی بنڤیسە")
                }
                
                if self.Name.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە ناڤێ تەمام بنڤیسە")
                }
                
                if self.Tags.count == 0{
                    MessageBox.ShowMessage(Text: "هیڤیە تا ٥ تاگسان هەلبژێرە")
                }
                
                if self.Bio.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە بایۆ پربکە")
                }
                
                if self.Email.text! == ""{
                    MessageBox.ShowMessage(Text: "هیڤیە ئیمایلی بنڤیسە")
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


extension UpdateProfile : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if self.Tags.count == 0{
                return 0
            }else if self.Tags.count >= 5{
                return 5
            }
            print(self.Tags.count)
            return self.Tags.count
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewcell
        cell.CategoryName.text = "#\(self.Tags[indexPath.row].name)"
        cell.CategoryName.textColor = .black
            cell.SmallView.isHidden = true
            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("----------")
        let text = self.Tags[indexPath.row].name
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
        
        self.Tags.remove(at: indexPath.row)
        self.TagsCollectionView.reloadData()
        
    }
    
}
