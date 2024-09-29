//
//  QuizVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 02/07/2024.
//

import UIKit
import FSPagerView
import MZTimerLabel
import FCAlertView
import Starscream
import AVFoundation
import EFInternetIndicator
class QuizVC: UIViewController ,FCAlertViewDelegate, InternetStatusIndicable{
    var internetConnectionIndicator:InternetViewIndicator?

    var countdownTimer: Timer?

    var totalTime = 15
    var Quiz_Id = 0
    
    
    @IBAction func Dismiss(_ sender: Any) {
        if CheckInternet.Connection(){
            QuizObjectApi.SubmitAnswer(quiz_id: self.Quiz_Id, question_id: self.QuestionId, answer: "nn") { status in
                self.countdownTimer?.invalidate()
                self.dismiss(animated: true)
            }
        }else{
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }
    }
    
    var IsFirst = true
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    let alert = FCAlertView()
    
    func SuccessAlert(){
        self.audioPlayer?.stop()
        alert.titleColor = .black
        alert.subTitleColor = .darkGray
        alert.makeAlertTypeSuccess()
        alert.fullCircleCustomImage = false
        alert.dismissOnOutsideTouch = true
        alert.showAlert(
            inView: self,
            withTitle: "دەست خوش، سەرکەفتی",
            withSubtitle: "پیروز بیت  تو ب  سەرکەتی.",
            withCustomImage: nil,
            withDoneButtonTitle: nil,
            andButtons: nil)
        alert.doneActionBlock({
            self.dismiss(animated: true)
        })
    }
    
    func LoseAlert(){
        Errorr()
        alert.titleColor = .black
        alert.subTitleColor = .darkGray
        alert.makeAlertTypeWarning()
        alert.fullCircleCustomImage = false
        alert.dismissOnOutsideTouch = true
        alert.showAlert(
            inView: self,
            withTitle: "ببورە، تو هاتیە لادان",
            withSubtitle: "ببورە، هەلبژارتنا تا یا خەلەت بو",
            withCustomImage: nil,
            withDoneButtonTitle: nil,
            andButtons: nil)
        alert.doneActionBlock({
            self.audioPlayer?.stop()
            self.dismiss(animated: true)
        })
    }
    
    var audioPlayer: AVAudioPlayer?
    
    func Errorr(){
        guard let soundURL = Bundle.main.url(forResource: "error-8-206492", withExtension: "mp3") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = 1
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error initializing AVAudioPlayer: \(error.localizedDescription)")
        }
        
