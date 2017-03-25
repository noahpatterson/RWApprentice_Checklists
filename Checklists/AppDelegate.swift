//
//  AppDelegate.swift
//  Checklists
//
//  Created by Noah Patterson on 2/28/17.
//  Copyright © 2017 noahpatterson. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let dataModel = DataModel()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navigationController = window!.rootViewController as! UINavigationController
        let controller           = navigationController.viewControllers[0] as! AllListsViewController
        
        controller.dataModel = dataModel
        
        let center = UNUserNotificationCenter.current()
        
        center.delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("recieved local notification \(notification)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.content.categoryIdentifier == "TIMER_EXPIRED" {
            let itemId = response.notification.request.identifier
            
            var checklistRow = -1
            var checklistItem: ChecklistItem?
            var itemRow: Int?
            for checklist in dataModel.checklists where checklistItem == nil {
                //let item = checklist.items.lazy.filter({ String($0.itemID) == itemId }).first
                let item = checklist.items.first(where: { String($0.itemID) == itemId })
                if let foundItem = item {
                    checklistItem = foundItem
                    itemRow       = checklist.items.index(of: foundItem)
                }
                checklistRow += 1
            }
            if response.actionIdentifier == "SNOOZE_ACTION" {
                checklistItem?.scheduleNotification(dueDate: Date(timeIntervalSinceNow: 60))
                completionHandler()
            }
            
            if response.actionIdentifier == "RESCHEDULE_ACTION" {
                if let item = checklistItem {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let mainNavVC = storyboard.instantiateViewController(withIdentifier: "mainNavController")
//                    let allListsVC = mainNavVC.childViewControllers[0] as! AllListsViewController
//                    
//                    allListsVC.performSegue(withIdentifier: "ShowChecklist", sender: dataModel.checklists[checklistRow])
//                    
//                    let checklistVC = (window!.rootViewController! as! UINavigationController).topViewController as! ChecklistViewController
//                
//
//                    let indexPath = IndexPath(row: itemRow!, section: 0)
//                    let cell = checklistVC.checklistTableView.cellForRow(at: indexPath)
//                    checklistVC.performSegue(withIdentifier: "EditItem", sender: cell)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let checklist = dataModel.checklists[checklistRow]
                    
                    let checklistVC = storyboard.instantiateViewController(withIdentifier: "ChecklistViewController") as! ChecklistViewController
                    checklistVC.checklist = checklist
                    
//                    let itemDetailVC = storyboard.instantiateViewController(withIdentifier: "AddItemViewControlller") as! ItemDetailViewController
//                    itemDetailVC.itemToEdit = item
//                    itemDetailVC.rowToEdit  = itemRow
//                    itemDetailVC.delegate   = checklistVC
                    
                    let rootVC = self.window?.rootViewController!
                    if rootVC is UINavigationController
                    {
                        let navController = rootVC as! UINavigationController
                        if navController.visibleViewController is ItemDetailViewController {
                            navController.dismiss(animated: true)
                        }
                        
                        navController.pushViewController(checklistVC, animated: true)
                        let indexPath = IndexPath(row: itemRow!, section: 0)
                   
                        //let cell = checklistVC.checklistTableView.cellForRow(at: indexPath)

                        
                        checklistVC.performSegue(withIdentifier: "EditItem", sender: indexPath)
                    }
                    else
                    {
                        rootVC?.present(checklistVC, animated: true)
                        let indexPath = IndexPath(row: itemRow!, section: 0)
                        //let cell = checklistVC.checklistTableView.cellForRow(at: indexPath)

                        checklistVC.performSegue(withIdentifier: "EditItem", sender: indexPath)
                    }

                    
                    completionHandler()
                }
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveData()
    }
    
    func saveData() {
        dataModel.saveChecklists()
    }

}

