//
//  CategoryViewController.swift
//  todoey
//
//  Created by ricard on 14.01.19.
//  Copyright © 2019 ricard. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    //    MARK: REALMSWIFT initialize the realm
    let realm = try! Realm()
    
    //    MARK: REALMSWIFT this categories var will get the results every time realm is queried
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  If categories is null will return 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        cell.textLabel?.text = item
        
//        cell.accessoryType = item.done  ? .checkmark : .none
        
        //        ---- previous statement replaces the following
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        return cell
        
    }
    
    //MARK: - Data Manipulation Methods

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIALERT
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
//            newItem.done = false
            
//            self.categories.append(newCategory)//        once selected, it gets a checkmark
            
            //            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadCategories() {
        //    MARK: REALMSWIFT
        //      this statement will retrieve all the categories of the realm
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }

    func save(category : Category) {
        //        MARK: REALMSWIFT
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print ("Error saving Category \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
//        get the selected
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
