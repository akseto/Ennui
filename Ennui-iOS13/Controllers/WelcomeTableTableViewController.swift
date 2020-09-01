//
//  WelcomeTableTableViewController.swift
//  Ennui-iOS13
//
//  Created by Adriana Seto on 2020-08-25.
//  Copyright © 2020 Adriana Seto. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework
import SwipeCellKit

class WelcomeTableTableViewController: SwipeTableViewController {


    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var lists = [Lists]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLists()
        tableView.rowHeight = 120
        tableView.register(UINib(nibName: "NewList", bundle: nil), forCellReuseIdentifier: "reusableCell")
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    
    }

    //MARK: - Model Manipulation Methods
    
    func saveLists() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadLists() {
        let request: NSFetchRequest<Lists> = Lists.fetchRequest()
        
        do {
            lists = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        
        if lists.count == 0 {
            self.tableView.setEmptyMessage("Press the + button to begin a new list!")
        } else {
            self.tableView.restore()
        }
        return lists.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! NewList
        cell.delegate = self
        cell.tenantName.text = lists[indexPath.row].tenantName
        cell.premises.text = lists[indexPath.row].premises
        cell.date.text = lists[indexPath.row].date
        saveLists()
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToCategories", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CategoryTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedList = lists[indexPath.row]
        }
    }
    
    
    //MARK: - Add New Lists
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New List", message: "", preferredStyle: .alert )
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields![0] as UITextField
            let textField2 = alert.textFields![1] as UITextField
            let textField3 = alert.textFields![2] as UITextField
            let newList = Lists(context: self.context)
            newList.tenantName = textField.text!
            newList.premises = textField2.text!
            newList.date = textField3.text!
            self.lists.append(newList)
            self.saveLists()
            self.tableView.reloadData()
            print("action completed")
        }
        
        alert.addTextField{ (textField) in
            textField.placeholder = "Tenant name"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Location address"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "dd/mm/yyyy"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addAction(cancel)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)

    }
    
    //MARK: - Delete Data from Swipe
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "Delete-Icon")
        
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options    }
    
    override func updateModel(at indexPath: IndexPath) {
        //we're going to override and update the superclass method, updateModels(at indexPath:) using the following block of code:

        let fetchRequest: NSFetchRequest<Lists> = Lists.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "tenantName CONTAINS[cd] %@", lists[indexPath.row].tenantName!)
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            context.delete(obj)
        }
        
        lists.remove(at: indexPath.row)
        saveLists()
        
    }
    

        //MARK: - Delete All Records Method (taken from StackOverflow)

    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Lists")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}

//MARK: - TableView Extensions
extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "BarlowCondensed-Regular", size: 20)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
