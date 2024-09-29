//
//  HomeVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 29/06/2024.
//

import UIKit
import AVFoundation
import AudioToolbox
import SDWebImage
import EFInternetIndicator
import CRRefresh
import RSLoadingView
class HomeVC: UIViewController , InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?
    @IBOutlet weak var FirstThreeWinnerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var FirstThreeWinnerView: UIView!
    @IBOutlet weak var FirstWinnersStack: UIStackView!
    @IBOutlet weak var FirstWinnersStackTop: NSLayoutConstraint!
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Phone: UILabel!
    @IBOutlet weak var MyPicView: UIView!
    @IBOutlet weak var MyPic: UIImageView!

    
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
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    
    
    @IBOutlet weak var SearchView: UIView!
    
    @IBOutlet weak var QuizCollectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var QuizCollectionView: UICollectionView!
    var IsFirst = false
    @IBOutlet weak var TagsCollectionView: UICollectionView!
    var TagsArray : [TagsObject] = []
    var QuizArray : [QuizObject] = []
    var selectedCategory : TagsObject?
    var audioPlayer = AVAudioPlayer()
    var SearchTextField = UISearchBar()
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 25.0, bottom: 0.0, right: 25.0)
    var numberOfItemsPerRow: CGFloat = 5
    let spacingBetweenCells: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        if CheckInternet.Connection(){
            GetTags()
            GetAllData()
            
            self.ScrollView.cr.addHeadRefresh(animator:  FastAnimator(), handler: {
                self.GetTags()
                self.GetAllData()
            })
            

            
            FirstThreeWinnerView.layer.shadowColor = UIColor.lightGray.cgColor
            FirstThreeWinnerView.layer.shadowOpacity = 0.3
            FirstThreeWinnerView.layer.shadowOffset = CGSize.zero
            FirstThreeWinnerView.layer.shadowRadius = 16
            
//            TodaysRoomView.layer.shadowColor = UIColor.lightGray.cgColor
//            TodaysRoomView.layer.shadowOpacity = 0.3
//            TodaysRoomView.layer.shadowOffset = CGSize.zero
//            TodaysRoomView.layer.shadowRadius = 12
//            
            SearchView.layer.shadowColor = UIColor.lightGray.cgColor
            SearchView.layer.shadowOpacity = 0.3
            SearchView.layer.shadowOffset = CGSize.zero
            SearchView.layer.shadowRadius = 16

            
            self.MyPic.layer.cornerRadius = self.MyPic.bounds.width / 2
            self.MyPicView.layer.cornerRadius = self.MyPicView.bounds.width / 2
            
            self.FirstPic.layer.cornerRadius = 11
            self.FirstPicView.layer.cornerRadius = 13
            
            self.SecondPic.layer.cornerRadius = 11
            self.SecondPicView.layer.cornerRadius = 13
            
            self.ThirdPic.layer.cornerRadius = 11
            self.ThirdPicView.layer.cornerRadius = 13
            
            
            TagsCollectionView.register(UINib(nibName: "CategoryCollectionViewcell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
            QuizCollectionView.register(UINib(nibName: "QuizCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "QuizCell")

           
            
            
        }else{
            RSLoadingView.hide(from: self.view)
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }
    }
    
    @IBOutlet weak var EmptyQuizStack: UIStackView!
    
    
    let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
    func GetAllData(){
        loadingView.show(on: view)

        self.ThirdStack.isHidden = true
        self.SecondStack.isHidden = true
        self.FirstStack.isHidden = true
        self.FirstWinnersStack.isHidden = true
        self.FirstWinnersStackTop.constant = 0
        
        QuizObjectApi.get_last_quiz_winner { Winner, others in
            RSLoadingView.hide(from: self.view)
            if Winner.count != 0{
                    self.FirstWinnersStack.isHidden = false
                    self.FirstWinnersStackTop.constant = 16
                    if Winner.count == 3{
                        self.SecondStack.isHidden = false
                        self.FirstStack.isHidden = false
                        self.ThirdStack.isHidden = false
                        self.FirstThreeWinnerViewHeight.constant = 165
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
                        self.FirstThreeWinnerViewHeight.constant = 200
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
                        self.FirstThreeWinnerViewHeight.constant = 220
                        if let imageUrl = URL(string: Winner[0].image) {
                            self.FirstPic.sd_setImage(with: imageUrl, placeholderImage: UIImage())
                        }else{
                            self.FirstPic.image = UIImage(named: "account-avatar-profile-user-svgrepo-com")
                        }
                        self.FirstLevle.text = "ئاستێ \(Winner[0].level)"
                        self.FisrtName.text = Winner[0].name
                    }
            }else{
                RSLoadingView.hide(from: self.view)
            }
            self.ScrollView.cr.endHeaderRefresh()
        }
        
        
        
        
        QuizObjectApi.GetQuizs { quizs in
            RSLoadingView.hide(from: self.view)
            self.QuizArray.removeAll()
            self.QuizArray = quizs
            self.QuizCollectionView.reloadData()
            self.ScrollView.cr.endHeaderRefresh()
        }
        
        
        LoginAPi.GetProfileInfo { info in
            RSLoadingView.hide(from: self.view)
            for (id, name) in info.tags {
                print("ID: \(id) - Name: \(name)")
            }
            
            if let imageUrl = URL(string: info.image) {
                self.MyPic.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "account-avatar-profile-user-svgrepo-com"))
            }else{
                self.MyPic.image = UIImage(named: "account-avatar-profile-user-svgrepo-com")
            }
            
            self.Name.text = info.fullname
            self.Phone.text = info.phone
            
        }
        
        self.ScrollView.cr.endHeaderRefresh()
        
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2) {
                let height = self.QuizCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.QuizCollectionHeight.constant = height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func GetTags(){
        RSLoadingView.hide(from: self.view)
        self.TagsArray.removeAll()
        TagsObjectApi.GetAllTags { TagsObject in
            self.TagsArray = TagsObject
            self.TagsCollectionView.reloadData()
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let quiz = sender as? QuizObject{
            if let next = segue.destination as? ConditionVC{
                next.quizInfo = quiz
            }
        }
    }


}




extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.TagsCollectionView{
            if self.TagsArray.count == 0{
                return 0
            }
            return self.TagsArray.count
        }else{
            if self.QuizArray.count == 0{
                self.EmptyQuizStack.isHidden = false
                return 0
            }
            
            self.EmptyQuizStack.isHidden = true
            return self.QuizArray.count
        }
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.TagsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewcell
            cell.CategoryName.text = "#\(self.TagsArray[indexPath.row].name)"
            
           
            if self.selectedCategory?.id == self.TagsArray[indexPath.row].id{
                    cell.SmallView.isHidden = false
                    cell.CategoryName.textColor = .black
                    cell.CategoryName.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
                    cell.contentView.layoutIfNeeded()
                
            }else{
                    cell.SmallView.isHidden = true
                    cell.CategoryName.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                    cell.CategoryName.textColor = #colorLiteral(red: 0.3705137372, green: 0.4450614452, blue: 0.5018000007, alpha: 1)
                    cell.contentView.layoutIfNeeded()
                
            }
            if indexPath.row == 0 && self.IsFirst == false{
                cell.SmallView.isHidden = false
                cell.CategoryName.textColor = .black
                cell.CategoryName.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizCell", for: indexPath) as! QuizCollectionViewCell
            cell.Titlee.text = self.QuizArray[indexPath.row].title
            cell.Timee.text = self.QuizArray[indexPath.row].start_time
            cell.Desc.text = self.QuizArray[indexPath.row].description
            cell.Gift.text = "\(self.QuizArray[indexPath.row].gift_name)/\(self.QuizArray[indexPath.row].gift_winners)"
            if let imageUrl = URL(string: QuizArray[indexPath.row].imagee) {
                cell.Imagee.sd_setImage(with: imageUrl, placeholderImage: UIImage())
            }
            return cell
        }

       

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.TagsCollectionView{
            let text = self.TagsArray[indexPath.row].name
             let width = self.estimatedFrame(text: text, font: UIFont.systemFont(ofSize: 14)).width
             return CGSize(width: width + 20, height: 25)
        }else{
            return CGSize(width: collectionView.layer.bounds.width, height: 266)
        }
        
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
         if collectionView == self.TagsCollectionView{
             return sectionInsets
         }else{
             return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
         }
        
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         if collectionView == self.TagsCollectionView{
             return spacingBetweenCells
         }else{
             return 10
         }
     }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.TagsCollectionView{
            if self.TagsArray.count != 0 && indexPath.row <= self.TagsArray.count{
                let soundURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "note11", ofType: "mp3")!)
                
                do{
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL as URL)
                    
                }catch {
                    print("there was some error. The error was \(error)")
                }
                audioPlayer.play()
                AudioServicesPlaySystemSound(1519)
                
                self.IsFirst = true
                self.selectedCategory = self.TagsArray[indexPath.row]
                self.TagsCollectionView.reloadData()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "TagsSearch") as! TagsSearch
                myVC.modalPresentationStyle = .overFullScreen
                myVC.tag_id = self.TagsArray[indexPath.row].id
                myVC.titlee = self.TagsArray[indexPath.row].name
                self.present(myVC, animated: true)
                
            }
        }else{
            if self.QuizArray.count != 0 && indexPath.row <= self.QuizArray.count{
                self.performSegue(withIdentifier: "GotoQuizInfo", sender: QuizArray[indexPath.row])
            }
        }
    }
    
}
