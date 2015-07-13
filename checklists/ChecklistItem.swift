//
//  ChecklistItem.swift
//  checklists
//
//  Created by wangchi on 14/10/28.
//  Copyright (c) 2014年 wangchi. All rights reserved.
//

import Foundation
import UIKit

class ChecklistItem: NSObject,NSCoding {
    var text = ""
    var checked = false
    var dueDate = NSDate()
    var shouldRemind = false
    var itemID : Int
    var completionDate = NSDate()
    
    func toggleChecked(){
      if checked == false {
        checked = !checked
        removeNotificationForThisItem()
        shouldRemind = false
      } else {
        checked = !checked
      }
    }
  
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemID, forKey: "ItemID")
        aCoder.encodeObject(completionDate, forKey: "completionDate")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        completionDate  = aDecoder.decodeObjectForKey("completionDate") as! NSDate
        
        super.init()
    }
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    
  func scheduleNotification() {
    let existingNotification = notificationForThisItem()
    if let notification = existingNotification {
      print("Found an existing notification \(notification)")
      UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
    
    if shouldRemind && dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending {
      let localNotification = UILocalNotification()
      localNotification.fireDate = dueDate
      localNotification.timeZone = NSTimeZone.defaultTimeZone()
      localNotification.alertBody = text
      localNotification.soundName = UILocalNotificationDefaultSoundName
      localNotification.userInfo = ["ItemID": itemID]
      
      UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
      print("\(localNotification.userInfo)")
      
  
    }
  }
  
  func notificationForThisItem() -> UILocalNotification? {
    let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
    for notification in allNotifications {
      if let number = notification.userInfo?["ItemID"] as? NSNumber {
        if number.integerValue == itemID {
          return notification
        }
      }
    }
    return nil
  }
  
  func removeNotificationForThisItem() {
    let existingNotification = notificationForThisItem()
    if let notification = existingNotification {
      print("Removing existing notification \(notification)")
      UIApplication.sharedApplication().cancelLocalNotification(notification)
      
    }
    
  }
  
  deinit {
    removeNotificationForThisItem()
  }
    
    
}

