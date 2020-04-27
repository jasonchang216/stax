//
//  ViewController.swift
//  stax
//
//  Created by Jason Chang on 4/6/20.
//  Copyright © 2020 Jason Chang. All rights reserved.
//
//Photo by cottonbro from Pexels

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
        getPreviousData()
        previousCountLabel.text = String(previousCount)
        getRecordData()
        recordCountLabel.text = String(recordCount)

        if (defaults.object(forKey: "upperBodySwitch") != nil) {
            upperBodyUISwitch.isOn = defaults.bool(forKey: "upperBodySwitch")
        }
        
        if (defaults.object(forKey: "lowerBodySwitch") != nil) {
            lowerBodyUISwitch.isOn = defaults.bool(forKey: "lowerBodySwitch")
        }
        
        if (defaults.object(forKey: "cardioSwitch") != nil) {
            cardioUISwitch.isOn = defaults.bool(forKey: "cardioSwitch")
        }
        
        if (defaults.object(forKey: "coreSwitch") != nil) {
            coreUISwitch.isOn = defaults.bool(forKey: "coreSwitch")
        }
        
        if (defaults.object(forKey: "timer") != nil) {
            sliderValue.value = defaults.float(forKey: "timer")
        }
        
        timerLabel.text = timeString(time: TimeInterval(sliderValue.value))
        
    }

// MARK: - Settings Control
    @IBOutlet weak var settingViewTopConstraint: NSLayoutConstraint!
    
    var settingMenuShowing = false
    let defaults = UserDefaults.standard
    
    @IBAction func openSettings(_ sender: Any) {
        if settingMenuShowing == true {
            settingViewTopConstraint.constant = -335
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
            (sender as! UIButton).setTitle("SETTINGS", for: [])
        } else {
            settingViewTopConstraint.constant = -44
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
            (sender as! UIButton).setTitle("CLOSE", for: [])
        }
        settingMenuShowing = !settingMenuShowing
    }
    
    @IBOutlet weak var sliderValue: UISlider!
    @IBAction func timerSlider(_ sender: Any) {
        timerLabel.text = timeString(time: TimeInterval(sliderValue.value))
        defaults.set(sliderValue.value, forKey: "timer")
        if sliderValue.value == 0 {
            timerViewContainer.isHidden = true
        } else {
            timerViewContainer.isHidden = false
        }
    }
    
    @IBOutlet weak var upperBodyUISwitch: UISwitch!
    @IBAction func upperBodySwitcher(_ sender: Any) {
        if upperBodyUISwitch.isOn {
            defaults.set(true, forKey: "upperBodySwitch")
        } else {
            defaults.set(false, forKey: "upperBodySwitch")
        }
    }
    
    @IBOutlet weak var lowerBodyUISwitch: UISwitch!
    @IBAction func lowerBodySwitcher(_ sender: Any) {
        if lowerBodyUISwitch.isOn {
            defaults.set(true, forKey: "lowerBodySwitch")
        } else {
            defaults.set(false, forKey: "lowerBodySwitch")
        }
    }
    
    @IBOutlet weak var cardioUISwitch: UISwitch!
    @IBAction func cardioSwitcher(_ sender: Any) {
        if cardioUISwitch.isOn {
            defaults.set(true, forKey: "cardioSwitch")
        } else {
            defaults.set(false, forKey: "cardioSwitch")
        }
    }
    
    @IBOutlet weak var coreUISwitch: UISwitch!
    @IBAction func coreSwitcher(_ sender: Any) {
        if coreUISwitch.isOn {
            defaults.set(true, forKey: "coreSwitch")
        } else {
            defaults.set(false, forKey: "coreSwitch")
        }
    }
    

// MARK: - Exercise List
    let upperBodyExercises: [String] = ["PUSHUPS",   "UP-DOWN PLANKS"]
    let upperBodyExercisesCount: [String] = ["10", "10"]
    
    
    let lowerBodyExercises: [String] = ["SQUATS", "LUNGES (EACH LEG)", "LATERAL LUNGES (EACH SIDE)"]
    let lowerBodyExercisesCount: [String] = ["20","10", "10"]
    
    
    let cardioExercises: [String] = ["JUMPING JACKS", "BURPEES", "SECONDS OF HIGH KNEES"]
    let cardioExercisesCount: [String] = ["30", "10", "30"]
    
    let coreExercises: [String] = ["SECONDS OF PLANK", "V-UPS"]
    let coreExercisesCount: [String] = ["15", "10"]
    
 
// MARK: - Exercise Counter Saver and Fetcher
    @IBOutlet weak var previousCountLabel: UILabel!
    @IBOutlet weak var sessionCountLabel: UILabel!
    @IBOutlet weak var recordCountLabel: UILabel!
    
    var sessionCount: Int = 0
    var previousCount = Int()
    var recordCount = Int()
    
    func save(sessionCount: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
        }
        
        let managedContext =  appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Sessions", in: managedContext)!
        let session = NSManagedObject(entity: entity, insertInto: managedContext)
        session.setValue(sessionCount, forKeyPath: "sessions")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func resetRecord(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
        }
        
        let managedContext =  appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Sessions")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        previousCountLabel.text = String(0)
        recordCountLabel.text = String(0)
    }
    
    func getPreviousData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sessions")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                previousCount = data.value(forKey: "sessions") as! Int
            }
                
        } catch {
            print("Failed")
        }
    }
    
    func getRecordData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sessions")
        request.fetchLimit = 1
        var highestCount : NSSortDescriptor = NSSortDescriptor(key: "sessions", ascending: false)
        request.sortDescriptors = [highestCount]
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                recordCount = data.value(forKey: "sessions") as! Int
            }
                
        } catch {
            print("Failed")
        }
    }
    
// MARK: - Exercise Randomizer
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    
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
            seconds = Int(sliderValue.value)
            runTimer()
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
            seconds = Int(sliderValue.value)
            runTimer()
        }
        
        exerciseList = []
        countList = []
    }
    
    
    
    
// MARK: - Time Keeper
    
    @IBOutlet weak var timerViewContainer: UIView!
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
            getPreviousData()
            previousCountLabel.text = String(previousCount)
            getRecordData()
            recordCountLabel.text = String(recordCount)
        }
    }
    
    func runTimer() {
        if sliderValue.value < 1 {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)),userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        timer.invalidate()
        seconds = Int(sliderValue.value)
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        if sessionCount == 0 {
            return
        } else {
        self.save(sessionCount: sessionCount)
            }
        sessionCount = 0
        sessionCountLabel.text = "0"
        mainTitle.text = "TIME TO WORKOUT"
        countLabel.text = " "
        exerciseLabel.text = " "
        getPreviousData()
        previousCountLabel.text = String(previousCount)
        getRecordData()
        recordCountLabel.text = String(recordCount)
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
    func addBackground(imageName: String = "viewBackground", contentMode: UIView.ContentMode = .scaleAspectFill) {
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
