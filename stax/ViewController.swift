//
//  ViewController.swift
//  stax
//
//  Created by Jason Chang on 4/6/20.
//  Copyright © 2020 Jason Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let countList: [String] = ["20", "10", "15", "30", "10", "5", "10", "20", "10", "30"]
    let exerciseList: [String] = ["SQUATS", "PUSHUPS", "SECONDS OF PLANK", "JUMPJACKS", "LUNGES (EACH LEG)", "BURPEES", "UP-DOWN PLANKS", "LATERAL LUNGES (EACH SIDE)", "V-UPS", "SECONDS OF HIGH KNEES"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainTitle.text = "TIME TO WORKOUT"
        countLabel.text = " "
        exerciseLabel.text = " "
        
        collectionView.collectionViewLayout = configureLayout()
        
    }
    
    @IBAction func nextExercise(_ sender: Any) {
        let number = Int.random(in: 0 ... countList.count - 1)
        mainTitle.text = "DO"
        countLabel.text = "\(countList[number])"
        exerciseLabel.text = "\(exerciseList[number])"
        (sender as! UIButton).setTitle("NEXT", for: [])
    }
    

}

