//
//  CategoryCollectionViewcell.swift
//  Discount
//
//  Created by botan pro on 6/16/21.
//

import UIKit

class CategoryCollectionViewcell: UICollectionViewCell {

    @IBOutlet weak var SmallView: UIView!
    @IBOutlet weak var CategoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.SmallView.layer.cornerRadius = 2
    }

}
