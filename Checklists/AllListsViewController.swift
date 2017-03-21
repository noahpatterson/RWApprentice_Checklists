//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Noah Patterson on 3/14/17.
//  Copyright © 2017 noahpatterson. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addChecklist))
        self.navigationItem.rightBarButtonItem = addButton
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //switch the view if the user was previously viewing a checklist
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.checklists.count {
            performSegue(withIdentifier: "ShowChecklist", sender: dataModel.checklists[index])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.checklists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = makeCell(for: tableView)
        let checklist = dataModel.checklists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.detailTextLabel!.text = checklist.createSubtitleForCell()
        cell.imageView!.image = UIImage(named: checklist.iconName)
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform the segue manually since there isn't anything in the storyboard to hook up with
        
        //save visted checklist in userDefaults
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.checklists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    //send the checklist to the CheckListView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let navCont = segue.destination as! UINavigationController
            let controller = navCont.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checkListToEdit = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.checklists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        controller.checkListToEdit = dataModel.checklists[indexPath.row]
        
        present(navigationController, animated: true, completion: nil)
    }
    
    func addChecklist() {
        performSegue(withIdentifier: "AddChecklist", sender: nil)
//        let newIndexRow = checklists.count
//        let checklist = Checklist(name: "a new checklist")
//        checklists.append(checklist)
//        
//        //tell the table view to update itself
//        let indexPath = IndexPath(row: newIndexRow, section: 0)
//        let indexPaths = [indexPath]
//        // have to tell the tableview about new rows as well as the model
//        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    // create a tableview cell by code
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        //let newRowIndex = dataModel.checklists.count
        dataModel.checklists.append(checklist)
        
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
        
        
        // all the data needs to be sorted when a new row is added so we'll have to reload the data. Reloading the data automatically inserts the rows
        dataModel.sortChecklists()
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        var oldChecklistName: String?
        if let index = dataModel.checklists.index(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                oldChecklistName = cell.textLabel!.text
                cell.textLabel!.text = checklist.name
            }
        }
        
        //only sort and reload if name actually changed
        if let oldName = oldChecklistName, oldName != checklist.name {
            dataModel.sortChecklists()
            tableView.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
    }

    //navigation delegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            let oldIndex = dataModel.indexOfSelectedChecklist
            let cell = tableView.cellForRow(at: IndexPath(row: oldIndex, section: 0))
            
            cell?.detailTextLabel!.text = dataModel.checklists[oldIndex].createSubtitleForCell()
            dataModel.indexOfSelectedChecklist = -1
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
