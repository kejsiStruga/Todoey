//
//  ViewController.swift
//  Todoey
//
//  Created by Kejsi Struga on 13/03/2018.
//  Copyright © 2018 Kejsi Struga. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    @IBOutlet var searchBar: UISearchBar!
    
    // table view controller in story board => dont need to link any outlets or set data source or delegates etc , all is setup
    
    var todoItems: Results<Item>? // ?=> its an optional
    
    // datatype of optional category, bcz its gonna be nil until we assign the category
    var selectedCategory : Category? {
        didSet{
            // WE ARE CERTAIN THAT WE GOT A VALUE FROM THE SELECTED CATEGORY => NOT CRASH OUR APP
            loadItems()
        }
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//
//    // user def is saved in the plist file hence dictionary!
//    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
   
    }
    //called later than viewDidLoad , after the nav bar has been established
    override func viewWillAppear(_ animated: Bool) {
        
        guard let colorHex = selectedCategory?.categoryUIColor else {fatalError()}
        updateNavBar(withHexCode: colorHex)
        title = selectedCategory?.name
      
    }
    
    // Because the color of the navbar remains the same as in the todolist view, when we go back to categories view!
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    // TableView DataSource Methods! - how many rows to return and what the cells should display
    
    // first data source method - is for the number or rows!!
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.categoryUIColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    // TableView Delegate methods! That gets fired whenever we click a cell in the table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saiving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        // selection color
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    //MARK: - Nav Bar setup methods
    func updateNavBar(withHexCode colorHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar
            else {fatalError("Navigation controller doesn't exist.")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:
            ContrastColorOf(navBarColor, returnFlat: true)]
        
        // for navigation items !!
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        // keeping the search bar color consistent
        searchBar.barTintColor = navBarColor
    }
    
    //MARK - Add in items
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        // A UI alert with a field that lets for insertion of new todos
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if self.selectedCategory != nil {
                do {
                    try self.realm.write {
                        print("Category of this Item is: \(self.selectedCategory)")
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        self.selectedCategory?.items.append(newItem)
                    }
                } catch {
                    print("Could not save this item, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in // closure
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try
                    realm.write {
                        realm.delete(item)
                }
            } catch {
                print ("Error while deleting a todoitem \(error)")
            }
        }
    }
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

         tableView.reloadData()
    }
    
}
//MARK: - Search bar methods
//Splitting the functionality of the viewcontroller
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // filter items by predicate
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

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



