//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kejsi Struga on 13/03/2018.
//  Copyright © 2018 Kejsi Struga. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
   // var categories = [Category]()
    
    // Realm returns a Results Type when we read data
    var categories: Results<Category>? // Collection of Results
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if categories is not nil return count else(??) return 1 => Nil coalescing operator
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // we change the color of the cell where we create the cell!
        
        if let category = categories?[indexPath.row] {
            
            guard let categoryColor = UIColor(hexString: category.categoryUIColor) else {fatalError()}
            
            cell.textLabel?.text = category.name
                //categories?[indexPath.row].name ?? "No Categories Added Yet"
            
            cell.backgroundColor = categoryColor
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        }
        else {
            cell.textLabel?.text = "No Categories Added Yet"
            
        }
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    // Take the user from the category view to other view by triggering the segue!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        // get category of the selected cell!
        if let indexPath = tableView.indexPathForSelectedRow {
            // destination ViewController!
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print ("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Delete data
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.categoryUIColor = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
        }
        
        alert.addTextField{ (field) in
            textField = field
            textField.placeholder = "Add a new Category"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadCategories () {
        
        categories = realm.objects(Category.self) // all items from realm which have the Category type ^^
        
        tableView.reloadData()
        
    }
    
}

