//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kejsi Struga on 13/03/2018.
//  Copyright © 2018 Kejsi Struga. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
   // var categories = [Category]()
    
    // Realm returns a Results Type when we read data
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    //MARK: - TableView DAtaSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if categories is not nil return count else(??) return 1 => Nil coalescing operator
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    
    //MARK: - TAbleView Delegate Methods
    
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
    
    //MARK: - Add New Categories
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            //            self.categories.append(newCategory); we dont need this! because realm autoupdates
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
        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//           categories = try context.fetch(request)
//        } catch {
//            print("Error loading categories \(error)")
//        }
        tableView.reloadData()
        
    }
    
}
