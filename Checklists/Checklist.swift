//
//  Checklist.swift
//  Checklists
//
//  Created by Noah Patterson on 3/14/17.
//  Copyright © 2017 noahpatterson. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
//    
//    override init() {
//        super.init()
//    }
//    
    init(name: String) {
        self.name = name
        iconName = "No Icon"
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    
    func countUncheckedItems() -> Int {
        return items.filter({ $0.checked == false }).count
    }
    
    func createSubtitleForCell() -> String {
        let numUnChecked = countUncheckedItems()
        
        if items.count == 0 {
            return "(no items)"
        }
        
        if numUnChecked == 0 {
            return "All Done!"
        }
        
        return "\(numUnChecked) remaining"
    }
}
