//
//  HomeVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 29/06/2024.
//

import UIKit
import AVFoundation
import AudioToolbox
class HomeVC: UIViewController {
    @IBOutlet weak var SecoundLableView: UIView!
    @IBOutlet weak var FirstLableView: UIView!
    @IBOutlet weak var ThirdLableView: UIView!
    @IBOutlet weak var FirstThreeWinnerView: UIView!
    
    @IBOutlet weak var MyPicView: UIView!
    @IBOutlet weak var MyPic: UIImageView!
    
    @IBOutlet weak var JoinButtonView: UIView!
    @IBOutlet weak var JoinButton: UIImageView!
    
    
    @IBOutlet weak var SecondPicView: UIView!
    @IBOutlet weak var SecondPic: UIImageView!
    
    
    @IBOutlet weak var FirstPicView: UIView!
    @IBOutlet weak var FirstPic: UIImageView!
    
    @IBOutlet weak var ThirdPicView: UIView!
    @IBOutlet weak var ThirdPic: UIImageView!
    @IBOutlet weak var SearchView: UIView!
    
    @IBOutlet weak var TodaysRoomView: UIView!
    var IsFirst = false
    @IBOutlet weak var TagsCollectionView: UICollectionView!
    var TagsArray : [TagsObject] = []
    var selectedCategory : TagsObject?
    var audioPlayer = AVAudioPlayer()
    var SearchTextField = UISearchBar()
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 25.0, bottom: 0.0, right: 25.0)
    var numberOfItemsPerRow: CGFloat = 5
    let spacingBetweenCells: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JoinButton.applyshadowWithCorner(containerView: JoinButtonView, cornerRadious: 20)
    
        FirstThreeWinnerView.layer.shadowColor = UIColor.lightGray.cgColor
        FirstThreeWinnerView.layer.shadowOpacity = 0.3
        FirstThreeWinnerView.layer.shadowOffset = CGSize.zero
        FirstThreeWinnerView.layer.shadowRadius = 16
        
        TodaysRoomView.layer.shadowColor = UIColor.lightGray.cgColor
        TodaysRoomView.layer.shadowOpacity = 0.3
        TodaysRoomView.layer.shadowOffset = CGSize.zero
        TodaysRoomView.layer.shadowRadius = 12
        
        SearchView.layer.shadowColor = UIColor.lightGray.cgColor
        SearchView.layer.shadowOpacity = 0.3
        SearchView.layer.shadowOffset = CGSize.zero
        SearchView.layer.shadowRadius = 16
        
        self.SecoundLableView.layer.cornerRadius = self.SecoundLableView.bounds.width / 2
        self.FirstLableView.layer.cornerRadius = self.FirstLableView.bounds.width / 2
        self.ThirdLableView.layer.cornerRadius = self.ThirdLableView.bounds.width / 2
        
        
        
        self.MyPic.layer.cornerRadius = self.MyPic.bounds.width / 2
        self.MyPicView.layer.cornerRadius = self.MyPicView.bounds.width / 2
        
        self.FirstPic.layer.cornerRadius = 11
        self.FirstPicView.layer.cornerRadius = 13
        
        self.SecondPic.layer.cornerRadius = 11
        self.SecondPicView.layer.cornerRadius = 13
        
        self.ThirdPic.layer.cornerRadius = 11
        self.ThirdPicView.layer.cornerRadius = 13
        
        
        TagsCollectionView.register(UINib(nibName: "CategoryCollectionViewcell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        TagsArray.append(TagsObject(id: 1, tag: "#Hot"))
        TagsArray.append(TagsObject(id: 2, tag: "#Kids"))
        TagsArray.append(TagsObject(id: 3, tag: "#Man"))
        TagsArray.append(TagsObject(id: 4, tag: "#Women"))
        TagsArray.append(TagsObject(id: 5, tag: "#Famlly Mall"))
        TagsArray.append(TagsObject(id: 6, tag: "#Office"))
        TagsArray.append(TagsObject(id: 7, tag: "#Duhok Mall"))
        TagsArray.append(TagsObject(id: 8, tag: "#Maxi Mall"))
        self.TagsCollectionView.reloadData()
    }
    


}




extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if self.TagsArray.count == 0{
                return 0
            }
            return self.TagsArray.count
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.TagsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewcell
            cell.CategoryName.text = self.TagsArray[indexPath.row].tag
            
           
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
        }

       
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.TagsCollectionView{
            let text = self.TagsArray[indexPath.row].tag
             let width = self.estimatedFrame(text: text, font: UIFont.systemFont(ofSize: 14)).width
             return CGSize(width: width + 8, height: 25)
         }
      
        return CGSize(width: 0, height: 0)
        
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
        
        if collectionView == self.TagsCollectionView{
            self.IsFirst = true
            self.selectedCategory = self.TagsArray[indexPath.row]
            self.TagsCollectionView.reloadData()
        }
    }
    
}
