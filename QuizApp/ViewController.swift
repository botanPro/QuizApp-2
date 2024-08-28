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
        print(UserDefaults.standard.string(forKey: "login") ?? "")
        if UserDefaults.standard.string(forKey: "login") != "true"{
            self.performSegue(withIdentifier: "ChooseWayToLoginVC", sender: nil)
        }else{
            self.performSegue(withIdentifier: "HomeVc", sender: nil)
        }
    }
}
