//
//  ViewController.swift
//  Checklists
//
//  Created by Noah Patterson on 2/28/17.
//  Copyright © 2017 noahpatterson. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var items: [ChecklistItem]
    
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        
//        let row0item = ChecklistItem()
//        row0item.text = "walk the dog"
//        row0item.checked = false
//        items.append(row0item)
//        
//        let row1item = ChecklistItem()
//        row1item.text = "Brush my teeth"
//        row1item.checked = true
//        items.append(row1item)
//        
//        let row2item = ChecklistItem()
//        row2item.text = "Learn iOS development"
//        row2item.checked = true
//        items.append(row2item)
//        
//        let row3item = ChecklistItem()
//        row3item.text = "Soccer practice"
//        row3item.checked = false
//        items.append(row3item)
//        
//        let row4item = ChecklistItem()
//        row4item.text = "Eat ice cream"
//        row4item.checked = true
//        items.append(row4item)
        
        super.init(coder: aDecoder)
    }
    
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
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            
            // objects should control their own state
            item.toggleChecked()
            
            configureCheckmark(for: cell, with: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // this method allows swipe-to-delete by default. Remove the item from model and tableview
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    @IBAction func addItem(_ sender: Any) {
        let newIndexRow = items.count
        
        let item = ChecklistItem()
        item.text = "A new item"
        items.append(item)
        
        //tell the table view to update itself
        let indexPath = IndexPath(row: newIndexRow, section: 0)
        let indexPaths = [indexPath]
        // have to tell the tableview about new rows as well as the model
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
}





