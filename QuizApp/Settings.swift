//
//  Settings.swift
//  QuizApp
//
//  Created by Botan Amedi on 19/07/2024.
//

import UIKit

class Settings: UIViewController {

    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var NotificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        // Do any additional setup after loading the view.
    }


}
