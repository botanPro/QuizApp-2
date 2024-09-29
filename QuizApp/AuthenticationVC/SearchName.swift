//
//  SearchName.swift
//  QuizApp
//
//  Created by Botan Amedi on 28/09/2024.
//

import UIKit
import EFInternetIndicator
class SearchName: UIViewController , UITextFieldDelegate, InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?

    @IBOutlet weak var SearchView: UIView!
    @IBOutlet weak var TableVieew: UITableView!
    @IBOutlet weak var Searchtext: UITextField!
    @IBAction func Dimiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    var Profiles : [ProfileData] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        SearchView.layer.shadowColor = UIColor.lightGray.cgColor
        SearchView.layer.shadowOpacity = 0.3
        SearchView.layer.shadowOffset = CGSize.zero
        SearchView.layer.shadowRadius = 16
        self.Searchtext.delegate = self
        
        TableVieew.register(UINib(nibName: "SearchByTagsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Searchtext.becomeFirstResponder()
    }
    
    lazy var workItem = WorkItem()
    var IsSearched : Bool = false
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if CheckInternet.Connection(){
            if textField.text! == "" {
                self.Profiles.removeAll()
                self.TableVieew.reloadData()
            }else{
                self.IsSearched = true
                self.workItem.perform(after: 0.3) {
                    self.Profiles.removeAll()
                    self.GetProfileById(text: textField.text!)
                }
            }
        }else{
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }
        return true
    }
    
    func addDoneButtonOnKeyboard() {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))

        toolbar.setItems([flexSpace, done], animated: false)
        toolbar.isUserInteractionEnabled = true

        Searchtext.inputAccessoryView = toolbar
    }
    
    
    @objc func doneButtonAction() {
        Searchtext.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func GetProfileById(text: String){
        QuizObjectApi.profile_serach(text: text) { profiles in
            self.Profiles = profiles
            self.TableVieew.reloadData()
        }
    }


}


extension SearchName : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.Profiles.count == 0{
            self.TableVieew.setEmptyView(title: "", message: "هیچ پرەفایلەک نەهاتە دیتن.")
                return 0
            }
        self.TableVieew.setEmptyView(title: "", message: "")
        return self.Profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchByTagsTableViewCell
        cell.Name.text = self.Profiles[indexPath.row].name
        var Tags : [TagsObject] = []
        
        for (id, name) in self.Profiles[indexPath.row].tags {
            Tags.append(TagsObject(id: id, name: name))
        }
        cell.Tags.text = ""
        for tag in Tags {
            cell.Tags.text?.append(" #\(tag.name)")
        }
        
        if let imageUrl = URL(string: self.Profiles[indexPath.row].image) {
            cell.Imagee.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "account-avatar-profile-user-svgrepo-com"))
        }else{
            cell.Imagee.image = UIImage(named: "account-avatar-profile-user-svgrepo-com")
        }
        
        return cell
    }
    


    
    
}
