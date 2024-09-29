//
//  HistoryDateVc.swift
//  QuizApp
//
//  Created by Botan Amedi on 02/07/2024.
//

import UIKit

class HistoryDateVc: UIViewController {
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var SecoundLableView: UIView!
    @IBOutlet weak var FirstLableView: UIView!
    @IBOutlet weak var ThirdLableView: UIView!
    
    @IBOutlet weak var SecondPicView: UIView!
    @IBOutlet weak var SecondPic: UIImageView!
    
    
    @IBOutlet weak var FirstPicView: UIView!
    @IBOutlet weak var FirstPic: UIImageView!
    
    @IBOutlet weak var ThirdPicView: UIView!
    @IBOutlet weak var ThirdPic: UIImageView!
    
    
    @IBOutlet weak var FirstThreeWinnerView: UIView!
    
    
    var TodayArray : [Winner] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SecoundLableView.layer.cornerRadius = self.SecoundLableView.bounds.width / 2
        self.FirstLableView.layer.cornerRadius = self.FirstLableView.bounds.width / 2
        self.ThirdLableView.layer.cornerRadius = self.ThirdLableView.bounds.width / 2
        
        
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
        
        TableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        
    
        self.TableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 
}



extension HistoryDateVc : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            if self.TodayArray.count == 0{
                return 0
            }
            
            return self.TodayArray.count

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell

//            cell.Number.text = self.TodayArray[indexPath.row].id
//            cell.Titlee.text = self.TodayArray[indexPath.row].title
//            cell.Date.text = "Lv\(self.TodayArray[indexPath.row].level)"
        
        

        return  cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}



