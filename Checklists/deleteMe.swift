//
//  deleteMe.swift
//  Checklists
//
//  Created by Noah Patterson on 3/14/17.
//  Copyright © 2017 noahpatterson. All rights reserved.
//

import Foundation

//use the docuements directory
func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklists.plist")
}

//save the data to Checklists.plist
func saveChecklistItems() {
    let items = [ChecklistItem]()
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: data)
    
    //requires items to apply to the NSCoding protocol
    archiver.encode(items, forKey: "checklistItems")
    archiver.finishEncoding()
    data.write(to: dataFilePath(), atomically: true)
}

func loadChecklistItems() {
    var items = [ChecklistItem]()
    let path = dataFilePath()
    
    if let data = try? Data(contentsOf: path) {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        items = unarchiver.decodeObject(forKey: "checklistItems") as! [ChecklistItem]
        unarchiver.finishDecoding()
    }
}
