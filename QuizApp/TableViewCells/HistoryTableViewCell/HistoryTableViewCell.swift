//
//  HistoryTableViewCell.swift
//  QuizApp
//
//  Created by Botan Amedi on 02/07/2024.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var Number: UILabel!
    @IBOutlet weak var Titlee: UILabel!
    @IBOutlet weak var Date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
