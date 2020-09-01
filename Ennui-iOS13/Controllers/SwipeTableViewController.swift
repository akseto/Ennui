//
//  SwipeTableViewController.swift
//  Ennui-iOS13
//
//  Created by Adriana Seto on 2020-08-25.
//  Copyright © 2020 Adriana Seto. All rights reserved.
//


import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        //we have to change the identifier for both the category and items cell to the more generic "cell" identifier
        
        cell.delegate = self // whenever we set up a delegate, we likely have to setup a protocol (in this case, the SwipeTableViewCellDelegate protocol). update: now that we've created the superclass SwipeTableViewController, we want to remove mention of the swipetableviewcell in the subclass
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "Delete-Icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options    }
    
    func updateModel(at indexPath: IndexPath) {
        
    }
}
