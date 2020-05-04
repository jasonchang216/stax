//
//  ProfileTableViewController.swift
//  stax
//
//  Created by Jason Chang on 5/3/20.
//  Copyright © 2020 Jason Chang. All rights reserved.
//

import UIKit
import CoreData

class ProfileTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getPreviousData()
        prevCountLabel.text = String(previousCount)
        getRecordData()
        longCountLabel.text = String(recordCount)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPreviousData()
        prevCountLabel.text = String(previousCount)
        getRecordData()
        longCountLabel.text = String(recordCount)
    }
    
    
// MARK: - Core Data and Update Labels

    @IBOutlet weak var prevCountLabel: UILabel!
    @IBOutlet weak var longCountLabel: UILabel!
    
    var previousCount = Int()
    var recordCount = Int()
    
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
            prevCountLabel.text = String(previousCount)
                
        } catch {
            print("Failed")
        }
    }
    
    func getRecordData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sessions")
        request.fetchLimit = 1
        let highestCount : NSSortDescriptor = NSSortDescriptor(key: "sessions", ascending: false)
        request.sortDescriptors = [highestCount]
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                recordCount = data.value(forKey: "sessions") as! Int
            }
            longCountLabel.text = String(recordCount)
                
        } catch {
            print("Failed")
        }
    }
    
// MARK: - Reset Function
    
    @IBAction func resetCount(_ sender: Any) {
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
        getPreviousData()
        prevCountLabel.text = String(0)
        getRecordData()
        longCountLabel.text = String(0)
    }
    
}
