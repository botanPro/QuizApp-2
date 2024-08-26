//
//  ConditionVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 22/07/2024.
//

import UIKit
import YoutubePlayer_in_WKWebView

class ConditionVC: UIViewController ,WKYTPlayerViewDelegate{
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        Video.stopVideo()
    }
    override func viewDidDisappear(_ animated: Bool) {
        Video.stopVideo()
    }
    
    
    @IBOutlet weak var Titlee: UILabel!
    @IBOutlet weak var Timee: UILabel!
    @IBOutlet weak var Link: UILabel!
    @IBOutlet weak var Conditions: UITextView!
    @IBOutlet weak var Gift: UILabel!
    @IBOutlet weak var Persons: UILabel!
    @IBOutlet weak var VIew1: UIView!
    @IBOutlet weak var VIew2: UIView!
    @IBOutlet weak var VIew3: UIView!
    @IBOutlet weak var VIew4: UIView!
    @IBOutlet weak var VIew5: UIView!
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var Video: WKYTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Style(View: self.VIew1)
        Style(View: self.VIew2)
        Style(View: self.VIew3)
        Style(View: self.VIew4)
        Style(View: self.VIew5)
        
        
        Video.load(withVideoId: "oas_TibA2DU", playerVars: ["playsinline":"1"])
        Video.delegate = self
        Video.layer.masksToBounds = true
        self.Video.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    func Style(View : UIView){
        View.layer.shadowColor = UIColor.lightGray.cgColor
        View.layer.shadowOpacity = 0.3
        View.layer.shadowOffset = CGSize.zero
        View.layer.shadowRadius = 16
    }
    

    @IBOutlet weak var Join: UIButton!
    @IBAction func Join(_ sender: Any) {
    }
    
}
