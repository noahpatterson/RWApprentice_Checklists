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
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
    }
}
