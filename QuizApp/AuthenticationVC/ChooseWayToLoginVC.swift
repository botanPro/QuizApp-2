//
//  ChooseWayToLoginVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 29/06/2024.
//

import UIKit

class ChooseWayToLoginVC: UIViewController {
    @IBOutlet weak var ContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        ContainerView.layer.shadowOpacity = 0.3
        ContainerView.layer.shadowOffset = CGSize.zero
        ContainerView.layer.shadowRadius = 20
    }
    


}
