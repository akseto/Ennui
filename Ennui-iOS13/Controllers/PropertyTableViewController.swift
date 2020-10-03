//
//  PropertyTableViewController.swift
//  Ennui-iOS13
//
//  Created by Adriana Seto on 2020-10-03.
//  Copyright © 2020 Adriana Seto. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class PropertyTableViewController: SwipeTableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var buildings = [Building]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBuildings()
        tableView.rowHeight = 100
        tableView.register(UINib(nibName: "BuildingCell", bundle: nil), forCellReuseIdentifier: "reusableCell")
    }
    
    
    //MARK: - Model Manipulation Methods
    
    func saveBuildings() {
        do {
            try context.save()
        } catch {
            print("Error saving context")
        }
    }
    
    func loadBuildings(with request: NSFetchRequest<Building> = Building.fetchRequest(), searchPredicate: NSPredicate? = nil) {
        
        if let filterPredicate = searchPredicate {
            request.predicate = filterPredicate
        } else {
            request.predicate = nil
        }
        
        do {
            buildings = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        
        if buildings.count == 0 {
            self.tableView.setEmptyMessage("Press the + button to add a a property!")
        } else {
            self.tableView.restore()
        }
        return buildings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! BuildingCell
        cell.delegate = self
        cell.buildingName.text = buildings[indexPath.row].buildingName
        saveBuildings()
        
        return cell
    }
    
    
      //MARK: - TableView Delegate Methods
      
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          performSegue(withIdentifier: "goToLists", sender: self)
      }
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          let destinationVC = segue.destination as! ListTableViewController
          
          if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedBuilding = buildings[indexPath.row]
          }
      }
      
    //MARK: - Add Button Setup
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Building", message: "", preferredStyle: .alert )
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields![0] as UITextField
            let newBuilding = Building(context: self.context)
            newBuilding.buildingName = textField.text!
            self.buildings.append(newBuilding)
            self.saveBuildings()
            self.tableView.reloadData()
        }
        
        action.isEnabled = false
        
        alert.addTextField{ (textField) in
            textField.placeholder = "Building Name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
                if textField.text!.count > 0 {
                    action.isEnabled = true
                } else {
                    action.isEnabled = false 
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        
        alert.addAction(action)
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
        saveBuildings()
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

        let fetchRequest: NSFetchRequest<Building> = Building.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "buildingName CONTAINS[cd] %@", buildings[indexPath.row].buildingName!)
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            context.delete(obj)
        }
        
        buildings.remove(at: indexPath.row)
        saveBuildings()
        
    }
    
    
        //MARK: - Delete All Records Method (taken from StackOverflow)

    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Building")
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
