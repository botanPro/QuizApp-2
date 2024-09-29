//
//  termsAndCondition.swift
//  QuizApp
//
//  Created by Botan Amedi on 27/09/2024.
//

import UIKit

class termsAndCondition: UIViewController {

    @IBAction func Dimiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var TermsAndConditionsText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        QuizObjectApi.get_about { term_condition, about_project, about_us in
            let htmlString = term_condition
            if let attributedString = htmlString.htmlToAttributedString {
                self.TermsAndConditionsText.attributedText = attributedString
            }
        }
    }
    
    

}
