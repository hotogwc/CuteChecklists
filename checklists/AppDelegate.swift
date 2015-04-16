//
//  AppDelegate.swift
//  checklists
//
//  Created by wangchi on 14/10/26.
//  Copyright (c) 2014年 wangchi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataModel = DataModel()
    func saveData() {
        dataModel.saveChecklists()
    }
  func customAppearance() {
    let titleFont = UIFont(name: "DFWaWaSC-W5", size: 21.0)
    let buttonFont = UIFont(name: "DFWaWaSC-W5", size: 18.0)
    let color = window!.rootViewController?.view.tintColor
    if let titlefont  = titleFont {
      if let buttonfont = buttonFont {
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName:titlefont, NSForegroundColorAttributeName:color! as UIColor]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName:buttonfont, NSForegroundColorAttributeName:color! as UIColor], forState: UIControlState.Normal)
          UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName:buttonfont, NSForegroundColorAttributeName:UIColor.grayColor()], forState: UIControlState.Disabled)
        
      }

    }
    UINavigationBar.appearance().tintColor = window!.rootViewController?.view.tintColor
    UINavigationBar.appearance().backgroundColor = UIColor.grayColor()
    window!.tintColor = UIColor.redColor()
    
    
  }
  

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      
        // Override point for customization after application launch.
        let NavigationController = window!.rootViewController as! UINavigationController
        let vc = NavigationController.viewControllers[0] as! AllListsViewController
        vc.dataModel = dataModel
        customAppearance()
        
        
        return true
    }
	
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        saveData()
        println("called")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        saveData()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

