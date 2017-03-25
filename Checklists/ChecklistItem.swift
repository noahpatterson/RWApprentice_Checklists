//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Noah Patterson on 3/8/17.
//  Copyright © 2017 noahpatterson. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, NSCoding  {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    //required by NSCoding
    required init?(coder aDecoder: NSCoder) {
        text    = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID  = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
    
    convenience init(text: String) {
        self.init(text: text, checked: false)
    }
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        itemID = DataModel.nextID()
        super.init()
    }
    
    //deinit is called when the object is about to be destroyed. Because this object is in the Checklist array, this will also be called when the checklist is destroyed.
    deinit {
        removeNotification()
    }
    
    // objects should control their own state
    func toggleChecked() {
        checked = !checked
    }
    
    func scheduleNotification(dueDate: Date) {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            //create TIME_EXPIRED actions
            let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION", title: "Snooze", options: UNNotificationActionOptions(rawValue: 0))
            let rescheduleAction = UNNotificationAction(identifier: "RESCHEDULE_ACTION", title: "Reschedule", options: UNNotificationActionOptions.foreground)
            
            //create TIME_EXPIRED category so we can set a Snooze function and A reschedule function
            let category = UNNotificationCategory(identifier: "TIMER_EXPIRED", actions: [snoozeAction, rescheduleAction], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
            
            
            
            //fill out notification message
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body  = text
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = "TIMER_EXPIRED"
            
            //extract the time items from dueDate
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            //a calendar trigger shows at a specific date instead of UNTimeIntervalNotificationTrigger which is in a number of seconds
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            //add the unique identifier so we can find the notification later to cancel it
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            //hook it up
            let center = UNUserNotificationCenter.current()
            center.setNotificationCategories([category])
            center.add(request)
            
            print("Scheduled notification \(request) for itemID \(itemID)")
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    //mapping the fields to a key
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
}
