//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Kejsi Struga on 15/03/2018.
//  Copyright © 2018 Kejsi Struga. All rights reserved.
//

import UIKit
import SwipeCellKit

// Super Class
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
    }
    
    //TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self // we leave this because here we have all the delegate methods that deal with managing the cell !
        
        return cell
    }
    
    // a delegate method, what happends when user swipes on a cell !
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        // closure that decides what happens when we swipe on the cell!s
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // update the model with deletion
         
            self.updateModel(at: indexPath) 
            
        }
        // customize the action appearance => must import some images! from the doc of swipe
        deleteAction.image = UIImage(named: "delete") // name of file in xcassets
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive // destructive expanison style
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update data model in this indexpath
        print ("Deleting in superclass") // will get printed only on super.updateModel() in the subclass
    }
    
}
