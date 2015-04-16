//
//  ItemDetailViewController.swift
//  checklists
//
//  Created by wangchi on 14/10/30.
//  Copyright (c) 2014年 wangchi. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller : ItemDetailViewController)
    func itemDetailViewController(controller : ItemDetailViewController,
                                didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(controller :ItemDetailViewController,
                                didFinishEditingItem item: ChecklistItem)
}


class ItemDetailViewController: UITableViewController,UITextFieldDelegate {
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var DoneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwith: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var textLabel1: UILabel!
    @IBOutlet weak var textLabel2: UILabel!
    
    weak var delegate : ItemDetailViewControllerDelegate?
    
    var ItemToEdit : ChecklistItem?
    var dueDate = NSDate()
    var datePickerVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = ItemToEdit {
            title = "编辑事项"
            TextField.text = item.text
            DoneBarButton.enabled = true
            shouldRemindSwith.on = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
      
        tableView.separatorColor = view.tintColor
      setAppearance()
      tableView.backgroundColor = UIColor.whiteColor()
        
    }
  
  func setAppearance() {
    let fontName = "DFWaWaSC-W5"
    TextField.font = UIFont(name: fontName, size: 17.0)
    shouldRemindSwith.tintColor = view.tintColor
    shouldRemindSwith.onTintColor = view.tintColor
    dueDateLabel.font = UIFont(name: fontName, size: 14.0)
    textLabel1.font = UIFont(name: fontName, size: 18.0)
    textLabel2.font = UIFont(name: fontName, size: 18.0)
    textLabel1.textColor = view.tintColor
    textLabel2.textColor = view.tintColor
    
  }
    
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        formatter.locale = NSLocale(localeIdentifier: "zh_CN")
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        
        let indexDateLabel = NSIndexPath(forRow: 1, inSection: 1)
        let indexDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        
        if let dateCell = tableView.cellForRowAtIndexPath(indexDateLabel) {
            dateCell.detailTextLabel?.textColor = dateCell.detailTextLabel?.tintColor
        }
        tableView.beginUpdates()
        
        tableView.insertRowsAtIndexPaths([indexDatePicker], withRowAnimation: UITableViewRowAnimation.Fade)
        tableView.reloadRowsAtIndexPaths([indexDateLabel], withRowAnimation: UITableViewRowAnimation.None)
        tableView.endUpdates()
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexDatePicker) {
            let datePicker = pickerCell.viewWithTag(100) as! UIDatePicker
            datePicker.setDate(dueDate, animated: false)
        }
        
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexDateLabel = NSIndexPath(forRow: 1, inSection: 1)
            let indexDatePicker = NSIndexPath(forRow: 2, inSection: 1)
            
            if let dateCell = tableView.cellForRowAtIndexPath(indexDateLabel) {
                dateCell.detailTextLabel?.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            
            tableView.deleteRowsAtIndexPaths([indexDatePicker], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.reloadRowsAtIndexPaths([indexDateLabel], withRowAnimation: UITableViewRowAnimation.None)
        
            tableView.endUpdates()
            
            
            
            
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as? UITableViewCell
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "DatePickerCell")
                cell.selectionStyle = .None
                
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                datePicker.tag = 100
                datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
                cell.contentView.addSubview(datePicker)
                
                datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
                
            }
            
            return  cell

            
            
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView , numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView , heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        TextField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if datePickerVisible {
                hideDatePicker()
            } else {
                showDatePicker()
            }		
        }
    }
    
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
            
        }
        return super.tableView(tableView , indentationLevelForRowAtIndexPath: indexPath)
    }
    
    func dateChanged(datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    @IBAction func shouldRemindToggled(sender: UISwitch) {
        TextField.resignFirstResponder()
        if sender.on {
            let notificationSettings = UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: nil)
            
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        if let item = ItemToEdit {
            item.text = TextField.text
            item.shouldRemind = shouldRemindSwith.on
            item.dueDate = dueDate
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        } else {
            let item = ChecklistItem()
            item.text = TextField.text
            item.checked = false
            item.shouldRemind = shouldRemindSwith.on
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.TextField.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
            
        }
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = TextField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        if newText.length > 0 {
            DoneBarButton.enabled = true
        } else {
            DoneBarButton.enabled = false
        }
        return true
    }
}
