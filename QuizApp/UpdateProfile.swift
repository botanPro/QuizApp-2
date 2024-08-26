//
//  UpdateProfile.swift
//  QuizApp
//
//  Created by Botan Amedi on 19/07/2024.
//

import UIKit

class UpdateProfile: UIViewController , UITextViewDelegate{

    @IBOutlet weak var Bio: UITextView!
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "بایو"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Bio.delegate = self
        Bio.text = "بایو"
        Bio.textColor = UIColor.lightGray
    }
 

}
