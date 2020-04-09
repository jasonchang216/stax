//
//  ViewController.swift
//  stax
//
//  Created by Jason Chang on 4/6/20.
//  Copyright © 2020 Jason Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//Settings
    @IBOutlet weak var timerSettingLabel: UILabel!
    
    var timerSetting:String = ""
    
    func onUserAction(data: String) {
        timerSetting = data
        timerSettingLabel.text = timerSetting
    }
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainTitle.text = "TIME TO WORKOUT"
        countLabel.text = " "
        exerciseLabel.text = " "
    }
    
//Exercise randomizer
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    
    let countList: [String] = ["20", "10", "15", "30", "10", "5", "10", "20", "10", "30"]
    let exerciseList: [String] = ["SQUATS", "PUSHUPS", "SECONDS OF PLANK", "JUMPJACKS", "LUNGES (EACH LEG)", "BURPEES", "UP-DOWN PLANKS", "LATERAL LUNGES (EACH SIDE)", "V-UPS", "SECONDS OF HIGH KNEES"]
    
    @IBAction func nextExercise(_ sender: Any) {
        let number = Int.random(in: 0 ... countList.count - 1)
        mainTitle.text = "DO"
        countLabel.text = "\(countList[number])"
        exerciseLabel.text = "\(exerciseList[number])"
        (sender as! UIButton).setTitle("NEXT", for: [])
        if isTimerRunning == false {
            runTimer()
        }
        
        
    }
    
//Time keeper
    
    @IBOutlet weak var timerLabel: UILabel!
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
        
        if seconds < 1 {
            timer.invalidate()
            mainTitle.text = "TIME TO WORKOUT"
            countLabel.text = " "
            exerciseLabel.text = " "
            isTimerRunning = false
            seconds = 60
            
            let alert = UIAlertController(title: "WORKOUT COMPLETE", message: "YOU'RE DONE.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)),userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        timer.invalidate()
        seconds = 60
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
    }
    

    
}

