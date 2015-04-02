//
//  AllListsViewController.swift
//  checklists
//
//  Created by wangchi on 14/11/3.
//  Copyright (c) 2014年 wangchi. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate,UINavigationControllerDelegate {


  
    var dataModel:DataModel!

  

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        tableView.separatorColor = view.tintColor
        tableView.tableFooterView = UIView()
      
      
        
        let index = dataModel.indexOfSelectedChecklit
        
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
	
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellidentifier = "Cell"
        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellidentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellidentifier)
            
        }
      
      let image = UIImage(named: "Photos")
      let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
      let frame = CGRectMake(44.0, 44.0, image!.size.width, image!.size.height)
      button.frame = frame
      button.setBackgroundImage(image, forState: .Normal)
      button.backgroundColor = UIColor.clearColor()
      button.addTarget(self, action: Selector("accessoryTapped:event:"), forControlEvents: UIControlEvents.TouchUpInside)
      cell.accessoryView = button
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel?.text = checklist.name
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        cell.textLabel?.font = UIFont(name: "DFWaWaSC-W5", size: 19.0)
        cell.detailTextLabel?.font = UIFont(name: "DFWaWaSC-W5", size: 11.0)
       
        
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "没有事项"
        } else if count == 0 {
            cell.detailTextLabel!.text = "全部完成"
        } else {
            cell.detailTextLabel!.text = "余下\(count)个事项"
        }
        
        cell.imageView?.image = UIImage(named: checklist.iconName)
        
        
        return cell
    }
  
  func accessoryTapped(sender: AnyObject,event: AnyObject) {
    let touches = event.allTouches()
    let touch = touches?.anyObject() as UITouch
    let currentTouchPosion = touch.locationInView(tableView)
    let indexPath = tableView.indexPathForRowAtPoint(currentTouchPosion)
    if indexPath !=  nil {
      tableView(tableView!, accessoryButtonTappedForRowWithIndexPath: indexPath!)
    }
    
  }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        dataModel.indexOfSelectedChecklit = indexPath.row
        
        let list = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: list)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChecklist" {
            let vc = segue.destinationViewController as ChecklistsViewController
            vc.list = sender as checklist
        } else if segue.identifier == "AddChecklist" {
            let navigationcontroller = segue.destinationViewController as UINavigationController
            let vc = navigationcontroller.topViewController as ListDetailViewController
            vc.checklistToEdit = nil
            vc.delegate = self
        }
    }
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
            dismissViewControllerAnimated(true , completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist cl: checklist) {
        
        dataModel.lists.append(cl)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true , completion:nil)
        
    }
    
    
    func listDetailViewController (controller: ListDetailViewController, didFinishEditingChecklist cl: checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        
        dismissViewControllerAnimated(true , completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        
        let indexpaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexpaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNC") as UINavigationController
        let vc = navigationController.topViewController as ListDetailViewController
        
        vc.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        vc.checklistToEdit = checklist
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklit = -1
        }
    }
    
    
    
}
