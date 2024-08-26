//
//  LeadBoardVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 02/07/2024.
//

import UIKit

class LeadBoardVC: UIViewController {
    @IBOutlet weak var segmentControl: HBSegmentedControl!
    @IBOutlet weak var WeeklyTableView: UITableView!
    @IBOutlet weak var TodayView: UIView!
    @IBOutlet weak var WeeklyView: UIView!
    @IBOutlet weak var TodayTableView: UITableView!
    
    @IBOutlet weak var FirstThreeWinnerView: UIView!
    
    @IBOutlet weak var SecoundLableView: UIView!
    @IBOutlet weak var FirstLableView: UIView!
    @IBOutlet weak var ThirdLableView: UIView!
    
    @IBOutlet weak var SecondPicView: UIView!
    @IBOutlet weak var SecondPic: UIImageView!
    
    
    @IBOutlet weak var FirstPicView: UIView!
    @IBOutlet weak var FirstPic: UIImageView!
    
    @IBOutlet weak var ThirdPicView: UIView!
    @IBOutlet weak var ThirdPic: UIImageView!
    
    var TodayArray : [HistoryObject] = []
    var WeeklyArray : [HistoryObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.items = ["Today","Weekly"]
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
        
        
        self.SecoundLableView.layer.cornerRadius = self.SecoundLableView.bounds.width / 2
        self.FirstLableView.layer.cornerRadius = self.FirstLableView.bounds.width / 2
        self.ThirdLableView.layer.cornerRadius = self.ThirdLableView.bounds.width / 2
        
        
        self.FirstPic.layer.cornerRadius = 11
        self.FirstPicView.layer.cornerRadius = 13
        
        self.SecondPic.layer.cornerRadius = 11
        self.SecondPicView.layer.cornerRadius = 13
        
        self.ThirdPic.layer.cornerRadius = 11
        self.ThirdPicView.layer.cornerRadius = 13
        
        segmentControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
        WeeklyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        TodayTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        
        
        TodayArray.append(HistoryObject(id: "1", title: "Ali Ahmad", date: "", levle: "101"))
        TodayArray.append(HistoryObject(id: "2", title: "Kareem Kazm", date: "", levle: "203"))
        TodayArray.append(HistoryObject(id: "3", title: "John Cina", date: "", levle: "58"))
        TodayArray.append(HistoryObject(id: "4", title: "Baran Mohammad", date: "", levle: "95"))
        self.TodayTableView.reloadData()
        
        
        WeeklyArray.append(HistoryObject(id: "1", title: "Ali Ahmad", date: "12/4", levle: "0"))
        WeeklyArray.append(HistoryObject(id: "2", title: "Kareem Kazm", date: "23/4", levle: "0"))
        WeeklyArray.append(HistoryObject(id: "3", title: "John Cina", date: "27/4", levle: "0"))
        WeeklyArray.append(HistoryObject(id: "4", title: "Baran Mohammad", date: "30/4", levle: "0"))
        self.TodayTableView.reloadData()
        
    }
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            if self.WeeklyArray.count == 0{
                return 0
            }
            
            return self.WeeklyArray.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell
        if tableView == self.TodayTableView{
            cell.Number.text = self.TodayArray[indexPath.row].id
            cell.Titlee.text = self.TodayArray[indexPath.row].title
            cell.Date.text = "Lv\(self.TodayArray[indexPath.row].level)"
        }
        
        if tableView == self.WeeklyTableView{
            cell.Number.text = self.WeeklyArray[indexPath.row].id
            cell.Titlee.text = self.WeeklyArray[indexPath.row].title
            cell.Date.text = self.WeeklyArray[indexPath.row].date
        }
        return  cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("]]]]]]")
        if tableView == self.WeeklyTableView{
            print("]]]]]]")
            self.performSegue(withIdentifier: "GoToHostory", sender: nil)
        }
    }
    
}







class HistoryObject{
    var id = ""
    var title = ""
    var date = ""
    var level = ""
    
    init(id: String, title: String, date: String, levle: String) {
        self.id = id
        self.title = title
        self.date = date
        self.level = levle
    }
}
