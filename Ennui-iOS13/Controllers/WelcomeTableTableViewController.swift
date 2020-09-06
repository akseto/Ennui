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
        deleteAllRecords()
//        loadLists()
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
        cell.buildingName.text = lists[indexPath.row].buildingName
        cell.date.text = lists[indexPath.row].date
        saveLists()
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToConsolidated", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ConsolidatedTableViewController
        
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
            let textField4 = alert.textFields![3] as UITextField
            let textField5 = alert.textFields![4] as UITextField
            let textField6 = alert.textFields![5] as UITextField
            let textField7 = alert.textFields![6] as UITextField
            let textField8 = alert.textFields![7] as UITextField
            let newList = Lists(context: self.context)
            newList.tenantName = textField.text!
            newList.buildingName = textField2.text!
            newList.date = textField3.text!
            newList.premises1 = textField4.text!
            newList.premises2 = textField5.text!
            newList.premises3 = textField6.text!
            newList.premises4 = textField7.text!
            newList.premises5 = textField8.text!
            self.lists.append(newList)
            self.addItems(selectedList: newList)
            self.saveLists()
            self.tableView.reloadData()
            print("action completed")
        }
        
        alert.addTextField{ (textField) in
            textField.placeholder = "Tenant name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Building name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Unit Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Unit Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Unit Name"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Unit Name"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Unit Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Unit Name"
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
    
    //MARK: - Add Items Method

    func addItems (selectedList: Lists) {
        let ceiling = Item(context: context.self)
        ceiling.title = "Ceiling"
        ceiling.parentList = selectedList
        ceiling.itemIndex = 0
        ceiling.premisesIndex = 0
        let floors = Item(context: context.self)
        floors.title = "Floors"
        floors.parentList = selectedList
        floors.itemIndex = 1
        floors.premisesIndex = 0
        let mainDoors = Item(context: context.self)
        mainDoors.title = "Main Doors"
        mainDoors.parentList = selectedList
        mainDoors.itemIndex = 2
        mainDoors.premisesIndex = 0
        let doors = Item(context: context.self)
        doors.title = "Doors"
        doors.parentList = selectedList
        doors.itemIndex = 3
        doors.premisesIndex = 0
        let janitorial = Item(context: context.self)
        janitorial.title = "Janitorial - Overall Cleanliness"
        janitorial.parentList = selectedList
        janitorial.itemIndex = 4
        janitorial.premisesIndex = 0
        let sidewalks = Item(context: context.self)
        sidewalks.title = "Sidewalks"
        sidewalks.parentList = selectedList
        sidewalks.itemIndex = 5
        sidewalks.premisesIndex = 0
        let signage = Item(context: context.self)
        signage.title = "Signage"
        signage.parentList = selectedList
        signage.itemIndex = 6
        signage.premisesIndex = 0
        let walls = Item(context: context.self)
        walls.title = "Walls"
        walls.parentList = selectedList
        walls.itemIndex = 7
        walls.premisesIndex = 0
        let washrooms = Item(context: context.self)
        washrooms.title = "Washrooms"
        washrooms.parentList = selectedList
        washrooms.itemIndex = 8
        washrooms.premisesIndex = 0
        let windows = Item(context: context.self)
        windows.title = "Windows"
        windows.parentList = selectedList
        windows.itemIndex = 9
        windows.premisesIndex = 0
        let fireSystem = Item(context: context.self)
        fireSystem.title = "Fire System"
        fireSystem.parentList = selectedList
        fireSystem.itemIndex = 10
        fireSystem.premisesIndex = 0
        let lighting = Item(context: context.self)
        lighting.title = "Lighting"
        lighting.parentList = selectedList
        lighting.itemIndex = 11
        lighting.premisesIndex = 0
        let electricalPanel = Item(context: context.self)
        electricalPanel.title = "Electrical Panel"
        electricalPanel.parentList = selectedList
        electricalPanel.itemIndex = 12
        electricalPanel.premisesIndex = 0
        let securitySystem = Item(context: context.self)
        securitySystem.title = "Security System"
        securitySystem.parentList = selectedList
        securitySystem.itemIndex = 13
        securitySystem.premisesIndex = 0
        let plumbing = Item(context: context.self)
        plumbing.title = "Plumbing"
        plumbing.parentList = selectedList
        plumbing.itemIndex = 14
        plumbing.premisesIndex = 0
        let mechanical = Item(context: context.self)
        mechanical.title = "Mechanical (HVAC)"
        mechanical.parentList = selectedList
        mechanical.itemIndex = 15
        mechanical.premisesIndex = 0
        let premisesIsSecure = Item(context: context.self)
        premisesIsSecure.title = "Premises is Secure"
        premisesIsSecure.parentList = selectedList
        premisesIsSecure.itemIndex = 16
        premisesIsSecure.premisesIndex = 0
        let suitability = Item(context: context.self)
        suitability.title = "Suitable for Showing"
        suitability.parentList = selectedList
        suitability.itemIndex = 17
        suitability.premisesIndex = 0
        let emptyOfItems = Item(context: context.self)
        emptyOfItems.title = "Unit Empty of Items"
        emptyOfItems.parentList = selectedList
        emptyOfItems.itemIndex = 18
        emptyOfItems.premisesIndex = 0
        
        //premises 2
        
        let ceiling2 = Item(context: context.self)
        ceiling2.title = "Ceiling"
        ceiling2.parentList = selectedList
        ceiling2.itemIndex = 0
        ceiling2.premisesIndex = 1
        let floors2 = Item(context: context.self)
        floors2.title = "Floors"
        floors2.parentList = selectedList
        floors2.itemIndex = 1
        floors2.premisesIndex = 1
        let mainDoors2 = Item(context: context.self)
        mainDoors2.title = "Main Doors"
        mainDoors2.parentList = selectedList
        mainDoors2.itemIndex = 2
        mainDoors2.premisesIndex = 1
        let doors2 = Item(context: context.self)
        doors2.title = "Doors"
        doors2.parentList = selectedList
        doors2.itemIndex = 3
        doors2.premisesIndex = 1
        let janitorial2 = Item(context: context.self)
        janitorial2.title = "Janitorial - Overall Cleanliness"
        janitorial2.parentList = selectedList
        janitorial2.itemIndex = 4
        janitorial2.premisesIndex = 1
        let sidewalks2 = Item(context: context.self)
        sidewalks2.title = "Sidewalks"
        sidewalks2.parentList = selectedList
        sidewalks2.itemIndex = 5
        sidewalks2.premisesIndex = 1
        let signage2 = Item(context: context.self)
        signage2.title = "Signage"
        signage2.parentList = selectedList
        signage2.itemIndex = 6
        signage2.premisesIndex = 1
        let walls2 = Item(context: context.self)
        walls2.title = "Walls"
        walls2.parentList = selectedList
        walls2.itemIndex = 7
        walls2.premisesIndex = 1
        let washrooms2 = Item(context: context.self)
        washrooms2.title = "Washrooms"
        washrooms2.parentList = selectedList
        washrooms2.itemIndex = 8
        washrooms2.premisesIndex = 1
        let windows2 = Item(context: context.self)
        windows2.title = "Windows"
        windows2.parentList = selectedList
        windows2.itemIndex = 9
        windows2.premisesIndex = 1
        let fireSystem2 = Item(context: context.self)
        fireSystem2.title = "Fire System"
        fireSystem2.parentList = selectedList
        fireSystem2.itemIndex = 10
        fireSystem2.premisesIndex = 1
        let lighting2 = Item(context: context.self)
        lighting2.title = "Lighting"
        lighting2.parentList = selectedList
        lighting2.itemIndex = 11
        lighting2.premisesIndex = 1
        let electricalPanel2 = Item(context: context.self)
        electricalPanel2.title = "Electrical Panel"
        electricalPanel2.parentList = selectedList
        electricalPanel2.itemIndex = 12
        electricalPanel2.premisesIndex = 1
        let securitySystem2 = Item(context: context.self)
        securitySystem2.title = "Security System"
        securitySystem2.parentList = selectedList
        securitySystem2.itemIndex = 13
        securitySystem2.premisesIndex = 1
        let plumbing2 = Item(context: context.self)
        plumbing2.title = "Plumbing"
        plumbing2.parentList = selectedList
        plumbing2.itemIndex = 14
        plumbing2.premisesIndex = 1
        let mechanical2 = Item(context: context.self)
        mechanical2.title = "Mechanical (HVAC)"
        mechanical2.parentList = selectedList
        mechanical2.itemIndex = 15
        mechanical2.premisesIndex = 1
        let premisesIsSecure2 = Item(context: context.self)
        premisesIsSecure2.title = "Premises is Secure"
        premisesIsSecure2.parentList = selectedList
        premisesIsSecure2.itemIndex = 16
        premisesIsSecure2.premisesIndex = 1
        let suitability2 = Item(context: context.self)
        suitability2.title = "Suitable for Showing"
        suitability2.parentList = selectedList
        suitability2.itemIndex = 17
        suitability2.premisesIndex = 1
        let emptyOfItems2 = Item(context: context.self)
        emptyOfItems2.title = "Unit Empty of Items"
        emptyOfItems2.parentList = selectedList
        emptyOfItems2.itemIndex = 18
        emptyOfItems2.premisesIndex = 1
        
        //premises 3
        
        let ceiling3 = Item(context: context.self)
        ceiling3.title = "Ceiling"
        ceiling3.parentList = selectedList
        ceiling3.itemIndex = 0
        ceiling3.premisesIndex = 2
        let floors3 = Item(context: context.self)
        floors3.title = "Floors"
        floors3.parentList = selectedList
        floors3.itemIndex = 1
        floors3.premisesIndex = 2
        let mainDoors3 = Item(context: context.self)
        mainDoors3.title = "Main Doors"
        mainDoors3.parentList = selectedList
        mainDoors3.itemIndex = 2
        mainDoors3.premisesIndex = 2
        let doors3 = Item(context: context.self)
        doors3.title = "Doors"
        doors3.parentList = selectedList
        doors3.itemIndex = 3
        doors3.premisesIndex = 2
        let janitorial3 = Item(context: context.self)
        janitorial3.title = "Janitorial - Overall Cleanliness"
        janitorial3.parentList = selectedList
        janitorial3.itemIndex = 4
        janitorial3.premisesIndex = 2
        let sidewalks3 = Item(context: context.self)
        sidewalks3.title = "Sidewalks"
        sidewalks3.parentList = selectedList
        sidewalks3.itemIndex = 5
        sidewalks3.premisesIndex = 2
        let signage3 = Item(context: context.self)
        signage3.title = "Signage"
        signage3.parentList = selectedList
        signage3.itemIndex = 6
        signage3.premisesIndex = 2
        let walls3 = Item(context: context.self)
        walls3.title = "Walls"
        walls3.parentList = selectedList
        walls3.itemIndex = 7
        walls3.premisesIndex = 2
        let washrooms3 = Item(context: context.self)
        washrooms3.title = "Washrooms"
        washrooms3.parentList = selectedList
        washrooms3.itemIndex = 8
        washrooms3.premisesIndex = 2
        let windows3 = Item(context: context.self)
        windows3.title = "Windows"
        windows3.parentList = selectedList
        windows3.itemIndex = 9
        windows3.premisesIndex = 2
        let fireSystem3 = Item(context: context.self)
        fireSystem3.title = "Fire System"
        fireSystem3.parentList = selectedList
        fireSystem3.itemIndex = 10
        fireSystem3.premisesIndex = 2
        let lighting3 = Item(context: context.self)
        lighting3.title = "Lighting"
        lighting3.parentList = selectedList
        lighting3.itemIndex = 11
        lighting3.premisesIndex = 2
        let electricalPanel3 = Item(context: context.self)
        electricalPanel3.title = "Electrical Panel"
        electricalPanel3.parentList = selectedList
        electricalPanel3.itemIndex = 12
        electricalPanel3.premisesIndex = 2
        let securitySystem3 = Item(context: context.self)
        securitySystem3.title = "Security System"
        securitySystem3.parentList = selectedList
        securitySystem3.itemIndex = 13
        securitySystem3.premisesIndex = 2
        let plumbing3 = Item(context: context.self)
        plumbing3.title = "Plumbing"
        plumbing3.parentList = selectedList
        plumbing3.itemIndex = 14
        plumbing3.premisesIndex = 2
        let mechanical3 = Item(context: context.self)
        mechanical3.title = "Mechanical (HVAC)"
        mechanical3.parentList = selectedList
        mechanical3.itemIndex = 15
        mechanical3.premisesIndex = 2
        let premisesIsSecure3 = Item(context: context.self)
        premisesIsSecure3.title = "Premises is Secure"
        premisesIsSecure3.parentList = selectedList
        premisesIsSecure3.itemIndex = 16
        premisesIsSecure3.premisesIndex = 2
        let suitability3 = Item(context: context.self)
        suitability3.title = "Suitable for Showing"
        suitability3.parentList = selectedList
        suitability3.itemIndex = 17
        suitability3.premisesIndex = 2
        let emptyOfItems3 = Item(context: context.self)
        emptyOfItems3.title = "Unit Empty of Items"
        emptyOfItems3.parentList = selectedList
        emptyOfItems3.itemIndex = 18
        emptyOfItems3.premisesIndex = 2
    
        // premises 4
        let ceiling4 = Item(context: context.self)
        ceiling4.title = "Ceiling"
        ceiling4.parentList = selectedList
        ceiling4.itemIndex = 0
        ceiling4.premisesIndex = 3
        let floors4 = Item(context: context.self)
        floors4.title = "Floors"
        floors4.parentList = selectedList
        floors4.itemIndex = 1
        floors4.premisesIndex = 3
        let mainDoors4 = Item(context: context.self)
        mainDoors4.title = "Main Doors"
        mainDoors4.parentList = selectedList
        mainDoors4.itemIndex = 2
        mainDoors4.premisesIndex = 3
        let doors4 = Item(context: context.self)
        doors4.title = "Doors"
        doors4.parentList = selectedList
        doors4.itemIndex = 4
        doors4.premisesIndex = 3
        let janitorial4 = Item(context: context.self)
        janitorial4.title = "Janitorial - Overall Cleanliness"
        janitorial4.parentList = selectedList
        janitorial4.itemIndex = 4
        janitorial4.premisesIndex = 3
        let sidewalks4 = Item(context: context.self)
        sidewalks4.title = "Sidewalks"
        sidewalks4.parentList = selectedList
        sidewalks4.itemIndex = 5
        sidewalks4.premisesIndex = 3
        let signage4 = Item(context: context.self)
        signage4.title = "Signage"
        signage4.parentList = selectedList
        signage4.itemIndex = 6
        signage4.premisesIndex = 3
        let walls4 = Item(context: context.self)
        walls4.title = "Walls"
        walls4.parentList = selectedList
        walls4.itemIndex = 7
        walls4.premisesIndex = 3
        let washrooms4 = Item(context: context.self)
        washrooms4.title = "Washrooms"
        washrooms4.parentList = selectedList
        washrooms4.itemIndex = 8
        washrooms4.premisesIndex = 3
        let windows4 = Item(context: context.self)
        windows4.title = "Windows"
        windows4.parentList = selectedList
        windows4.itemIndex = 9
        windows4.premisesIndex = 3
        let fireSystem4 = Item(context: context.self)
        fireSystem4.title = "Fire System"
        fireSystem4.parentList = selectedList
        fireSystem4.itemIndex = 10
        fireSystem4.premisesIndex = 3
        let lighting4 = Item(context: context.self)
        lighting4.title = "Lighting"
        lighting4.parentList = selectedList
        lighting4.itemIndex = 11
        lighting4.premisesIndex = 3
        let electricalPanel4 = Item(context: context.self)
        electricalPanel4.title = "Electrical Panel"
        electricalPanel4.parentList = selectedList
        electricalPanel4.itemIndex = 12
        electricalPanel4.premisesIndex = 3
        let securitySystem4 = Item(context: context.self)
        securitySystem4.title = "Security System"
        securitySystem4.parentList = selectedList
        securitySystem4.itemIndex = 13
        securitySystem4.premisesIndex = 3
        let plumbing4 = Item(context: context.self)
        plumbing4.title = "Plumbing"
        plumbing4.parentList = selectedList
        plumbing4.itemIndex = 14
        plumbing4.premisesIndex = 3
        let mechanical4 = Item(context: context.self)
        mechanical4.title = "Mechanical (HVAC)"
        mechanical4.parentList = selectedList
        mechanical4.itemIndex = 15
        mechanical4.premisesIndex = 3
        let premisesIsSecure4 = Item(context: context.self)
        premisesIsSecure4.title = "Premises is Secure"
        premisesIsSecure4.parentList = selectedList
        premisesIsSecure4.itemIndex = 16
        premisesIsSecure4.premisesIndex = 3
        let suitability4 = Item(context: context.self)
        suitability4.title = "Suitable for Showing"
        suitability4.parentList = selectedList
        suitability4.itemIndex = 17
        suitability4.premisesIndex = 3
        let emptyOfItems4 = Item(context: context.self)
        emptyOfItems4.title = "Unit Empty of Items"
        emptyOfItems4.parentList = selectedList
        emptyOfItems4.itemIndex = 18
        emptyOfItems4.premisesIndex = 3
        
        //premises 5
        
        let ceiling5 = Item(context: context.self)
        ceiling5.title = "Ceiling"
        ceiling5.parentList = selectedList
        ceiling5.itemIndex = 0
        ceiling5.premisesIndex = 4
        let floors5 = Item(context: context.self)
        floors5.title = "Floors"
        floors5.parentList = selectedList
        floors5.itemIndex = 1
        floors5.premisesIndex = 4
        let mainDoors5 = Item(context: context.self)
        mainDoors5.title = "Main Doors"
        mainDoors5.parentList = selectedList
        mainDoors5.itemIndex = 2
        mainDoors5.premisesIndex = 4
        let doors5 = Item(context: context.self)
        doors5.title = "Doors"
        doors5.parentList = selectedList
        doors5.itemIndex = 3
        doors5.premisesIndex = 4
        let janitorial5 = Item(context: context.self)
        janitorial5.title = "Janitorial - Overall Cleanliness"
        janitorial5.parentList = selectedList
        janitorial5.itemIndex = 4
        janitorial5.premisesIndex = 4
        let sidewalks5 = Item(context: context.self)
        sidewalks5.title = "Sidewalks"
        sidewalks5.parentList = selectedList
        sidewalks5.itemIndex = 5
        sidewalks5.premisesIndex = 4
        let signage5 = Item(context: context.self)
        signage5.title = "Signage"
        signage5.parentList = selectedList
        signage5.itemIndex = 6
        signage5.premisesIndex = 4
        let walls5 = Item(context: context.self)
        walls5.title = "Walls"
        walls5.parentList = selectedList
        walls5.itemIndex = 7
        walls5.premisesIndex = 4
        let washrooms5 = Item(context: context.self)
        washrooms5.title = "Washrooms"
        washrooms5.parentList = selectedList
        washrooms5.itemIndex = 8
        washrooms5.premisesIndex = 4
        let windows5 = Item(context: context.self)
        windows5.title = "Windows"
        windows5.parentList = selectedList
        windows5.itemIndex = 9
        windows5.premisesIndex = 4
        let fireSystem5 = Item(context: context.self)
        fireSystem5.title = "Fire System"
        fireSystem5.parentList = selectedList
        fireSystem5.itemIndex = 10
        fireSystem5.premisesIndex = 4
        let lighting5 = Item(context: context.self)
        lighting5.title = "Lighting"
        lighting5.parentList = selectedList
        lighting5.itemIndex = 11
        lighting5.premisesIndex = 4
        let electricalPanel5 = Item(context: context.self)
        electricalPanel5.title = "Electrical Panel"
        electricalPanel5.parentList = selectedList
        electricalPanel5.itemIndex = 12
        electricalPanel5.premisesIndex = 4
        let securitySystem5 = Item(context: context.self)
        securitySystem5.title = "Security System"
        securitySystem5.parentList = selectedList
        securitySystem5.itemIndex = 13
        securitySystem5.premisesIndex = 4
        let plumbing5 = Item(context: context.self)
        plumbing5.title = "Plumbing"
        plumbing5.parentList = selectedList
        plumbing5.itemIndex = 14
        plumbing5.premisesIndex = 4
        let mechanical5 = Item(context: context.self)
        mechanical5.title = "Mechanical (HVAC)"
        mechanical5.parentList = selectedList
        mechanical5.itemIndex = 15
        mechanical5.premisesIndex = 4
        let premisesIsSecure5 = Item(context: context.self)
        premisesIsSecure5.title = "Premises is Secure"
        premisesIsSecure5.parentList = selectedList
        premisesIsSecure5.itemIndex = 16
        premisesIsSecure5.premisesIndex = 4
        let suitability5 = Item(context: context.self)
        suitability5.title = "Suitable for Showing"
        suitability5.parentList = selectedList
        suitability5.itemIndex = 17
        suitability5.premisesIndex = 4
        let emptyOfItems5 = Item(context: context.self)
        emptyOfItems5.title = "Unit Empty of Items"
        emptyOfItems5.parentList = selectedList
        emptyOfItems5.itemIndex = 18
        emptyOfItems5.premisesIndex = 4
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

extension Item {
    convenience init(context: NSManagedObjectContext, title: String, parentList: Lists, itemIndex: Int16, premisesIndex: Int16) {
        self.init(context: context.self)
        self.title = title
        self.parentList = parentList
        self.itemIndex = itemIndex
        self.premisesIndex = premisesIndex
    }
}
