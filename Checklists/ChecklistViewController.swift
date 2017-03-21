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

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

    var checklist: Checklist!
    
    //delegation - an object will often ask another for help with certain tasks. The object does only what it is good at and lets other objects take care of the rest

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            
            // objects should control their own state
            item.toggleChecked()
            
            configureCheckmark(for: cell, with: item)
            tableView.deselectRow(at: indexPath, animated: true)
//            saveChecklistItems()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // this method allows swipe-to-delete by default. Remove the item from model and tableview
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
//        saveChecklistItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //make sure we are getting the right view controller
        if segue.identifier == "AddItem" {
            let navController = segue.destination as! UINavigationController
            //refers to the screen that is currently in view of the navController
            let controller    = navController.topViewController as! ItemDetailViewController
            controller.delegate = self
        }
        
        if segue.identifier == "EditItem" {
            let navController = segue.destination as! UINavigationController
            //refers to the screen that is currently in view of the navController
            let controller    = navController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
                controller.rowToEdit  = indexPath.row
            }
        }
    }
    
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        addItem(with: item)
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem, at row: Int) {
        checklist.items[row] = item
        
        let indexPath = IndexPath(row: row, section: 0)
        let indexPaths = [indexPath]
        tableView.reloadRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
//        saveChecklistItems()
    }
    
    func addItem(with item: ChecklistItem) {
        let newIndexRow = checklist.items.count
        
        checklist.items.append(item)
        
        //tell the table view to update itself
        let indexPath = IndexPath(row: newIndexRow, section: 0)
        let indexPaths = [indexPath]
        // have to tell the tableview about new rows as well as the model
        tableView.insertRows(at: indexPaths, with: .automatic)
//        saveChecklistItems()
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "✔︎"
        } else {
            label.text = ""
        }
        label.textColor = view.tintColor
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
}





