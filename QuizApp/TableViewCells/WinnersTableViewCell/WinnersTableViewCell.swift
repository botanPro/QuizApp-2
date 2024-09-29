//
//  WinnersTableViewCell.swift
//  QuizApp
//
//  Created by Botan Amedi on 25/09/2024.
//

import UIKit

class WinnersTableViewCell: UITableViewCell {

    @IBOutlet weak var Day: UILabel!
    @IBOutlet weak var FirstThreeWinnerView: UIView!
    
    @IBOutlet weak var SecondPicView: UIView!
    @IBOutlet weak var SecondPic: UIImageView!
    @IBOutlet weak var SecondName: UILabel!
    @IBOutlet weak var SecondLevle: UILabel!
    @IBOutlet weak var SecoondStack: UIStackView!
    
    
    @IBOutlet weak var FirstPicView: UIView!
    @IBOutlet weak var FirstPic: UIImageView!
    @IBOutlet weak var FirstName: UILabel!
    @IBOutlet weak var FirstLevel: UILabel!
    @IBOutlet weak var firstStack: UIStackView!
    
    @IBOutlet weak var ThirdPicView: UIView!
    @IBOutlet weak var ThirdPic: UIImageView!
    @IBOutlet weak var ThirdName: UILabel!
    @IBOutlet weak var ThirdLevle: UILabel!
    @IBOutlet weak var ThirsdStack: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.SecoondStack.isHidden = true
        self.firstStack.isHidden = true
        self.ThirsdStack.isHidden = true
   
        
        self.FirstPic.layer.cornerRadius = 10
        self.FirstPicView.layer.cornerRadius = 12
        
        self.SecondPic.layer.cornerRadius = 10
        self.SecondPicView.layer.cornerRadius = 12
        
        self.ThirdPic.layer.cornerRadius = 10
        self.ThirdPicView.layer.cornerRadius = 12
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
