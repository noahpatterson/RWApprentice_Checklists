//
//  ViewController.swift
//  Checklists
//
//  Created by Noah Patterson on 2/28/17.
//  Copyright © 2017 noahpatterson. All rights reserved.
//

/*
 Delegates in five easy steps
 These are the steps for setting up the delegate pattern between two objects, where object A is the delegate for object B, and object B will send messages back to A. The steps are:
 1 - Define a delegate protocol for object B.
 2 - Give object B a delegate optional variable. This variable should be weak.
 3 - Make object B send messages to its delegate when something interesting happens, such as the user pressing the Cancel or Done buttons, or when it needs a piece of information. You write delegate?.methodName(self, . . .)
 4 - Make object A conform to the delegate protocol. It should put the name of the protocol in its class line and implement the methods from the protocol.
 5 - Tell object B that object A is now its delegate.
 */

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //make sure we are getting the right view controller
        if segue.identifier == "AddItem" {
            let navController = segue.destination as! UINavigationController
            //refers to the screen that is currently in view of the navController
            let controller    = navController.topViewController as! AddItemViewController
            controller.delegate = self
        }
    }
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
        addItem(with: item)
        dismiss(animated: true, completion: nil)
    }
    
    func addItem(with item: ChecklistItem) {
        let newIndexRow = items.count
        
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





