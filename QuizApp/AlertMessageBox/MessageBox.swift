//
//  MessageBox.swift
//  BarDast
//
//  Created by Botan Amedi on 4/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit


class MessageBoxVC : UIViewController{
    
    var Text : String?
    
    
    @IBOutlet weak var Message : UILabel!
    
    @IBAction func Done(_ sender : UIButton){
        dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hata viewdidload daaaa")
        self.Message.text = Text
    }
    
}

class MessageBox {
       
    static func ShowMessage(Text: String){
        let StoryBoard = UIStoryboard(name: "MessageBox", bundle: nil)
        let vc = StoryBoard.instantiateViewController(withIdentifier:"MessageBox") as! MessageBoxVC
        vc.Text = Text
        print(Text)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        UIApplication.GetPresentviewController()?.present(vc, animated: true, completion: nil)
    }

}

extension UIApplication{
    
    static func GetPresentviewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.windows.first?.rootViewController
        while let pVc = presentViewController?.presentedViewController {
            
              presentViewController = pVc
        }
        return presentViewController
    }

}
