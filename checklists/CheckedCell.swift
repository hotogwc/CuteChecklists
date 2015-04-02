//
//  CheckedCell.swift
//  checklists
//
//  Created by wangchi on 15/4/2.
//  Copyright (c) 2015年 wangchi. All rights reserved.
//

import UIKit

class CheckedCell: UITableViewCell {
  
  lazy var formatter = NSDateFormatter()
  override func awakeFromNib() {
    println("awakefromNib")
  }
  
  func configureCell(item: ChecklistItem) {
    let textFont = UIFont(name: "DFWaWaSC-W5", size: 17.0)
    let detailFont = UIFont(name: "DFWaWaSC-W5", size: 12.0)
    if let font = textFont {
      let textAttributes = [NSFontAttributeName:font]
      let string = NSMutableAttributedString(string: item.text, attributes:textAttributes)
     
      string.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, string.length))
      
      self.textLabel?.attributedText = string
      
    }
    
    if let font = detailFont {
 
      formatter.dateStyle = NSDateFormatterStyle.MediumStyle
      formatter.timeStyle = NSDateFormatterStyle.ShortStyle
      let zhLocale = NSLocale(localeIdentifier: "zh_CN")
      formatter.locale = zhLocale
      
      self.detailTextLabel?.font = font
      self.detailTextLabel?.textColor = UIColor.blackColor()
      self.detailTextLabel?.alpha = 0.5
      self.detailTextLabel?.text = formatter.stringFromDate(item.completionDate)
      
    }

  }
}
