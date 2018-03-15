//
//  ViewController.swift
//  Todoey
//
//  Created by Kejsi Struga on 13/03/2018.
//  Copyright © 2018 Kejsi Struga. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class TodoListViewController: UITableViewController {

    // (UIApplication.shared) -> singleton; will correspond to a live app; as! -> downcast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // table view controller in story board => dont need to link any outlets or set data source or delegates etc , all is setup
    
    var itemArray = [Item]()
    
    // datatype of optional category, bcz its gonna be nil until we assign the category
    var selectedCategory : Category? {
        didSet{
            // WE ARE CERTAIN THAT WE GOT A VALUE FROM THE SELECTED CATEGORY => NOT CRASH OUR APP
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // user def is saved in the plist file hence dictionary!
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
    }
    
    // TableView DataSource Methods! - how many rows to return and what the cells should display
    // first data source method - is for the number or rows!!
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    // TAbleView Delegate methods! That gets fired whenever we click a cell in the table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        saveData()
        
        // selection color
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK - Add in items
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        // A UI alert with a field that lets for insertion of new todos
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            // also specify the parent category, which is available bcz we created the relationship!
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveData ()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in // closure
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData () {
        
        do {
           try context.save()
        } catch {
            print ("Errror saving context, \(error)")
        }
       
        self.tableView.reloadData() // => its datasource methods are called again => reloading the data
        
    }
    
    // = Item.fetchRequest() => for default values!
    // predicate is for search queries
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        // load only items that have the parent category as the selectedCategory => we need to query the db
        // an filter the results => create a predicate
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            //compaund predicate
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:  [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
         tableView.reloadData()
    }
    
}
//MARK: - Search bar methods
//Splitting the functionality of the viewcontroller
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptr = NSSortDescriptor(key: "title", ascending: true)
       
        request.sortDescriptors = [sortDescriptr]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //here we update the ui elements
            DispatchQueue.main.async {
                // tell the search bar to stop being the first responder!
                searchBar.resignFirstResponder() // go to the background we are done
            }
        }
    }
    
    
}



