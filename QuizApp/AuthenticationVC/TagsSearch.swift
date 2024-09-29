//
//  TagsSearch.swift
//  QuizApp
//
//  Created by Botan Amedi on 28/09/2024.
//

import UIKit

class TagsSearch: UIViewController {

    
    
    var titlee = ""
    var tag_id = 0
    
    
    
    @IBOutlet weak var TableVieew: UITableView!
    @IBOutlet weak var PageTitle: UILabel!
    @IBAction func Dimiss(_ sender: Any) {
        self.dismiss(animated: true)
    }

    var Profiles : [ProfileData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        TableVieew.register(UINib(nibName: "SearchByTagsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        self.PageTitle.text = titlee
        GettagsById(id: tag_id)
    }
    
    
    func GettagsById(id: Int){
        QuizObjectApi.profile_serach_by_tag(tag_id: id) { profiles in
            self.Profiles = profiles
            self.TableVieew.reloadData()
        }
    }
    


}


extension TagsSearch : UITableViewDelegate , UITableViewDataSource{
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



extension UITableView {
func setEmptyView(title: String, message: String) {
    let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = UIColor.black
    titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
    messageLabel.textColor = UIColor.lightGray
    messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
    emptyView.addSubview(titleLabel)
    emptyView.addSubview(messageLabel)
    titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
    messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -100).isActive = true
    messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
    messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
    titleLabel.text = title
    messageLabel.text = message
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    // The only tricky part is here:
    self.backgroundView = emptyView
}
    
    func restore() {
        self.backgroundView = nil
    }
}
