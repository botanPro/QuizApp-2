//
//  LeadBoardVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 02/07/2024.
//

import UIKit
import EFInternetIndicator
class LeadBoardVC: UIViewController , InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?
    @IBOutlet weak var segmentControl: HBSegmentedControl!
    @IBOutlet weak var WeeklyTableView: UITableView!
    @IBOutlet weak var TodayView: UIView!
    @IBOutlet weak var WeeklyView: UIView!
    @IBOutlet weak var TodayTableView: UITableView!
    
    @IBOutlet weak var FirstThreeWinnerView: UIView!
    @IBOutlet weak var FirstThreeWinnerViewHeight: NSLayoutConstraint!
    

    

    
    @IBOutlet weak var SecondPicView: UIView!
    @IBOutlet weak var SecondPic: UIImageView!
    @IBOutlet weak var SecondName: UILabel!
    @IBOutlet weak var SecondLevle: UILabel!
    @IBOutlet weak var SecondStack: UIStackView!
    
    
    @IBOutlet weak var FirstPicView: UIView!
    @IBOutlet weak var FisrtName: UILabel!
    @IBOutlet weak var FirstPic: UIImageView!
    @IBOutlet weak var FirstLevle: UILabel!
    @IBOutlet weak var FirstStack: UIStackView!
    
    @IBOutlet weak var ThirdPicView: UIView!
    @IBOutlet weak var ThirdPic: UIImageView!
    @IBOutlet weak var ThirdStack: UIStackView!
    @IBOutlet weak var ThirdName: UILabel!
    @IBOutlet weak var ThirdLevle: UILabel!
    
  
    
    var TodayArray : [Winner] = []
    var WeeklyArrayCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.items = ["دوماهیک سەرکەفتی","حەفتیانە"]
        segmentControl.borderColor = UIColor(white: 1.0, alpha: 0.3)
        segmentControl.padding = 4
        segmentControl.selectedLabelColor = .black
        segmentControl.unselectedLabelColor = .black
        segmentControl.backgroundColor = #colorLiteral(red: 0.7372247577, green: 0.7245759368, blue: 0.7642329335, alpha: 1)
        segmentControl.thumbColor = .white
        segmentControl.selectedIndex = 0
        
        
        FirstThreeWinnerView.layer.shadowColor = UIColor.lightGray.cgColor
        FirstThreeWinnerView.layer.shadowOpacity = 0.3
        FirstThreeWinnerView.layer.shadowOffset = CGSize.zero
        FirstThreeWinnerView.layer.shadowRadius = 16
        

        self.FirstPic.layer.cornerRadius = 11
        self.FirstPicView.layer.cornerRadius = 13
        
        self.SecondPic.layer.cornerRadius = 11
        self.SecondPicView.layer.cornerRadius = 13
        
        self.ThirdPic.layer.cornerRadius = 11
        self.ThirdPicView.layer.cornerRadius = 13
        
        segmentControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
        WeeklyTableView.register(UINib(nibName: "WinnersTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        TodayTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        
        
        
        self.ThirdStack.isHidden = true
        self.SecondStack.isHidden = true
        self.FirstStack.isHidden = true
        
        if CheckInternet.Connection(){
            
            
            QuizObjectApi.get_last_quiz_winner { Winner, others in
                
                
                if others.count != 0{
                    self.TodayArray = others
                }
                
                
                if Winner.count != 0{
                    UIView.animate(withDuration: 0.1) {
                        if Winner.count == 3{
                            self.SecondStack.isHidden = true
                            self.FirstStack.isHidden = true
                            self.ThirdStack.isHidden = true
                            if let imageUrl = URL(string: Winner[0].image) {
                                self.FirstPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                            }else{
                                self.FirstPic.image = UIImage(named: "account-avatar-profile-user-svgrepo-com")
                            }
                            self.FirstLevle.text = "ئاستێ \(Winner[0].level)"
                            self.FisrtName.text = Winner[0].name
                            
                            if let imageUrl = URL(string: Winner[1].image) {
                                self.SecondPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                            }else{
                                self.SecondPic.image = UIImage(named: "account-avatar-profile-user-svgrepo-com")
                            }
                            self.SecondLevle.text = "ئاستێ \(Winner[1].level)"
                            self.SecondName.text = Winner[1].name
                            
                            if let imageUrl = URL(string: Winner[2].image) {
                                self.ThirdPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                            }else{
                                self.ThirdPic.image = UIImage(named: "account-avatar-profile-user-svgrepo-com")
                            }
                            self.ThirdLevle.text = "ئاستێ \(Winner[2].level)"
                            self.ThirdName.text = Winner[2].name
                        }else if Winner.count == 2{
                            self.SecondStack.isHidden = false
                            self.FirstStack.isHidden = false
                            if let imageUrl = URL(string: Winner[0].image) {
                                self.FirstPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                            }else{
                                self.FirstPic.image = UIImage(named: "account-avatar-profile-user-svgrepo-com")
                            }
                            self.FirstLevle.text = "ئاستێ \(Winner[0].level)"
                            self.FisrtName.text = Winner[0].name
                            
                            if let imageUrl = URL(string: Winner[1].image) {
                                self.SecondPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                            }else{
                                self.SecondPic.image = UIImage(named: "account-avatar-profile-user-svgrepo-com")
                            }
                            self.SecondLevle.text = "ئاستێ \(Winner[1].level)"
                            self.SecondName.text = Winner[1].name
                        }else{
                            self.FirstStack.isHidden = false
                            self.FirstThreeWinnerViewHeight.constant = 250
                            if let imageUrl = URL(string: Winner[0].image) {
                                self.FirstPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                            }else{
                                self.FirstPic.image = UIImage(named: "account-avatar-profile-user-svgrepo-com")
                            }
                            self.FirstLevle.text = "ئاستێ \(Winner[0].level)"
                            self.FisrtName.text = Winner[0].name
                        }
                        self.view.layoutIfNeeded()
                    }
                }
                
                
            }
            
            
        }else{
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }
    }
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var satrdayZero = false
    var sundayyZero = false
    var mondayZero = false
    var tuesdayZero = false
    var wednesdayZero = false
    var thursdayZero = false
    var fridayZero = false
    
    var satrdayArray : [Winner] = []
    var sundayArray : [Winner] = []
    var mondayArray : [Winner] = []
    var tuesdayArray : [Winner] = []
    var wednesdayArray : [Winner] = []
    var thursdayArray : [Winner] = []
    var fridayArray : [Winner] = []
    
    var WeeklyArray : [[Winner]] = []
    
    func GetWeeklyWinners(){
        self.WeeklyArray.removeAll()
        QuizObjectApi.get_week_quiz_winner { satrday, sunday, monday, tuesday, wednesday, thursday, friday in
          
            if sunday.count != 0{print("----77")
                self.WeeklyArray.append(sunday)
            }
            if satrday.count != 0{print("----44")
                self.WeeklyArray.append(satrday)
            }
            if monday.count != 0{
                self.WeeklyArray.append(monday)
            }
            if tuesday.count != 0{print("----33")
                self.WeeklyArray.append(tuesday)
            }
            if wednesday.count != 0{print("----111")
                self.WeeklyArray.append(wednesday)
            }
            if thursday.count != 0{print("----99")
                self.WeeklyArray.append(thursday)
            }
            if friday.count != 0{print("----222")
                self.WeeklyArray.append(friday)
            }
            
            
            for i in self.WeeklyArray{
                for j in i{
                    print(j.name)
                }
            }
            
            
            self.WeeklyTableView.reloadData()
            
        }
    }
    
    
    
    @objc func segmentValueChanged(_ sender: AnyObject?){
        
        if segmentControl.selectedIndex == 0 {
            print(segmentControl.selectedIndex)
            
            UIView.animate(withDuration: 0.2) {
                self.TodayView.isHidden = false
                self.WeeklyView.isHidden = true
            }

           
        }else if segmentControl.selectedIndex == 1{
            print(segmentControl.selectedIndex)
            UIView.animate(withDuration: 0.2) {
                self.TodayView.isHidden = true
                self.WeeklyView.isHidden = false
                self.GetWeeklyWinners()
            }
            
        }
    }
    

}

