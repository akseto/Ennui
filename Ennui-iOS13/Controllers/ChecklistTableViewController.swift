//
//  ChecklistTableViewController.swift
//  Ennui-iOS13
//
//  Created by Adriana Seto on 2020-08-24.
//  Copyright © 2020 Adriana Seto. All rights reserved.
//

import UIKit
import CoreData


class ChecklistTableViewController: UITableViewController, ItemCellTableViewDelegate {
        
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        deleteAllRecords()
        if items == [Item]() {
            addItems()
        } else {
//            print("Items already added.")
        }
        title = selectedCategory?.name
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }

    
     //MARK: - Model Manipulation Methods
    
     func saveItems() {
         do {
             try context.save()
         } catch {
             print("Error saving context \(error)")
         }
     }
     
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        request.predicate = categoryPredicate
        
        do {
            items = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
    }
     
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemCell
        
        cell.delegate = self
        cell.itemName.text = items[indexPath.row].title
        cell.itemTextField.text = items[indexPath.row].comments
        switch items[indexPath.row].selectedSegment {
        case "Good":
            cell.condition.selectedSegmentIndex = 0
        case "Fair":
            cell.condition.selectedSegmentIndex = 1
        case "Poor":
            cell.condition.selectedSegmentIndex = 2
        case "N/A":
            cell.condition.selectedSegmentIndex = 3
        default:
            cell.condition.selectedSegmentIndex = -1
        }
        
        return cell
        
    }
    
