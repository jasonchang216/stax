//
//  ViewController.swift
//  stax
//
//  Created by Jason Chang on 4/6/20.
//  Copyright © 2020 Jason Chang. All rights reserved.
//
//Photo background Image by <a href="https://pixabay.com/users/AnnaHang-6970466/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=2929205">hang Anna</a> from <a href="https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=2929205">Pixabay</a>

import UIKit
import CoreData

class ViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground()
        mainTitle.text = "TIME TO WORKOUT"
        countLabel.text = " "
        exerciseLabel.text = " "
        sessionCountLabel.text = "0"
        
        if (defaults.object(forKey: "timer") != nil) {
            timerValue = defaults.float(forKey: "timer")
        }
        
        if (defaults.object(forKey: "timer") == nil) {
            timerValue = 900
        }
        
        timerLabel.text = timeString(time: TimeInterval(timerValue))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (defaults.object(forKey: "timer") != nil) {
            timerValue = defaults.float(forKey: "timer")
        }
        
        timerLabel.text = timeString(time: TimeInterval(timerValue))
    }

// MARK: - Settings Control
    let defaults = UserDefaults.standard
    
    var timerValue: Float = 0

// MARK: - Exercise List
    let upperBodyExercises: [String] = ["PUSHUPS", "UP-DOWN PLANKS", "TRICEP EXTENSIONS", "SCAPULAR SHURGS", "PIKE PUSHUPS", "SHOULDER TAP", "WIDE ARM PUSHUPS", "DIAMOND PUSHUPS", "INCHWORM CRAWLS", "TRICEP DIPS", "TRICEP PUSHUPS", "WALKOUT PUSHUPS", "THIGH TAPS", "RAISED LEG PUSHUPS"]
    let upperBodyExercisesCount: [String] = ["10", "10", "10", "10", "10", "20", "10", "10", "5", "10", "10", "5", "10", "10"]
    
    let lowerBodyExercises: [String] = ["SQUATS", "LUNGES (EACH LEG)", "LATERAL LUNGES (EACH LEG)", "CALF RAISES", "SQUAT JUMPS", "DONKEY KICKS (EACH LEG)", "BRIDGES", "SPLIT SQUAT (EACH LEG)", "LUNGES STEP UP (EACH LEG)", "PLANK JUMP INS", "SINGLE LEG BRIDGES (EACH LEG)", "POWER LUNGES (EACH LEG)", "PYLO LUNGES", "LATERAL LEG RAISES"]
    let lowerBodyExercisesCount: [String] = ["20", "10", "10", "20", "10", "10", "10", "10", "10", "10", "10", "10", "20", "20"]
    
    let cardioExercises: [String] = ["JUMPING JACKS", "BURPEES", "SECONDS OF HIGH KNEES", "JUMP KNEE TUCKS", "SECONDS OF MOUNTAIN CLIMBERS", "SECONDS OF PLANK JACKS", "HIGH VERTICAL JUMPS", "SECONDS OF SKATERS", "LONG JUMPS (JOG BACK)", "TUCK JUMPS", "SINGLE LEG HOPS (EACH LEG)", "STAR JUMPS", "SECONDS OF BUTT KICKS"]
    let cardioExercisesCount: [String] = ["30", "10", "30", "20", "30", "30", "20", "30", "10", "20", "20", "20", "20"]
    
    let coreExercises: [String] = ["SECONDS OF PLANK", "V-UPS", "DEAD BUGS", "SECONDS OF FLUTTER KICKS", "LEG RAISES", "SIT UPS", "ARM AND LEG PLANK RAISES", "SECONDS OF SCISSORS", "SECONDS OF SIDE PLANK", "TRUNK ROTATIONS", "PLANK T ROTATIONS", "STANDING OBLIQUE CRUNCHES", "SECONDS OF BICYCLES", "REVERSE CRUNCHES"]
    let coreExercisesCount: [String] = ["15", "10", "10", "15", "10", "20", "20", "15", "15", "20", "20", "20", "20", "20"]
    
 
// MARK: - Exercise Counter Saver and Fetcher
    @IBOutlet weak var sessionCountLabel: UILabel!
    
    var sessionCount: Int = 0
    
    func save(sessionCount: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
        }
        
        let managedContext =  appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Sessions", in: managedContext)!
        let session = NSManagedObject(entity: entity, insertInto: managedContext)
        session.setValue(sessionCount, forKeyPath: "setCount")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
