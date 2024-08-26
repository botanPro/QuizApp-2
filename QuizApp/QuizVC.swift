//
//  QuizVC.swift
//  QuizApp
//
//  Created by Botan Amedi on 02/07/2024.
//

import UIKit
import FSPagerView
import MZTimerLabel
import JKAlertView
import FCAlertView
class QuizVC: UIViewController ,FCAlertViewDelegate{

    
    
    var countdownTimer: Timer?

    var totalTime = 15
    
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    var IsFirst = true
    func startTimer(index : Int) {
        self.reached_index = index
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        if self.IsFirst == true {
            self.IsFirst = false
            self.Question.text = self.QuestionArray[0].question
            self.Ans1.setTitle(self.QuestionArray[0].answer1, for: .normal)
            self.Ans2.setTitle(self.QuestionArray[0].answer2, for: .normal)
            self.Ans3.setTitle(self.QuestionArray[0].answer3, for: .normal)
            self.Ans4.setTitle(self.QuestionArray[0].answer4, for: .normal)
        }else{print("444")
            if index <= self.QuestionArray.count - 1{
                self.Question.text = self.QuestionArray[index].question
                self.Ans1.setTitle(self.QuestionArray[index].answer1, for: .normal)
                self.Ans2.setTitle(self.QuestionArray[index].answer2, for: .normal)
                self.Ans3.setTitle(self.QuestionArray[index].answer3, for: .normal)
                self.Ans4.setTitle(self.QuestionArray[index].answer4, for: .normal)
            }else{
                self.SuccessAlert()
                countdownTimer?.invalidate()
            }
        }
    }
    
    
    
    let alert = FCAlertView()
    
