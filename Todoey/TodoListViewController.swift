//
//  ViewController.swift
//  Todoey
//
//  Created by Kejsi Struga on 13/03/2018.
//  Copyright © 2018 Kejsi Struga. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    // table view controller in story board => dont need to link any outlets or set data source or delegates etc , all is setup
    
    var itemArray = ["To Do 1", "To Do2", "To Do 3"]
    
    // user def is saved in the plist file hence dictionary!
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = userDefaults.array(forKey: "ToDoListArray") {
            itemArray = items as! [String]
        }
        
    }
    
    // TableView DataSource Methods! - how many rows to return and what the cells should display
    
    // first data source method - is for the number or rows!!
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    // TAbleView Delegate methods! That gets fired whenever we click a cell in the table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        print (itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        // selection color
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK - Add ne items
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        // A UI alert with a field that lets for insertion of new todos
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            self.itemArray.append(textField.text!)
            
            // save the upadated array in the userdef
            self.userDefaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in // closure
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

