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

  
  
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        title = list.name
      tableView.separatorColor = view.tintColor
      tableView.tableFooterView = UIView()

      
      
     
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.items.count
        
    }
  
 
    
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as UITableViewCell
        
        let label = cell.viewWithTag(1000) as UILabel
        let item = list.items[indexPath.row]
   
        configureTextForCell(cell, withChecklistItem: item)
    

        return cell
    }
    
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        list.items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
    }
    
    
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      

        let item = list.items[indexPath.row]
        item.toggleChecked()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)

    
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        

    }
     

    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as UILabel
        let font = UIFont(name: "DFWaWaSC-W5", size: 17.0)
      if let font = font {
        let attributes = [NSFontAttributeName:font]
        let string = NSMutableAttributedString(string: item.text, attributes:attributes)
        if item.checked == true {
          string.addAttribute(NSStrikethroughStyleAttributeName, value:NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, string.length))
        }
        
        label.attributedText = string
      
      }
      
      
        label.textColor = view.tintColor
    }

    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = list.items.count
        list.items.append(item)
        
      let indexPath = NSIndexPath(forRow: newRowIndex, inSection: item.checked ? 1 : 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        
        dismissViewControllerAnimated(true , completion: nil)
       
    }
    
    func itemDetailViewController(controller : ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {

        if let index = find(list.items, item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell , withChecklistItem: item)
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
                controller.ItemToEdit = list.items[indexPath.row]
            }
           
            
        }
    }
 


}
	
