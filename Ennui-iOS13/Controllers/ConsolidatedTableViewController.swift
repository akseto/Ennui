//
//  ConsolidatedTableViewController.swift
//  Ennui-iOS13
//
//  Created by Adriana Seto on 2020-09-01.
//  Copyright © 2020 Adriana Seto. All rights reserved.
//

import UIKit
import CoreData

class ConsolidatedTableViewController: UITableViewController, ItemCellTableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()
    var items = [Item]()
    var generalCategory = [Item]()
    var officeCategory = [Item]()
    var washroomCategory = [Item]()
    var kitchenCategory = [Item]()
    var warehouseCategory = [Item]()
    var itemArrays = [[Item]]()
    
    var selectedList: Lists? {
        didSet {
            loadItems()
            sortItems()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedList?.premises
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        itemArrays = [generalCategory, officeCategory, kitchenCategory, washroomCategory, warehouseCategory]
        return itemArrays.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionTitle = ""
        switch itemArrays[section] {
        case generalCategory:
            sectionTitle = "General"
        case officeCategory:
            sectionTitle = "Office"
        case kitchenCategory:
            sectionTitle = "Kitchen"
        case washroomCategory:
            sectionTitle = "Washroom"
        case warehouseCategory:
            sectionTitle = "Warehouse"
        default:
            break
        }
        
        return sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArrays[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemCell
        
        cell.delegate = self
        cell.itemName.text = itemArrays[indexPath.section][indexPath.row].title
        cell.itemTextView.text = itemArrays[indexPath.section][indexPath.row].comments
        
        switch itemArrays[indexPath.section][indexPath.row].selectedSegment {
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
    

    
    
    //MARK: - ItemCell Delegate Methods
    func didSelectSegmentControlCell(cell: ItemCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            itemArrays[indexPath.section][indexPath.row].selectedSegment = cell.condition.titleForSegment(at: cell.condition.selectedSegmentIndex)
        }
        saveItems()
    }
    
    
    func textViewDidChange(cell: ItemCell) {
        cell.itemTextView.textContainer.heightTracksTextView = true
        cell.itemTextView.isScrollEnabled = false
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    func textViewDidEndEditing(cell: ItemCell) {
        cell.itemTextView.resignFirstResponder()
        if let indexPath = tableView.indexPath(for: cell) {
            itemArrays[indexPath.section][indexPath.row].comments = cell.itemTextView.text
            print("textFieldDidEndEditing triggered")
            cell.itemTextView.endEditing(true)
        }
        saveItems()
    }
    
    
    
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let listPredicate = NSPredicate(format: "parentList.premises MATCHES %@", selectedList!.premises!)
        request.predicate = listPredicate
        
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        print("items loaded")
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func sortItems() {
        for item in items {
            switch item.categoryIndex {
            case 0:
                generalCategory.append(item)
            case 1:
                officeCategory.append(item)
            case 2:
                kitchenCategory.append(item)
            case 3:
                washroomCategory.append(item)
            case 4:
                warehouseCategory.append(item)
            default:
                break
            }
            generalCategory.sort(by: { $0.itemIndex < $1.itemIndex })
            officeCategory.sort(by: { $0.itemIndex < $1.itemIndex })
            washroomCategory.sort(by: { $0.itemIndex < $1.itemIndex })
            kitchenCategory.sort(by: { $0.itemIndex < $1.itemIndex })
            warehouseCategory.sort(by: { $0.itemIndex < $1.itemIndex })
        }
        print("items sorted")
    }
    
    
}
