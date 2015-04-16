//
//  IconPickerViewController.swift
//  checklists
//
//  Created by wangchi on 14/11/11.
//  Copyright (c) 2014年 wangchi. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String)
}

class IconPickerViewController: UITableViewController {
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = ["No Icon","Appointments","Birthdays","Chores","Drinks","Folder","Groceries","Inbox","Photos","Trips"]
  
    let iconscn = ["无图标","约会","生日","家务","聚会","文件夹","采购","收件箱","照片","旅行"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorColor = view.tintColor
  }
  
  
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IconCell") as! UITableViewCell
        
        let iconName = iconscn[indexPath.row]
        let iconImage = icons[indexPath.row]
        cell.textLabel?.font = UIFont(name: "DFWaWaSC-W5", size: 21.0)
        cell.textLabel?.text = iconName
        cell.imageView?.image = UIImage(named: iconImage)
        cell.textLabel?.textColor = view.tintColor
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let iconName = icons[indexPath.row]
        delegate?.iconPicker(self, didPickIcon: iconName)

        
        
    }
    
}