        audioPlayer?.play()
        AudioServicesPlaySystemSound(1519)
    }
    
    
    @objc func updateTimer() {
        if totalTime > 0 {
            totalTime -= 1
            updateUI()
        } else {
            if CheckInternet.Connection(){
                totalTime = 15
                countdownTimer?.invalidate()
                self.Ans1.isUserInteractionEnabled = false
                self.Ans2.isUserInteractionEnabled = false
                self.Ans3.isUserInteractionEnabled = false
                self.Ans4.isUserInteractionEnabled = false
                if self.seleceted_answer == ""{
                    self.seleceted_answer = "nn"
                }
                if self.CorrectAnswer == self.Ans1.accessibilityIdentifier{
                    self.Ans1.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    self.Ans1.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                
                if self.CorrectAnswer == self.Ans2.accessibilityIdentifier{
                    self.Ans2.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    self.Ans2.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                
                if self.CorrectAnswer == self.Ans3.accessibilityIdentifier{
                    self.Ans3.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    self.Ans3.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                
                if self.CorrectAnswer == self.Ans4.accessibilityIdentifier{
                    self.Ans4.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    self.Ans4.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                
                print(self.Quiz_Id)
                print(self.QuestionId)
                print(self.seleceted_answer)
                
                CountdownView.show(countdownFrom: 2.0, spin: true, animation: .fadeIn)
                QuizObjectApi.SubmitAnswer(quiz_id: self.Quiz_Id, question_id: self.QuestionId, answer: self.seleceted_answer) { status in
                    self.CorrectAnswer = ""
                    self.seleceted_answer = ""
                    if status == "success"{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            CountdownView.hide(animation: .fadeIn, options: (0.0,0.0)) {
                                QuizObjectApi.next_question(quiz_id: self.Quiz_Id) { QuestionObject, Question, Options, statu in
                                    if statu != "quiz_done"{
                                        self.Ans1.isUserInteractionEnabled = true
                                        self.Ans2.isUserInteractionEnabled = true
                                        self.Ans3.isUserInteractionEnabled = true
                                        self.Ans4.isUserInteractionEnabled = true
                                        
                                        self.Ans1.backgroundColor = .white
                                        self.Ans1.setTitleColor(#colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1), for: .normal)
                                        
                                        self.Ans2.backgroundColor = .white
                                        self.Ans2.setTitleColor(#colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1), for: .normal)
                                        
                                        self.Ans3.backgroundColor = .white
                                        self.Ans3.setTitleColor(#colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1), for: .normal)
                                        
                                        self.Ans4.backgroundColor = .white
                                        self.Ans4.setTitleColor(#colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1), for: .normal)
                                        
                                        self.startTimer()
                                        self.EnrollId = QuestionObject.enrollId
                                        self.QuestionId = Question.id
                                        self.CorrectAnswer = Question.answer
                                        self.Question.text = Question.title
                                        self.Levle.text = "ئاستێ \(QuestionObject.level)"
                                        self.Prsons.text = "\(QuestionObject.total_users)/\(QuestionObject.remain_users)"
                                        for (index, option) in Options.enumerated() {
                                            let optionText = option.value
                                            let optionKey = option.key
                                            switch index {
                                            case 0:
                                                self.Ans1.setTitle(optionText, for: .normal)
                                                self.Ans1.accessibilityIdentifier = optionKey
                                            case 1:
                                                self.Ans2.setTitle(optionText, for: .normal)
                                                self.Ans2.accessibilityIdentifier = optionKey
                                            case 2:
                                                self.Ans3.setTitle(optionText, for: .normal)
                                                self.Ans3.accessibilityIdentifier = optionKey
                                            case 3:
                                                self.Ans4.setTitle(optionText, for: .normal)
                                                self.Ans4.accessibilityIdentifier = optionKey
                                            default:
                                                break
                                            }
                                        }
                                    }else if statu == "quiz_done"{
                                        CountdownView.hide(animation: .fadeIn, options: (0.0,0.0)) {
                                            self.SuccessAlert()
                                        }
                                    }
                                }
                            }
                        })
                    }else{
                        CountdownView.hide(animation: .fadeIn, options: (0.0,0.0)) {
                            self.LoseAlert()
                        }
                    }
                }
                
            }else{
                self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
            }
            
            
        }
    }
    
    
    func updateUI() {
        DispatchQueue.main.async {
            self.Timerr.text = self.formatTime(self.totalTime)
        }
    }

    func formatTime(_ seconds: Int) -> String {
        return String(format: "%02d", seconds)
    }
    @IBOutlet weak var Titlee: UILabel!
    
    
    @IBOutlet weak var Question: UILabel!
    
    @IBOutlet weak var Timerr: UILabel!
    
    var sliderImages : [SlidesObject] = []
    @IBOutlet weak var SliderView: FSPagerView!{
        didSet{
            self.SliderView.layer.masksToBounds = true
            self.SliderView.automaticSlidingInterval = 3.0
            self.SliderView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.SliderView.transformer = FSPagerViewTransformer(type: .linear)
            self.SliderView.itemSize =  CGSize(width: SliderView.layer.bounds.width - 25, height: SliderView.layer.bounds.height)
        }
    }

    @IBOutlet weak var Ans1: UIButton!
    @IBOutlet weak var Ans2: UIButton!
    @IBOutlet weak var Ans3: UIButton!
    @IBOutlet weak var Ans4: UIButton!

    @IBOutlet weak var Levle: UILabel!
    @IBOutlet weak var Prsons: UILabel!

    var CorrectAnswer = ""
    var EnrollId = 0
    var QuestionId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SliderView.layer.shadowColor = UIColor.lightGray.cgColor
        SliderView.layer.shadowOpacity = 0.3
        SliderView.layer.shadowOffset = CGSize.zero
        SliderView.layer.shadowRadius = 16
        
        
        Ans1.layer.shadowColor = UIColor.lightGray.cgColor
        Ans1.layer.shadowOpacity = 0.3
        Ans1.layer.shadowOffset = CGSize.zero
        Ans1.layer.shadowRadius = 16
        
        
        Ans2.layer.shadowColor = UIColor.lightGray.cgColor
        Ans2.layer.shadowOpacity = 0.3
        Ans2.layer.shadowOffset = CGSize.zero
        Ans2.layer.shadowRadius = 16
        
        
        Ans3.layer.shadowColor = UIColor.lightGray.cgColor
        Ans3.layer.shadowOpacity = 0.3
        Ans3.layer.shadowOffset = CGSize.zero
        Ans3.layer.shadowRadius = 16
        
        
        Ans4.layer.shadowColor = UIColor.lightGray.cgColor
        Ans4.layer.shadowOpacity = 0.3
        Ans4.layer.shadowOffset = CGSize.zero
        Ans4.layer.shadowRadius = 16
        
        if CheckInternet.Connection(){
            
            SlidesObjectAPI.GetSlideImage { slides in
                self.sliderImages = slides
                self.SliderView.reloadData()
            }
            
            
            QuizObjectApi.start_quiz(quiz_id: self.Quiz_Id) { QuestionObject, Question, Options in
                self.startTimer()
                self.EnrollId = QuestionObject.enrollId
                self.QuestionId = Question.id
                self.CorrectAnswer = Question.answer
                self.Question.text = Question.title
                self.Levle.text = "ئاستێ \(QuestionObject.level)"
                self.Prsons.text = "\(QuestionObject.total_users)/\(QuestionObject.remain_users)"
                for (index, option) in Options.enumerated() {
                    let optionText = option.value
                    let optionKey = option.key
                    switch index {
                    case 0:
                        self.Ans1.setTitle(optionText, for: .normal)
                        self.Ans1.accessibilityIdentifier = optionKey
                    case 1:
                        self.Ans2.setTitle(optionText, for: .normal)
                        self.Ans2.accessibilityIdentifier = optionKey
                    case 2:
                        self.Ans3.setTitle(optionText, for: .normal)
                        self.Ans3.accessibilityIdentifier = optionKey
                    case 3:
                        self.Ans4.setTitle(optionText, for: .normal)
                        self.Ans4.accessibilityIdentifier = optionKey
                    default:
                        break
                    }
                }
            }
        }else{
            self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"ئینترنێت نینە", remoteHostName: "magic.com")
        }
    }

    var seleceted_answer = ""
    
    @IBAction func Ans1(_ sender: Any) {
        self.Ans1.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.Ans1.setTitleColor(.white, for: .normal)
        
        self.Ans2.backgroundColor = .white
        self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans3.backgroundColor = .white
        self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans4.backgroundColor = .white
        self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        
        seleceted_answer = Ans1.accessibilityIdentifier ?? ""
        
    }
    
    @IBAction func Ans2(_ sender: Any) {
        self.Ans1.backgroundColor = .white
        self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans2.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.Ans2.setTitleColor(.white, for: .normal)
        
        self.Ans3.backgroundColor = .white
        self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans4.backgroundColor = .white
        self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        seleceted_answer = Ans2.accessibilityIdentifier ?? ""
    }
    
    @IBAction func Ans3(_ sender: Any) {
        self.Ans1.backgroundColor = .white
        self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans2.backgroundColor = .white
        self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans3.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.Ans3.setTitleColor(.white, for: .normal)
        
        self.Ans4.backgroundColor = .white
        self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        seleceted_answer = Ans3.accessibilityIdentifier ?? ""
    }
    
    @IBAction func Ans4(_ sender: Any) {
        self.Ans1.backgroundColor = .white
        self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans2.backgroundColor = .white
        self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans3.backgroundColor = .white
        self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans4.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.Ans4.setTitleColor(.white, for: .normal)
        
        
        seleceted_answer = self.Ans4.accessibilityIdentifier ?? ""
        
    }
    
}


extension QuizVC: FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if sliderImages.count == 0{
            return 0
        }
        return sliderImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        if sliderImages.count != 0{
            let urlString = sliderImages[index].image
            let url = URL(string: urlString)
            cell.imageView?.sd_setImage(with: url, completed: nil)
            cell.imageView?.contentMode = .scaleToFill
            cell.imageView?.clipsToBounds = true
            cell.imageView?.layer.cornerRadius = 6
            cell.contentView.layer.shadowOpacity = 0
            if index == 1{
                self.SliderView.scrollToItem(at: 1, animated: false)
            }
        }
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if sliderImages.count != 0{
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
            
            if let url = NSURL(string: sliderImages[index].link){
                UIApplication.shared.open(url as URL)
            }
            
        }
    }

    
    
    
    

    
    
}
