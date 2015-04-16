//
//  DataModel.swift
//  checklists
//
//  Created by wangchi on 14/11/7.
//  Copyright (c) 2014年 wangchi. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [checklist]()
    
    var indexOfSelectedChecklit: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
        }
    }
    
    func registerDefaults() {
        let dictionary = ["ChecklistIndex": -1,"FirstTime": true,"ChecklistItemID": 0]
        
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    
    func handleFirstTime() {
        let firstTime = NSUserDefaults.standardUserDefaults().boolForKey("FirstTime")
        if firstTime {
            let cl = checklist(name: "list")
            lists.append(cl)
            indexOfSelectedChecklit = 0
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FirstTime")
        }
    }
    
    
    //save and load methods
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as! [String]
        
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentsDirectory().stringByAppendingPathComponent("checklists.plist")
    }
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            let data = NSData(contentsOfFile: path)
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
            lists = unarchiver.decodeObjectForKey("Checklists") as! [checklist]
            unarchiver.finishDecoding()
            sortChecklists()

            
        }
    }
    //sort method
    
    func sortChecklists() {
        lists.sort({ checklist1, checklist2 in return
            checklist1.name.localizedStandardCompare(checklist2.name) == NSComparisonResult.OrderedAscending })
    }
    init() {
        loadChecklists()
        
        registerDefaults()
        handleFirstTime()
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let itemID = userDefault.integerForKey("ChecklistItemID")
        userDefault.setInteger(itemID+1, forKey: "ChecklistItemID")
        userDefault.synchronize()
        return itemID
        
    }
    
}
