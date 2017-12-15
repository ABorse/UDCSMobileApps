//
//  ScoreTable.swift
//  Final
//
//  Created by aborse on 12/14/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit
import CoreData

class ScoreTable {
    
    static var table = ScoreTable()
    var scores: [NSManagedObject] = []
    
    func save(name: String, score: Int32) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Entry",
                                       in: managedContext)!
        
        let entry = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        entry.setValue(name, forKeyPath: "name")
        entry.setValue(score, forKeyPath: "score")
        
        
        // 4
        do {
            try managedContext.save()
            scores.append(entry)
            scores.sort(by: sortScores)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func get() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Entry")
        
        //3
        do {
            scores = try managedContext.fetch(fetchRequest)
            scores.sort(by: sortScores)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func sortScores(a: NSManagedObject, b: NSManagedObject) -> Bool {
        let ascore = a.value(forKey: "score") as! Int32
        let bscore = b.value(forKey: "score") as! Int32
        if(ascore > bscore) {
            return true
        }
        return false
    }
    
}