extension LeadBoardVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.TodayTableView{
            if self.TodayArray.count == 0{
                return 0
            }
            
            return self.TodayArray.count
        }
        
        if tableView == self.WeeklyTableView{
            if self.WeeklyArray.count == 0{print("------------------=====")
                return 0
            }
            print("------------------444444444  \(self.WeeklyArrayCount)")
            return self.WeeklyArray.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        if tableView == self.TodayTableView{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell
            cell.Titlee.text = self.TodayArray[indexPath.row].name
            cell.Date.text = "ئاستێ \(self.TodayArray[indexPath.row].level)"
            return  cell
        }else{
            if WeeklyArray.count != 0{print("=======000009999    \(WeeklyArray.count)")
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WinnersTableViewCell
            var wins : [Winner] = []
                wins = WeeklyArray[indexPath.row]
                
                if wins.count == 3{
                    cell.Day.text = wins[0].date
                    if let imageUrl = URL(string: wins[0].image) {
                        cell.FirstPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                    }
                    cell.FirstLevel.text = "ئاستێ \(wins[0].level)"
                    cell.FirstName.text = wins[0].name
                    
                    if let imageUrl = URL(string: wins[1].image) {
                        cell.SecondPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                    }
                    cell.SecondLevle.text = "ئاستێ \(wins[1].level)"
                    cell.SecondName.text = wins[1].name
                    
                    if let imageUrl = URL(string: wins[2].image) {
                        cell.ThirdPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                    }
                    cell.ThirdLevle.text = "ئاستێ \(wins[2].level)"
                    cell.ThirdName.text = wins[2].name
                }else if wins.count == 2{
                    cell.Day.text = wins[0].date
                    cell.SecoondStack.isHidden = false
                    cell.firstStack.isHidden = false
                    if let imageUrl = URL(string: wins[0].image) {
                        self.FirstPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                    }
                    cell.FirstLevel.text = "ئاستێ \(wins[0].level)"
                    cell.FirstName.text = wins[0].name
                    
                    if let imageUrl = URL(string: wins[1].image) {
                        cell.SecondPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                    }
                    cell.SecondLevle.text = "ئاستێ \(wins[1].level)"
                    cell.SecondName.text = wins[1].name
                }else{
                    cell.Day.text = wins[0].date
                    cell.firstStack.isHidden = false
                    if let imageUrl = URL(string: wins[0].image) {
                        cell.FirstPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                    }
                    cell.FirstLevel.text = "ئاستێ \(wins[0].level)"
                    cell.FirstName.text = wins[0].name
                }
                
                return  cell
            }
        }
        return UITableViewCell()
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var wins : [Winner] = []
        wins = WeeklyArray[indexPath.row]
            
        if wins.count == 3{
            return 175
        }else if wins.count == 2{
            return 130
        }else{
            return 90
        }
    }
    
    
}







