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
    
    //required by NSCoding
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init() {
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
    }
}
