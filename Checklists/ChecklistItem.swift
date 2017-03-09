//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Noah Patterson on 3/8/17.
//  Copyright © 2017 noahpatterson. All rights reserved.
//

import Foundation

class ChecklistItem  {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
