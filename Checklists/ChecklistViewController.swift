//
//  ViewController.swift
//  Checklists
//
//  Created by Noah Patterson on 2/28/17.
//  Copyright © 2017 noahpatterson. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var row0item: ChecklistItem
    var row1item: ChecklistItem
    var row2item: ChecklistItem
    var row3item: ChecklistItem
    var row4item: ChecklistItem
    
    //delegation - an object will often ask another for help with certain tasks. The object does only what it is good at and lets other objects take care of the rest

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        
        switch indexPath.row % 5 {
        case 0:
            label.text = "Walk the dog"
        case 1:
            label.text = "Brush my teeth"
        case 2:
            label.text = "Learn iOS development"
        case 3:
            label.text = "Soccer practice"
        case 4:
            label.text = "Eat ice cream"
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            switch cell.accessoryType {
                case .none:
                    cell.accessoryType = .checkmark
            case .checkmark:
                cell.accessoryType = .none
                default:
                    cell.accessoryType = .none
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}





