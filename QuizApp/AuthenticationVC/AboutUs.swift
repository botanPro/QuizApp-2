//
//  AboutUs.swift
//  QuizApp
//
//  Created by Botan Amedi on 27/09/2024.
//

import UIKit

class AboutUs: UIViewController {
    @IBAction func Dimiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var Dimiss: UIButton!
    @IBOutlet weak var AboutUsText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        QuizObjectApi.get_about { term_condition, about_project, about_us in
            let htmlString = about_us
            if let attributedString = htmlString.htmlToAttributedString {
                self.AboutUsText.attributedText = attributedString
            }
        }
    }
}

extension String {
    // Convert HTML string to NSAttributedString
    var htmlToAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("Error converting HTML to Attributed String:", error)
            return nil
        }
    }
}
