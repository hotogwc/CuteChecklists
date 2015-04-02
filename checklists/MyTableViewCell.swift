//
//  MyTableViewCell.swift
//  checklists
//
//  Created by wangchi on 15/3/30.
//  Copyright (c) 2015年 wangchi. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let image = UIImage(named: "Photos")
    let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    let frame = CGRectMake(44.0, 44.0, image!.size.width, image!.size.height)
    button.frame = frame
    button.setBackgroundImage(image, forState: .Normal)
    button.backgroundColor = UIColor.clearColor()
  }
}
