//
//  SearchByTagsTableViewCell.swift
//  QuizApp
//
//  Created by Botan Amedi on 28/09/2024.
//

import UIKit

class SearchByTagsTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageVieww: UIView!
    @IBOutlet weak var Imagee: UIImageView!
    @IBOutlet weak var ContainerVieww: UIView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Tags: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