    func SuccessAlert(){
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
            self.dismiss(animated: true)
        })
    }
    
    
    
    
    @objc func updateTimer() {
        if totalTime > 0 {print("333")
            totalTime -= 1
            updateUI()
        } else {
            print(self.seleceted_answer)
            print(self.QuestionArray[self.reached_index].correct_answer)
            print(self.reached_index
            )
            if self.seleceted_answer == self.QuestionArray[self.reached_index].correct_answer{print("222")
                
                if self.Ans1.titleLabel?.text == self.QuestionArray[self.reached_index].correct_answer{
                    self.Ans1.backgroundColor = #colorLiteral(red: 0.121013619, green: 0.8169161677, blue: 0, alpha: 1)
                    self.Ans1.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                    self.Ans2.backgroundColor = .white
                    self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans3.backgroundColor = .white
                    self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans4.backgroundColor = .white
                    self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                }
                
                
                if self.Ans2.titleLabel?.text == self.QuestionArray[self.reached_index].correct_answer{
                    self.Ans2.backgroundColor = #colorLiteral(red: 0.121013619, green: 0.8169161677, blue: 0, alpha: 1)
                    self.Ans2.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                    self.Ans1.backgroundColor = .white
                    self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans3.backgroundColor = .white
                    self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans4.backgroundColor = .white
                    self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                }
                
                
                if self.Ans3.titleLabel?.text == self.QuestionArray[self.reached_index].correct_answer{
                    self.Ans3.backgroundColor = #colorLiteral(red: 0.121013619, green: 0.8169161677, blue: 0, alpha: 1)
                    self.Ans3.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                    self.Ans2.backgroundColor = .white
                    self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans1.backgroundColor = .white
                    self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans4.backgroundColor = .white
                    self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                }
                
                
                if self.Ans4.titleLabel?.text == self.QuestionArray[self.reached_index].correct_answer{
                    self.Ans4.backgroundColor = #colorLiteral(red: 0.121013619, green: 0.8169161677, blue: 0, alpha: 1)
                    self.Ans4.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                    self.Ans2.backgroundColor = .white
                    self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans3.backgroundColor = .white
                    self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans1.backgroundColor = .white
                    self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                }
                
            }else{print("555")
                LoseAlert()
                if self.Ans1.titleLabel?.text == self.QuestionArray[self.reached_index].correct_answer{
                    self.Ans1.backgroundColor = #colorLiteral(red: 0.121013619, green: 0.8169161677, blue: 0, alpha: 1)
                    self.Ans1.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                    self.Ans2.backgroundColor = .white
                    self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans3.backgroundColor = .white
                    self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans4.backgroundColor = .white
                    self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                }
                
                
                if self.Ans2.titleLabel?.text == self.QuestionArray[self.reached_index].correct_answer{
                    self.Ans2.backgroundColor = #colorLiteral(red: 0.121013619, green: 0.8169161677, blue: 0, alpha: 1)
                    self.Ans2.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                    self.Ans1.backgroundColor = .white
                    self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans3.backgroundColor = .white
                    self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans4.backgroundColor = .white
                    self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                }
                
                
                if self.Ans3.titleLabel?.text == self.QuestionArray[self.reached_index].correct_answer{
                    self.Ans3.backgroundColor = #colorLiteral(red: 0.121013619, green: 0.8169161677, blue: 0, alpha: 1)
                    self.Ans3.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                    self.Ans2.backgroundColor = .white
                    self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans1.backgroundColor = .white
                    self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans4.backgroundColor = .white
                    self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                }
                
                
                if self.Ans4.titleLabel?.text == self.QuestionArray[self.reached_index].correct_answer{
                    self.Ans4.backgroundColor = #colorLiteral(red: 0.121013619, green: 0.8169161677, blue: 0, alpha: 1)
                    self.Ans4.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                    self.Ans2.backgroundColor = .white
                    self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans3.backgroundColor = .white
                    self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                    
                    self.Ans1.backgroundColor = .white
                    self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                }
            }
            
            countdownTimer?.invalidate()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {print("111")
                self.totalTime = 15
                self.selected_button = 0
                self.Ans1.backgroundColor = .white
                self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                
                self.Ans2.backgroundColor = .white
                self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                
                self.Ans3.backgroundColor = .white
                self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                
                self.Ans4.backgroundColor = .white
                self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
                self.startTimer(index: self.reached_index + 1)
            })
            
           
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
    
    
    @IBOutlet weak var Question: UILabel!
    
    @IBOutlet weak var Timerr: UILabel!
    
    var sliderImages : [String] = []
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
    var endDate: Date?
    
    var reached_index = 0
    
    var QuestionArray : [QuestionObjects] = []
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
        
    
        
        
        self.QuestionArray.append(QuestionObjects(question: "کیشکە ئیکەم مخلوق نەشیت سەحکەتە ئەسمانان", answer1: "بەراز", answer2: "باز", answer3: "هەسپ", answer4: "مروڤ", correct_answer: "بەراز"))
        
        self.QuestionArray.append(QuestionObjects(question: "ئەو کیش پێغەمبەری هێشتا یێ ساخ و نەمری؟", answer1: "عیسا", answer2: "موسی", answer3: "محمد", answer4: "دانیال", correct_answer: "عیسا"))
    
        
        startTimer(index: 0)
        
    }


    var seleceted_answer = ""
    var selected_button = 0
    
    @IBAction func Ans1(_ sender: Any) {
        self.Ans1.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.Ans1.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.Ans2.backgroundColor = .white
        self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans3.backgroundColor = .white
        self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans4.backgroundColor = .white
        self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        
        selected_button = 1
        
        self.seleceted_answer = self.Ans1.titleLabel?.text ?? ""
    }
    
    @IBAction func Ans2(_ sender: Any) {
        self.Ans2.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.Ans2.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.Ans1.backgroundColor = .white
        self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans3.backgroundColor = .white
        self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans4.backgroundColor = .white
        self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        selected_button = 2
        
        
        self.seleceted_answer = self.Ans2.titleLabel?.text ?? ""
    }
    
    @IBAction func Ans3(_ sender: Any) {
        self.Ans3.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.Ans3.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.Ans2.backgroundColor = .white
        self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans1.backgroundColor = .white
        self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans4.backgroundColor = .white
        self.Ans4.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        selected_button = 3
        
        self.seleceted_answer = self.Ans3.titleLabel?.text ?? ""
    }
    
    @IBAction func Ans4(_ sender: Any) {
        self.Ans4.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.Ans4.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.Ans1.backgroundColor = .white
        self.Ans1.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans3.backgroundColor = .white
        self.Ans3.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        self.Ans2.backgroundColor = .white
        self.Ans2.titleLabel?.textColor = #colorLiteral(red: 0.2697272301, green: 0.3513770103, blue: 0.5937254429, alpha: 1)
        
        
        selected_button = 3
        
        
        self.seleceted_answer = self.Ans4.titleLabel?.text ?? ""
    }
    
}