//MARK: - ItemCell Manipulation Methods
    func didSelectSegmentControlCell(cell: ItemCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            items[indexPath.row].selectedSegment = cell.condition.titleForSegment(at: cell.condition.selectedSegmentIndex)
        }
        saveItems()
    }
    
    func textFieldDidEndEditing(cell: ItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            items[indexPath.row].comments = cell.itemTextField.text
            print("textFieldDidEndEditing triggered")
            cell.itemTextField.endEditing(true)
        }
        saveItems()
    }
    
    
        //MARK: - Delete All Records Method (taken from StackOverflow)

    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    //MARK: - Add Items Method
    
    func addItems() {
        switch selectedCategory?.name  {
        case "General":
            let windows = Item(context: context.self)
            windows.title = "Windows"
            windows.parentCategory = selectedCategory
            let entranceDoors = Item(context: context.self)
            entranceDoors.title = "Entrance Doors"
            entranceDoors.parentCategory = selectedCategory
            let exteriorLights = Item(context: context.self)
            exteriorLights.title = "Exterior Lights"
            exteriorLights.parentCategory = selectedCategory
            let stairs = Item(context: context.self)
            stairs.title = "Stairs"
            stairs.parentCategory = selectedCategory
            let loadingRamp = Item(context: context.self)
            loadingRamp.title = "Loading Ramp"
            loadingRamp.parentCategory = selectedCategory
            let signage = Item(context: context.self)
            signage.title = "Signage (Exterior)"
            signage.parentCategory = selectedCategory
            let misc = Item(context: context.self)
            misc.title = "Miscellaneous"
            misc.parentCategory = selectedCategory
            let pullTitle = Item(context: context.self)
            pullTitle.title = "Pull Title for Tenant Caveats"
            pullTitle.parentCategory = selectedCategory
            let itemArray = [windows, entranceDoors, exteriorLights, stairs, loadingRamp, signage, misc, pullTitle]
            items = itemArray.sorted(by: { $0.position < $1.position })
            saveItems()
        case "Office":
            let interiorLights = Item(context: context.self)
            interiorLights.title = "Interior Lights"
            interiorLights.parentCategory = selectedCategory
            let lightLens = Item(context: context.self)
            lightLens.title = "Light Lens"
            lightLens.parentCategory = selectedCategory
            let carpet = Item(context: context.self)
            carpet.title = "Carpet"
            carpet.parentCategory = selectedCategory
            let floorTile = Item(context: context.self)
            floorTile.title = "Floor Tile"
            floorTile.parentCategory = selectedCategory
            let ceilingTile = Item(context: context.self)
            ceilingTile.title = "Ceiling Tile"
            ceilingTile.parentCategory = selectedCategory
            let drywall = Item(context: context.self)
            drywall.title = "Drywall"
            drywall.parentCategory = selectedCategory
            let paint = Item(context: context.self)
            paint.title = "Paint"
            paint.parentCategory = selectedCategory
            let windows = Item(context: context.self)
            windows.title = "Windows"
            windows.parentCategory = selectedCategory
            let blinds = Item(context: context.self)
            blinds.title = "Blinds"
            blinds.parentCategory = selectedCategory
            let doors = Item(context: context.self)
            doors.title = "Doors"
            doors.parentCategory = selectedCategory
            let fireAlarmDevices = Item(context: context.self)
            fireAlarmDevices.title = "Fire Alarm Devices"
            fireAlarmDevices.parentCategory = selectedCategory
            let securityAlarm = Item(context: context.self)
            securityAlarm.title = "Security Alarm"
            securityAlarm.parentCategory = selectedCategory
            let electrical = Item(context: context.self)
            electrical.title = "Electrical"
            electrical.parentCategory = selectedCategory
            items = [interiorLights, lightLens, carpet, floorTile, ceilingTile, drywall, paint, windows, blinds, doors, fireAlarmDevices, securityAlarm, electrical]
            saveItems()
        case "Kitchen":
            let fixtures = Item(context: context.self)
            fixtures.title = "Fixtures"
            fixtures.parentCategory = selectedCategory
            let walls = Item(context: context.self)
            walls.title = "Walls"
            walls.parentCategory = selectedCategory
            let floors = Item(context: context.self)
            floors.title = "Floors"
            floors.parentCategory = selectedCategory
            let ceiling = Item(context: context.self)
            ceiling.title = "Ceiling"
            ceiling.parentCategory = selectedCategory
            let electrical = Item(context: context.self)
            electrical.title = "Electrical"
            electrical.parentCategory = selectedCategory
            let dishwasher = Item(context: context.self)
            dishwasher.title = "Dishwasher"
            dishwasher.parentCategory = selectedCategory
            let misc = Item(context: context.self)
            misc.title = "Miscellaneous"
            misc.parentCategory = selectedCategory
            items = [fixtures, walls, floors, ceiling, electrical, dishwasher, misc]
            saveItems()
        case "Washroom":
            let fixtures = Item(context: context.self)
            fixtures.title = "Fixtures"
            fixtures.parentCategory = selectedCategory
            let walls = Item(context: context.self)
            walls.title = "Walls"
            walls.parentCategory = selectedCategory
            let floors = Item(context: context.self)
            floors.title = "Floors"
            floors.parentCategory = selectedCategory
            let ceiling = Item(context: context.self)
            ceiling.title = "Ceiling"
            ceiling.parentCategory = selectedCategory
            let electrical = Item(context: context.self)
            electrical.title = "Electrical"
            electrical.parentCategory = selectedCategory
            let misc = Item(context: context.self)
            misc.title = "Miscellaneous"
            misc.parentCategory = selectedCategory
            items = [fixtures, walls, floors, ceiling, electrical, misc]
            saveItems()
        case "Warehouse":
            let electrical = Item(context: context.self)
            electrical.title = "Electrical"
            electrical.parentCategory = selectedCategory
            let manDoor = Item(context: context.self)
            manDoor.title = "Man Door"
            manDoor.parentCategory = selectedCategory
            let unitHeaters = Item(context: context.self)
            unitHeaters.title = "Unit Heaters"
            unitHeaters.parentCategory = selectedCategory
            let radiantHeaters = Item(context: context.self)
            radiantHeaters.title = "Radiant Heaters"
            radiantHeaters.parentCategory = selectedCategory
            let circulationFans = Item(context: context.self)
            circulationFans.title = "Circulation Fans"
            circulationFans.parentCategory = selectedCategory
            let blockWalls = Item(context: context.self)
            blockWalls.title = "Block Walls"
            blockWalls.parentCategory = selectedCategory
            let drywall = Item(context: context.self)
            drywall.title = "Drywall"
            drywall.parentCategory = selectedCategory
            let floor = Item(context: context.self)
            floor.title = "Floor"
            floor.parentCategory = selectedCategory
            let sump = Item(context: context.self)
            sump.title = "itemObject"
            sump.parentCategory = selectedCategory
            let overHeadDoors = Item(context: context.self)
            overHeadDoors.title = "Overhead Doors"
            overHeadDoors.parentCategory = selectedCategory
            let railDoors = Item(context: context.self)
            railDoors.title = "Rail Doors"
            railDoors.parentCategory = selectedCategory
            let lights = Item(context: context.self)
            lights.title = "Lights"
            lights.parentCategory = selectedCategory
            let dockLevelerManual = Item(context: context.self)
            dockLevelerManual.title = "Dock Leveler - Manual"
            dockLevelerManual.parentCategory = selectedCategory
            let hydraulicLift = Item(context: context.self)
            hydraulicLift.title = "Hydraulic Lift (Fluid)"
            hydraulicLift.parentCategory = selectedCategory
            let ldWeatherStripping = Item(context: context.self)
            ldWeatherStripping.title = "Loading Dock Weather Stripping"
            ldWeatherStripping.parentCategory = selectedCategory
            let ldCurtains = Item(context: context.self)
            ldCurtains.title = "Loading Dock Curtains"
            ldCurtains.parentCategory = selectedCategory
            let ldSeals = Item(context: context.self)
            ldSeals.title = "Loading Dock Seals"
            ldSeals.parentCategory = selectedCategory
            let ldBumpers = Item(context: context.self)
            ldBumpers.title = "Loading Dock Bumpers"
            ldBumpers.parentCategory = selectedCategory
            items = [electrical, manDoor, unitHeaters, radiantHeaters, circulationFans, blockWalls, drywall, floor, sump, overHeadDoors, railDoors, lights, dockLevelerManual, hydraulicLift, ldWeatherStripping, ldCurtains, ldSeals, ldBumpers]
            saveItems()
            
        default:
            let misc = Item(context: context.self)
            misc.title = "All the Rest"
        }
    }

}
