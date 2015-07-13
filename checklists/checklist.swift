//
//  checklist.swift
//  checklists
//
//  Created by wangchi on 14/11/3.
//  Copyright (c) 2014年 wangchi. All rights reserved.
//

import UIKit

class checklist: NSObject,NSCoding {
    var name = ""
    var iconName: String
    var items = [ChecklistItem]()
  var checkedNum: Int {
    get {
      var checkedNum = 0
      for item in items as [ChecklistItem] {
        if item.checked ==  true {
          checkedNum += 1
        }
      }
      
      return checkedNum
    }
    
  }
  
  

  
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObjectForKey("IconName") as! String

        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
        aCoder.encodeObject(iconName, forKey: "IconName")

    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items {
            if !item.checked {
                count += 1
            }
        }
        
        return count
    }
    
    
}
