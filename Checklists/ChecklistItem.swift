//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Noah Patterson on 3/8/17.
//  Copyright © 2017 noahpatterson. All rights reserved.
//

import Foundation

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
    
    // objects should control their own state
    func toggleChecked() {
        checked = !checked
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
