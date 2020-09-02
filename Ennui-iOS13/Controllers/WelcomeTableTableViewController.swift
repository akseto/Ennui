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
            let newList = Lists(context: self.context)
            newList.tenantName = textField.text!
            newList.premises = textField2.text!
            newList.date = textField3.text!
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
    
    //MARK: - Add Items Method

    func addItems (selectedList: Lists) {
       
        //General
        let windows = Item(context: context.self)
        windows.title = "Windows"
        windows.categoryName = "General"
        windows.parentList = selectedList
        windows.itemIndex = 0
        windows.categoryIndex = 0
        let entranceDoors = Item(context: context.self)
        entranceDoors.title = "Entrance Doors"
        entranceDoors.categoryName = "General"
        entranceDoors.parentList = selectedList
        entranceDoors.itemIndex = 1
        entranceDoors.categoryIndex = 0
        let exteriorLights = Item(context: context.self)
        exteriorLights.title = "Exterior Lights"
        exteriorLights.categoryName = "General"
        exteriorLights.parentList = selectedList
        exteriorLights.itemIndex = 2
        exteriorLights.categoryIndex = 0
        let stairs = Item(context: context.self)
        stairs.title = "Stairs"
        stairs.categoryName = "General"
        stairs.parentList = selectedList
        stairs.itemIndex = 3
        stairs.categoryIndex = 0
        let loadingRamp = Item(context: context.self)
        loadingRamp.title = "Loading Ramp"
        loadingRamp.categoryName = "General"
        loadingRamp.parentList = selectedList
        loadingRamp.itemIndex = 4
        loadingRamp.categoryIndex = 0
        let signage = Item(context: context.self)
        signage.title = "Signage (Exterior)"
        signage.categoryName = "General"
        signage.parentList = selectedList
        signage.itemIndex = 5
        signage.categoryIndex = 0
        let misc = Item(context: context.self)
        misc.title = "Miscellaneous"
        misc.categoryName = "General"
        misc.parentList = selectedList
        misc.itemIndex = 6
        misc.categoryIndex = 0
        let pullTitle = Item(context: context.self)
        pullTitle.title = "Pull Title for Tenant Caveats"
        pullTitle.categoryName = "General"
        pullTitle.parentList = selectedList
        pullTitle.itemIndex = 7
        pullTitle.categoryIndex = 0
    
        //Office
        let interiorLights = Item(context: context.self)
        interiorLights.title = "Interior Lights"
        interiorLights.categoryName = "Office"
        interiorLights.parentList = selectedList
        interiorLights.itemIndex = 0
        interiorLights.categoryIndex = 1
        let lightLens = Item(context: context.self)
        lightLens.title = "Light Lens"
        lightLens.categoryName = "Office"
        lightLens.parentList = selectedList
        lightLens.itemIndex = 1
        lightLens.categoryIndex = 1
        let carpet = Item(context: context.self)
        carpet.title = "Carpet"
        carpet.categoryName = "Office"
        carpet.parentList = selectedList
        carpet.itemIndex = 2
        carpet.categoryIndex = 1
        let floorTile = Item(context: context.self)
        floorTile.title = "Floor Tile"
        floorTile.categoryName = "Office"
        floorTile.parentList = selectedList
        floorTile.itemIndex = 3
        floorTile.categoryIndex = 1
        let ceilingTile = Item(context: context.self)
        ceilingTile.title = "Ceiling Tile"
        ceilingTile.categoryName = "Office"
        ceilingTile.parentList = selectedList
        ceilingTile.itemIndex = 4
        ceilingTile.categoryIndex = 1
        let drywall = Item(context: context.self)
        drywall.title = "Drywall"
        drywall.categoryName = "Office"
        drywall.parentList = selectedList
        drywall.itemIndex = 5
        drywall.categoryIndex = 1
        let paint = Item(context: context.self)
        paint.title = "Paint"
        paint.categoryName = "Office"
        paint.parentList = selectedList
        paint.itemIndex = 6
        paint.categoryIndex = 1
        let officeWindows = Item(context: context.self)
        officeWindows.title = "Windows"
        officeWindows.categoryName = "Office"
        officeWindows.parentList = selectedList
        officeWindows.itemIndex = 7
        officeWindows.categoryIndex = 1
        let blinds = Item(context: context.self)
        blinds.title = "Blinds"
        blinds.categoryName = "Office"
        blinds.parentList = selectedList
        blinds.itemIndex = 8
        blinds.categoryIndex = 1
        let doors = Item(context: context.self)
        doors.title = "Doors"
        doors.categoryName = "Office"
        doors.parentList = selectedList
        doors.itemIndex = 9
        doors.categoryIndex = 1
        let fireAlarmDevices = Item(context: context.self)
        fireAlarmDevices.title = "Fire Alarm Devices"
        fireAlarmDevices.categoryName = "Office"
        fireAlarmDevices.parentList = selectedList
        fireAlarmDevices.itemIndex = 10
        fireAlarmDevices.categoryIndex = 1
        let securityAlarm = Item(context: context.self)
        securityAlarm.title = "Security Alarm"
        securityAlarm.categoryName = "Office"
        securityAlarm.parentList = selectedList
        securityAlarm.itemIndex = 11
        securityAlarm.categoryIndex = 1
        let electrical = Item(context: context.self)
        electrical.title = "Electrical"
        electrical.categoryName = "Office"
        electrical.parentList = selectedList
        electrical.itemIndex = 12
        electrical.categoryIndex = 1
 
        
        //Kitchen

        let kitchenFixtures = Item(context: context.self)
        kitchenFixtures.title = "Fixtures"
        kitchenFixtures.categoryName = "Kitchen"
        kitchenFixtures.parentList = selectedList
        kitchenFixtures.itemIndex = 0
        kitchenFixtures.categoryIndex = 2
        let walls = Item(context: context.self)
        walls.title = "Walls"
        walls.categoryName = "Kitchen"
        walls.parentList = selectedList
        walls.itemIndex = 1
        walls.categoryIndex = 2
        let kitchenFloors = Item(context: context.self)
        kitchenFloors.title = "Floors"
        kitchenFloors.categoryName = "Kitchen"
        kitchenFloors.parentList = selectedList
        kitchenFloors.itemIndex = 2
        kitchenFloors.categoryIndex = 2
        let ceiling = Item(context: context.self)
        ceiling.title = "Ceiling"
        ceiling.categoryName = "Kitchen"
        ceiling.parentList = selectedList
        ceiling.itemIndex = 3
        ceiling.categoryIndex = 2
        let kitchenElectrical = Item(context: context.self)
        kitchenElectrical.title = "Electrical"
        kitchenElectrical.categoryName = "Kitchen"
        kitchenElectrical.parentList = selectedList
        kitchenElectrical.itemIndex = 4
        kitchenElectrical.categoryIndex = 2
        let dishwasher = Item(context: context.self)
        dishwasher.title = "Dishwasher"
        dishwasher.categoryName = "Kitchen"
        dishwasher.parentList = selectedList
        dishwasher.itemIndex = 5
        dishwasher.categoryIndex = 2
        let kitchenMisc = Item(context: context.self)
        kitchenMisc.title = "Miscellaneous"
        kitchenMisc.categoryName = "Kitchen"
        kitchenMisc.parentList = selectedList
        kitchenMisc.itemIndex = 6
        kitchenMisc.categoryIndex = 2
   
        
        //Washroom

        let washroomFixtures = Item(context: context.self)
        washroomFixtures.title = "Fixtures"
        washroomFixtures.categoryName = "Washroom"
        washroomFixtures.parentList = selectedList
        washroomFixtures.itemIndex = 0
        washroomFixtures.categoryIndex = 3
        let washroomWalls = Item(context: context.self)
        washroomWalls.title = "Walls"
        washroomWalls.categoryName = "Washroom"
        washroomWalls.parentList = selectedList
        washroomWalls.itemIndex = 1
        washroomWalls.categoryIndex = 3
        let washroomFloors = Item(context: context.self)
        washroomFloors.title = "Floors"
        washroomFloors.categoryName = "Washroom"
        washroomFloors.parentList = selectedList
        washroomFloors.itemIndex = 2
        washroomFloors.categoryIndex = 3
        let washroomCeiling = Item(context: context.self)
        washroomCeiling.title = "Ceiling"
        washroomCeiling.categoryName = "Washroom"
        washroomCeiling.parentList = selectedList
        washroomCeiling.itemIndex = 3
        washroomCeiling.categoryIndex = 3
        let washroomElectrical = Item(context: context.self)
        washroomElectrical.title = "Electrical"
        washroomElectrical.categoryName = "Washroom"
        washroomElectrical.parentList = selectedList
        washroomElectrical.itemIndex = 4
        washroomElectrical.categoryIndex = 3
        let washroomMisc = Item(context: context.self)
        washroomMisc.title = "Miscellaneous"
        washroomMisc.categoryName = "Washroom"
        washroomMisc.parentList = selectedList
        washroomMisc.itemIndex = 5
        washroomMisc.categoryIndex = 3
      
        
        //Warehouse
  
        let warehouseElectrical = Item(context: context.self)
        warehouseElectrical.title = "Electrical"
        warehouseElectrical.categoryName = "Warehouse"
        warehouseElectrical.parentList = selectedList
        warehouseElectrical.itemIndex = 0
        warehouseElectrical.categoryIndex = 4
        let manDoor = Item(context: context.self)
        manDoor.title = "Man Door"
        manDoor.categoryName = "Warehouse"
        manDoor.parentList = selectedList
        manDoor.itemIndex = 1
        manDoor.categoryIndex = 4
        let unitHeaters = Item(context: context.self)
        unitHeaters.title = "Unit Heaters"
        unitHeaters.categoryName = "Warehouse"
        unitHeaters.parentList = selectedList
        unitHeaters.itemIndex = 2
        unitHeaters.categoryIndex = 4
        let radiantHeaters = Item(context: context.self)
        radiantHeaters.title = "Radiant Heaters"
        radiantHeaters.categoryName = "Warehouse"
        radiantHeaters.parentList = selectedList
        radiantHeaters.itemIndex = 3
        radiantHeaters.categoryIndex = 4
        let circulationFans = Item(context: context.self)
        circulationFans.title = "Circulation Fans"
        circulationFans.categoryName = "Warehouse"
        circulationFans.parentList = selectedList
        circulationFans.itemIndex = 4
        circulationFans.categoryIndex = 4
        let blockWalls = Item(context: context.self)
        blockWalls.title = "Block Walls"
        blockWalls.categoryName = "Warehouse"
        blockWalls.parentList = selectedList
        blockWalls.itemIndex = 5
        blockWalls.categoryIndex = 4
        let warehouseDrywall = Item(context: context.self)
        warehouseDrywall.title = "Drywall"
        warehouseDrywall.categoryName = "Warehouse"
        warehouseDrywall.parentList = selectedList
        warehouseDrywall.itemIndex = 6
        warehouseDrywall.categoryIndex = 4
        let floor = Item(context: context.self)
        floor.title = "Floor"
        floor.categoryName = "Warehouse"
        floor.parentList = selectedList
        floor.itemIndex = 7
        floor.categoryIndex = 4
        let sump = Item(context: context.self)
        sump.title = "itemObject"
        sump.categoryName = "Warehouse"
        sump.parentList = selectedList
        sump.itemIndex = 8
        sump.categoryIndex = 4
        let overHeadDoors = Item(context: context.self)
        overHeadDoors.title = "Overhead Doors"
        overHeadDoors.categoryName = "Warehouse"
        overHeadDoors.parentList = selectedList
        overHeadDoors.itemIndex = 9
        overHeadDoors.categoryIndex = 4
        let railDoors = Item(context: context.self)
        railDoors.title = "Rail Doors"
        railDoors.categoryName = "Warehouse"
        railDoors.parentList = selectedList
        railDoors.itemIndex = 10
        railDoors.categoryIndex = 4
        let lights = Item(context: context.self)
        lights.title = "Lights"
        lights.categoryName = "Warehouse"
        lights.parentList = selectedList
        lights.itemIndex = 11
        lights.categoryIndex = 4
        let dockLevelerManual = Item(context: context.self)
        dockLevelerManual.title = "Dock Leveler - Manual"
        dockLevelerManual.categoryName = "Warehouse"
        dockLevelerManual.parentList = selectedList
        dockLevelerManual.itemIndex = 12
        dockLevelerManual.categoryIndex = 4
        let hydraulicLift = Item(context: context.self)
        hydraulicLift.title = "Hydraulic Lift (Fluid)"
        hydraulicLift.categoryName = "Warehouse"
        hydraulicLift.parentList = selectedList
        hydraulicLift.itemIndex = 13
        hydraulicLift.categoryIndex = 4
        let ldWeatherStripping = Item(context: context.self)
        ldWeatherStripping.title = "Loading Dock Weather Stripping"
        ldWeatherStripping.categoryName = "Warehouse"
        ldWeatherStripping.parentList = selectedList
        ldWeatherStripping.itemIndex = 14
        ldWeatherStripping.categoryIndex = 4
        let ldCurtains = Item(context: context.self)
        ldCurtains.title = "Loading Dock Curtains"
        ldCurtains.categoryName = "Warehouse"
        ldCurtains.parentList = selectedList
        ldCurtains.itemIndex = 15
        ldCurtains.categoryIndex = 4
        let ldSeals = Item(context: context.self)
        ldSeals.title = "Loading Dock Seals"
        ldSeals.categoryName = "Warehouse"
        ldSeals.parentList = selectedList
        ldSeals.itemIndex = 16
        ldSeals.categoryIndex = 4
        let ldBumpers = Item(context: context.self)
        ldBumpers.title = "Loading Dock Bumpers"
        ldBumpers.categoryName = "Warehouse"
        ldBumpers.parentList = selectedList
        ldBumpers.itemIndex = 17
        ldBumpers.categoryIndex = 4
        
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
