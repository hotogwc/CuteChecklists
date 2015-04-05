//
//  ListDetailViewController.swift
//  checklists
//
//  Created by wangchi on 14/11/4.
//  Copyright (c) 2014年 wangchi. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel (controller: ListDetailViewController)
    
    func listDetailViewController (controller: ListDetailViewController,
        didFinishAddingChecklist cl: checklist )
    
    func listDetailViewController (controller: ListDetailViewController,
        didFinishEditingChecklist cl: checklist)
}


class ListDetailViewController: UITableViewController,UITextFieldDelegate,IconPickerViewControllerDelegate {
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var DoneBarButton: UIBarButtonItem!
  @IBOutlet weak var textLabel: UILabel!
    weak var delegate : ListDetailViewControllerDelegate?
    
    var checklistToEdit : checklist?
    
    var iconName = "Folder"
    
    @IBOutlet weak var iconImageView: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cl = checklistToEdit {
            title = "编辑列表"
            TextField.text = cl.name
            DoneBarButton.enabled = true
            iconName = cl.iconName
        }
        iconImageView.image = UIImage(named: iconName)
        setAppearance()
        tableView.separatorColor = view.tintColor
        tableView.backgroundColor = UIColor.whiteColor()
    }
  
  func setAppearance() {
    let fontName = "DFWaWaSC-W5"
    TextField.font = UIFont(name: fontName, size: 17.0)

    textLabel.font = UIFont(name: fontName, size: 18.0)

    textLabel.textColor = view.tintColor

    
  }
  
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        TextField.becomeFirstResponder()
        
    }
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
        
    }
    
    @IBAction func done(){
        if let ck = checklistToEdit {
            ck.name = TextField.text
            ck.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditingChecklist: ck)
        } else {
            let ck = checklist(name: TextField.text, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAddingChecklist: ck)
        }
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 {
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
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: self.iconName)
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickIcon" {
            let vc = segue.destinationViewController as IconPickerViewController
            vc.delegate = self
            
        }
    }
}
