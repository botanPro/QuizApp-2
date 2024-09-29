//
//  ConditionVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 22/07/2024.
//

import UIKit
import FSPagerView
import MZTimerLabel
import FCAlertView
import AVFoundation
import YoutubePlayer_in_WKWebView
import EFInternetIndicator

class ConditionVC: UIViewController ,WKYTPlayerViewDelegate, InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        Video.stopVideo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Video.stopVideo()
    }
    
    var audioInput: AVCaptureDeviceInput?
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
    
    var quizInfo : QuizObject?
    
    @IBAction func Dismiss(_ sender: Any) {
        self.countdownTimer?.invalidate()
        self.dismiss(animated: true)
    }
    
        
    var link = ""
    var time = ""
    
    
    @IBOutlet weak var Video: WKYTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Style(View: self.VIew1)
        Style(View: self.VIew2)
        Style(View: self.VIew3)
        Style(View: self.VIew4)
        Style(View: self.VIew5)
        
        self.VIew2.isHidden = true
        self.VIew3.isHidden = true
        if CheckInternet.Connection(){
            if let quiz = self.quizInfo{
                
                self.Timee.text = quiz.start_time
                self.Titlee.text = quiz.title
                self.Conditions.text = quiz.description
                self.Gift.text = quiz.gift_name
                self.Persons.text = "\(quiz.gift_winners)/ دیاری"
                
                self.link = quiz.link
                self.time = quiz.start_time
                
                if quiz.youtube_link != ""{
                    self.VIew2.isHidden = false
                    Video.load(withVideoId: quiz.youtube_link, playerVars: ["playsinline":"1"])
                    Video.delegate = self
                    Video.layer.masksToBounds = true
                    self.Video.layer.cornerRadius = 10
                }
                
                if quiz.link != ""{
                    self.VIew3.isHidden = false
                    self.Link.text = quiz.link
                }
            }
        }else{
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }
        
    }
    
    
    @IBAction func Link(_ sender: Any) {
        if let url = NSURL(string: self.quizInfo?.link ?? ""){
            UIApplication.shared.open(url as URL)
        }
    }
    
    
    func Style(View : UIView){
        View.layer.shadowColor = UIColor.lightGray.cgColor
        View.layer.shadowOpacity = 0.3
        View.layer.shadowOffset = CGSize.zero
        View.layer.shadowRadius = 16
    }
    
    
    var totalTime = 59.0
    @objc func updateTimer() {
        if totalTime > 0 {
            totalTime -= 1
        } else {
            countdownTimer?.invalidate()
            CountdownView.hide(animation: .fadeIn, options: (0.0,0.0)) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuizVC") as! QuizVC
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.Quiz_Id = self.quizInfo?.id ?? 0
                self.present(vc, animated: true)
            }
            
        }
    }
    
    var countdownTimer: Timer?

    func formatTime(_ seconds: Int) -> String {
        return String(format: "%02d", seconds)
    }
    
    
    func startTimer() {
        if CheckInternet.Connection(){
            QuizObjectApi.EnrollQuizs(quiz_id: self.quizInfo?.id ?? 0) { status in
                if status == "success"{
                    self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                    CountdownView.show(countdownFrom: self.totalTime, spin: true, animation: .fadeIn)
                }else{
                    self.LoseAlert()
                }
            }
        }else{
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }
    }
    
    func LoseAlert(){
        AudioServicesPlaySystemSound(1519)
        alert.titleColor = .black
        alert.subTitleColor = .darkGray
        alert.makeAlertTypeWarning()
        alert.fullCircleCustomImage = false
        alert.dismissOnOutsideTouch = true
        alert.showAlert(
            inView: self,
            withTitle: "ببورە، تو هاتیە لادان",
            withSubtitle: "تو نە شێی بەشدار ببی.",
            withCustomImage: nil,
            withDoneButtonTitle: nil,
            andButtons: nil)
        alert.doneActionBlock({
            self.countdownTimer?.invalidate()
            self.dismiss(animated: true)
        })
    }
    
    
    var second = 0.0
    let alert = FCAlertView()
    @IBOutlet weak var Join: UIButton!
    @IBAction func Join(_ sender: Any) {
        let currentDate = Date()
        let rquestDateFormatter = DateFormatter()
        rquestDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        rquestDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let calendar = Calendar.current

        if let formattedRequestDate = rquestDateFormatter.date(from: self.time) {
            let formattedRequestDatePlus59Seconds = formattedRequestDate.addingTimeInterval(59)
            let current = currentDate.addingTimeInterval(10800)
            print("Formatted Request Date: \(formattedRequestDate)")
            print("Formatted Current Date: \(current)")
            print("Formatted Request 15  : \(formattedRequestDatePlus59Seconds)")
            if current < formattedRequestDate {
                print("yet")
                alert.titleColor = .black
                alert.subTitleColor = .darkGray
                alert.makeAlertTypeWarning()
                alert.fullCircleCustomImage = false
                alert.dismissOnOutsideTouch = true
                alert.showAlert(
                    inView: self,
                    withTitle: "هیڤیە چاڤەرێبە",
                    withSubtitle: "دەم یێ مای، هیڤیە چاڤەرێبە.",
                    withCustomImage: nil,
                    withDoneButtonTitle: nil,
                    andButtons: nil)
                alert.doneActionBlock {
                    self.dismiss(animated: true)
                }
            } else if current >= formattedRequestDate &&  current < formattedRequestDatePlus59Seconds {
                print("Can join")
                
                self.second = Double(59 - calendar.component(.second, from: currentDate))
                self.totalTime = self.second
                self.startTimer()
                
            }else if current > formattedRequestDatePlus59Seconds{
                print("Cannot join")
                alert.titleColor = .black
                alert.subTitleColor = .darkGray
                alert.makeAlertTypeWarning()
                alert.fullCircleCustomImage = false
                alert.dismissOnOutsideTouch = true
                alert.showAlert(
                    inView: self,
                    withTitle: "دەم بسەرڤە چوو",
                    withSubtitle: "",
                    withCustomImage: nil,
                    withDoneButtonTitle: nil,
                    andButtons: nil)
                alert.doneActionBlock {
                    self.dismiss(animated: true)
                }
            }
        } else {
            print("Invalid date format for request date")
        }


    }
    
}



