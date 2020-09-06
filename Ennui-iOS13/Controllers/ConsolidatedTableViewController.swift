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
    var premises1 = [Item]()
    var premises2 = [Item]()
    var premises3 = [Item]()
    var premises4 = [Item]()
    var premises5 = [Item]()
    var itemArrays = [[Item]]()
    
    var selectedList: Lists? {
        didSet {
            loadItems()
            sortItems()
            itemArrays = appendItemArray()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedList?.buildingName
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemArrays.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionTitle = ""
        switch itemArrays[section] {
        case premises1:
            sectionTitle = selectedList!.premises1!
        case premises2:
            sectionTitle = selectedList!.premises2!
        case premises4:
            sectionTitle = selectedList!.premises3!
        case premises3:
            sectionTitle = selectedList!.premises4!
        case premises5:
            sectionTitle = selectedList!.premises5!
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
        let listPredicate = NSPredicate(format: "parentList.buildingName MATCHES %@", selectedList!.buildingName!)
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
    
    func appendItemArray () -> [[Item]] {
        if selectedList!.premises1 != nil {
            itemArrays.append(premises1)
        }
        if selectedList!.premises2 != nil {
            itemArrays.append(premises2)
        }
        if selectedList!.premises3 != nil {
            itemArrays.append(premises3)
        }
        if selectedList!.premises4 != nil {
            itemArrays.append(premises4)
        }
        if selectedList!.premises5 != nil {
            itemArrays.append(premises5)
        }
        
        return itemArrays
    }
    
    func sortItems() {
        for item in items {
            switch item.premisesIndex {
            case 0:
                if selectedList!.premises1 != nil {
                    premises1.append(item)
                    premises1.sort(by: { $0.itemIndex < $1.itemIndex })
                }
            case 1:
                if selectedList!.premises2 != nil {
                    premises2.append(item)
                    premises2.sort(by: { $0.itemIndex < $1.itemIndex })
                }
            case 2:
                if selectedList!.premises3 != nil {
                    premises3.append(item)
                    premises3.sort(by: { $0.itemIndex < $1.itemIndex })
                }
            case 3:
                if selectedList!.premises4 != nil {
                    premises4.append(item)
                    premises4.sort(by: { $0.itemIndex < $1.itemIndex })
                }
            case 4:
                if selectedList!.premises5 != nil {
                    premises5.append(item)
                    premises5.sort(by: { $0.itemIndex < $1.itemIndex })
                }
            default:
                break
            }
        }
        print("items sorted")
    }
    
    
}
