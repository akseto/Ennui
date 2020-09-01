//
//  CategoryTableViewController.swift
//  Ennui-iOS13
//
//  Created by Adriana Seto on 2020-08-24.
//  Copyright © 2020 Adriana Seto. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var categories = [Category]()
    
    var selectedList: Lists? {
        didSet {
            loadCategories()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedList?.premises
        tableView.rowHeight = 120
//        deleteAllRecords()
        if categories == [Category]() {
            addCategories()
        } else {
//            print("Categories already added")
        }
    }
    
    
    //MARK: - Model Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let listPredicate = NSPredicate(format: "parentList.premises MATCHES %@", selectedList!.premises!)
        request.predicate = listPredicate
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        categories[indexPath.row].parentList = self.selectedList
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        cell.textLabel?.font = UIFont(name: "BarlowCondensed-MediumItalic", size: 40)
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        performSegue(withIdentifier: "goToChecklist", sender: self)
    
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ChecklistTableViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            if destinationVC.selectedCategory != categories[indexPath.row] {
                destinationVC.selectedCategory = categories[indexPath.row]
       
            } else {
                print("we ALREADY gave you the selected category!")
            }
        }
    }
    
    
        //MARK: - Delete All Records Method (taken from StackOverflow)

    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    //MARK: Save Checklist Method
    
    
    @IBAction func saveChecklist(_ sender: UIBarButtonItem) {
    }
    
    //MARK: - Add Categories Method
    
    func addCategories() {
        
        let general = Category(context: self.context)
        general.name = "General"
        general.parentList = selectedList
        let office = Category(context: self.context)
        office.name = "Office"
        office.parentList = selectedList
        let kitchen = Category(context: self.context)
        kitchen.name = "Kitchen"
        kitchen.parentList = selectedList
        let washroom = Category(context: self.context)
        washroom.name = "Washroom"
        washroom.parentList = selectedList
        let warehouse = Category(context: self.context)
        warehouse.name = "Warehouse"
        warehouse.parentList = selectedList
        categories = [general, office, kitchen, washroom, warehouse]
        saveCategories()
    }
}