// MARK: - Exercise Randomizer
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    
    var countList: [String] = []
    var exerciseList: [String] = []
    
    @IBAction func nextExercise(_ sender: Any) {
        
        //When there are no user defaults initially set to true
        if defaults.object(forKey: "upperBodySwitch") == nil {
            exerciseList += upperBodyExercises
            countList += upperBodyExercisesCount
        }
        
        if defaults.object(forKey: "lowerBodySwitch") == nil {
            exerciseList += lowerBodyExercises
            countList += lowerBodyExercisesCount
        }
        
        if defaults.object(forKey: "cardioSwitch") == nil {
            exerciseList += cardioExercises
            countList += cardioExercisesCount
        }
        
        if defaults.object(forKey: "coreSwitch") == nil {
            exerciseList += coreExercises
            countList += coreExercisesCount
        }
        
        //When user defaults are not empty
        if defaults.bool(forKey: "upperBodySwitch") == true {
            exerciseList += upperBodyExercises
            countList += upperBodyExercisesCount
        }
        
        if defaults.bool(forKey: "lowerBodySwitch") == true {
            exerciseList += lowerBodyExercises
            countList += lowerBodyExercisesCount
        }
        
        if defaults.bool(forKey: "cardioSwitch") == true {
            exerciseList += cardioExercises
            countList += cardioExercisesCount
        }
        
        if defaults.bool(forKey: "coreSwitch") == true {
            exerciseList += coreExercises
            countList += coreExercisesCount
        }
        
        if exerciseList == [] {
            let alert = UIAlertController(title: "EXERCISES MUST BE CHOSEN", message: "CHOOSE AT LEAST ONE AREA", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let number = Int.random(in: 0 ... countList.count - 1)
        mainTitle.text = "DO"
        countLabel.text = "\(countList[number])"
        exerciseLabel.text = "\(exerciseList[number])"
        (sender as! UIButton).setTitle("NEXT", for: [])
        if isTimerRunning == false {
            seconds = Int(timerValue)
            runTimer()
        }
        
        if needToResetCount == true {
            sessionCount = 0
            needToResetCount = false
        }
        
        sessionCount += 1
        sessionCountLabel.text = String(sessionCount)
        
        exerciseList = []
        countList = []
    }
    
    @IBAction func skipExercise(_ sender: Any) {
        
        //When there are no user defaults initially set to true
        if defaults.object(forKey: "upperBodySwitch") == nil {
            exerciseList += upperBodyExercises
            countList += upperBodyExercisesCount
        }
        
        if defaults.object(forKey: "lowerBodySwitch") == nil {
            exerciseList += lowerBodyExercises
            countList += lowerBodyExercisesCount
        }
        
        if defaults.object(forKey: "cardioSwitch") == nil {
            exerciseList += cardioExercises
            countList += cardioExercisesCount
        }
        
        if defaults.object(forKey: "coreSwitch") == nil {
            exerciseList += coreExercises
            countList += coreExercisesCount
        }
        
        //When user defaults are not empty
        if defaults.bool(forKey: "upperBodySwitch") == true {
            exerciseList += upperBodyExercises
            countList += upperBodyExercisesCount
        }
        
        if defaults.bool(forKey: "lowerBodySwitch") == true {
            exerciseList += lowerBodyExercises
            countList += lowerBodyExercisesCount
        }
        
        if defaults.bool(forKey: "cardioSwitch") == true {
            exerciseList += cardioExercises
            countList += cardioExercisesCount
        }
        
        if defaults.bool(forKey: "coreSwitch") == true {
            exerciseList += coreExercises
            countList += coreExercisesCount
        }
        
        if exerciseList == [] {
            let alert = UIAlertController(title: "EXERCISES MUST BE CHOSEN", message: "CHOOSE AT LEAST ONE AREA", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let number = Int.random(in: 0 ... countList.count - 1)
        mainTitle.text = "DO"
        countLabel.text = "\(countList[number])"
        exerciseLabel.text = "\(exerciseList[number])"
        if isTimerRunning == false {
            seconds = Int(timerValue)
            runTimer()
        }
        
        exerciseList = []
        countList = []
    }
    
    
    
    
// MARK: - Time Keeper
    @IBOutlet weak var timerLabel: UILabel!
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
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
            self.save(sessionCount: sessionCount)
            let alert = UIAlertController(title: "WORKOUT COMPLETE", message: "YOU'RE DONE.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            sessionCount = 0
            sessionCountLabel.text = "0"
            mainTitle.text = "TIME TO WORKOUT"
            countLabel.text = " "
            exerciseLabel.text = " "
        }
    }
    
    func runTimer() {
        if timerValue < 0.01 {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)),userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    var needToResetCount = false
    
    @IBAction func resetTimer(_ sender: Any) {
        timer.invalidate()
        seconds = Int(timerValue)
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        if sessionCount == 0 {
            return
        } else {
        self.save(sessionCount: sessionCount)
            }
        needToResetCount = true
        //sessionCount = 0
        //sessionCountLabel.text = "0"
        mainTitle.text = "TIME TO WORKOUT"
        countLabel.text = " "
        exerciseLabel.text = " "
    }
    
    @IBAction func pauseTimer(_ sender: Any) {
        if self.resumeTapped == false {
             timer.invalidate()
             self.resumeTapped = true
            (sender as! UIButton).setTitle("RESUME", for: [])
        } else {
             runTimer()
             self.resumeTapped = false
            (sender as! UIButton).setTitle("PAUSE", for: [])
        }
    }
    
}

//MARK - Background image load

extension UIView {
    func addBackground(imageName: String = "marble", contentMode: UIView.ContentMode = .scaleAspectFill) {
        // setup the UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = contentMode
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.isOpaque = false
        backgroundImageView.alpha = 0.5

        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)

        // adding NSLayoutConstraints
        let leadingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)

        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
}
