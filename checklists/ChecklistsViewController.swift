//
//  ViewController.swift
//  checklists
//
//  Created by wangchi on 14/10/26.
//  Copyright (c) 2014年 wangchi. All rights reserved.
//

import UIKit
import Foundation


class ChecklistsViewController: UIViewController,ItemDetailViewControllerDelegate,UITableViewDataSource,UITableViewDelegate {
    

    
  @IBOutlet var tableView: UITableView!
 
    var list: checklist!
  var checkedItems = [ChecklistItem]()
  var uncheckedItems = [ChecklistItem]()

  

  
  

    override func viewDidLoad() {
        super.viewDidLoad()
        title = list.name
      tableView.separatorColor = view.tintColor
      tableView.tableFooterView = UIView()
      
      for item in list.items as [ChecklistItem] {
        if item.checked == true {
          checkedItems.append(item)
        } else {
          uncheckedItems.append(item)
        }
      }
      let cellNib = UINib(nibName: "CheckedCell", bundle: nil)
      tableView.registerNib(cellNib, forCellReuseIdentifier: "CheckedCell")
      

      
      
     
        // Do any additional setup after loading the view, typically from a nib.
    }


  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return list.items.count - list.checkedNum
    } else {
      return list.checkedNum
    }
    
        
  }
  
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "未完成"
    } else {
      return "已完成"
    }
  }
  
 
    
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    
    
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as UITableViewCell
      let item = uncheckedItems[indexPath.row]
      
      configureTextForCell(cell, withChecklistItem: item)
      
      return cell
      
      
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("CheckedCell", forIndexPath: indexPath) as CheckedCell
      let item = checkedItems[indexPath.row]
      cell.configureCell(item)
      cell.textLabel?.textColor = view.tintColor
      return cell

      
    }

    


  }
    
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    var item = ChecklistItem()
    if indexPath.section == 0 {
      item = uncheckedItems[indexPath.row]
      uncheckedItems.removeAtIndex(indexPath.row)
    } else if indexPath.section == 1 {
      item = checkedItems[indexPath.row]
      checkedItems.removeAtIndex(indexPath.row)
    }
    
    if let index = find(list.items, item) {
      list.items.removeAtIndex(index)
    }
    
    
      
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
  }
    
    
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    var item = ChecklistItem()
    if indexPath.section == 0 {
      item = uncheckedItems[indexPath.row]
      item.toggleChecked()
      item.completionDate = NSDate()
      uncheckedItems.removeAtIndex(indexPath.row)
      checkedItems.append(item)
  
    } else {
      item = checkedItems[indexPath.row]
      item.toggleChecked()
      checkedItems.removeAtIndex(indexPath.row)
      uncheckedItems.append(item)
    }
    
    tableView.reloadData()
    
        
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
        

    }
     

    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as UILabel
        let font = UIFont(name: "DFWaWaSC-W5", size: 17.0)
        if let font = font {
          let attributes = [NSFontAttributeName:font]
          let string = NSMutableAttributedString(string: item.text, attributes:attributes)
          if item.checked == true {
            string.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, string.length))
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
          
          
          } else {
            cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
          
          }
          
          label.attributedText = string
        
        
        }
      
      
        label.textColor = view.tintColor
    }

    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = uncheckedItems.count
        uncheckedItems.append(item)
        list.items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        
        dismissViewControllerAnimated(true , completion: nil)
       
    }
    
    func itemDetailViewController(controller : ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
      
      if let index = find(uncheckedItems, item) {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
          configureTextForCell(cell, withChecklistItem: item)
        } else if let index = find(checkedItems, item) {
          let indexPath = NSIndexPath(forRow: index, inSection: 1)
          if let cell = tableView.cellForRowAtIndexPath(indexPath) as? CheckedCell {
            cell.configureCell(item)

          }
        }
        
      }
      
      

      dismissViewControllerAnimated(true , completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationcontroller = segue.destinationViewController as UINavigationController
            let controller = navigationcontroller.topViewController as ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationcontroller = segue.destinationViewController as UINavigationController
            let controller = navigationcontroller.topViewController as ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
              if indexPath.section == 0 {
                controller.ItemToEdit = uncheckedItems[indexPath.row]
              } else if indexPath.section == 1{
                controller.ItemToEdit = checkedItems[indexPath.row]
              }
            }
           
            
        }
    }
 


}
	
