//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Noah Patterson on 3/9/17.
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

// make a delegate protocol for the caller of this viewController to be able to respond to actions
// of this view controller.
protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem, at row: Int)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    /*
    Three steps to delegation:
    1. declare parent view controller as capable of being a delegate
    2. let the object know that it has a delegate parent
    3. Implement delegate methods in parent
    */
    
    @IBOutlet weak var addItemTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var notifyDateLabel: UILabel!
    
    
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    var rowToEdit: Int?
    var shouldNotify = false
    
    @IBAction func toggleNotify(_ sender: UISwitch) {
        shouldNotify = sender.isOn
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func save() {
        if let item = itemToEdit {
            item.text = addItemTextField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item, at: rowToEdit!)
        } else {
            let item = ChecklistItem(text: addItemTextField.text!)
            
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //automatically open the keyboard when the scene loads
        addItemTextField.becomeFirstResponder()
        addItemTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            addItemTextField.text = item.text
            saveButton.isEnabled = true
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        //returning nil here says that the row is not selectable
        return nil
    }
    
    //text field delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let oldText = textField.text! as NSString
//        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
//        
//        if newText.length > 0 {
//            saveButton.isEnabled = true
//        } else {
//            saveButton.isEnabled = false
//        }
        saveButton.isEnabled = (string.characters.count > 0)
        
        return true
    }
}
