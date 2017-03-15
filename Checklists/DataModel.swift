//
//  DataModel.swift
//  Checklists
//
//  Created by Noah Patterson on 3/15/17.
//  Copyright © 2017 noahpatterson. All rights reserved.
//

import Foundation

class DataModel {
    var checklists = [Checklist]()
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistItem")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistItem")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    //data loading and saving
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(checklists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            checklists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
        }
    }
    
    func registerDefaults() {
        let dictionary: [String: Any] = ["ChecklistItem": -1, "FirstTime": true]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime    = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            checklists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
}
