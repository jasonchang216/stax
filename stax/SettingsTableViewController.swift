//
//  SettingsTableViewController.swift
//  stax
//
//  Created by Jason Chang on 4/28/20.
//  Copyright © 2020 Jason Chang. All rights reserved.
//

import UIKit
import CoreData

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            settingTimerSliderOutlet.value = defaults.float(forKey: "timer")
        }
        
        settingsTimerLabel.text = timeString(time: TimeInterval(settingTimerSliderOutlet.value))

    }

//MARK: - Switches

    let defaults = UserDefaults.standard
    
    
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

//MARK: - Timer Settings
    
    @IBOutlet weak var settingsTimerLabel: UILabel!
    @IBOutlet weak var settingTimerSliderOutlet: UISlider!
    
    @IBAction func settingTimerSlider(_ sender: Any) {
        settingsTimerLabel.text = timeString(time: TimeInterval(settingTimerSliderOutlet.value))
        defaults.set(settingTimerSliderOutlet.value, forKey: "timer")
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
}
