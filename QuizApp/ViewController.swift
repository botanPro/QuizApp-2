//
//  ViewController.swift
//  QuizApp
//
//  Created by Botan Amedi on 23/06/2024.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.performSegue(withIdentifier: "ChooseWayToLoginVC", sender: nil)
     }
}
