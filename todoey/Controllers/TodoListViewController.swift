//
//  ViewController.swift
//  todoey
//
//  Created by ricard on 10.12.18.
//  Copyright © 2018 ricard. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
//    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

         
         print (dataFilePath)
//        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
//


        
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//            print(itemArray)
//        }
    
        
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {

            cell.textLabel?.text = item.title
        
            cell.accessoryType = item.done  ? .checkmark : .none
        
//        ---- previous statement replaces the following
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
        
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print (itemArray[indexPath.row])
        
        //        MARK: REALMSWIFT write item
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    //                    MARK: REALMSWIFT realm.delete is for deleting an object (item)
                    //                    realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            // once selected, it gets a checkmark
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//      deselects the cell after selected with animation like highlight
        
//        saveItems()
//        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert
        )
     
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIALERT
//
//
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//
//            self.itemArray.append(newItem)//        once selected, it gets a checkmark
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
//            self.saveItems()
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                        print ("Error saving Item \(error)")

                }
            }
            
            self.tableView.reloadData()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//    -- function created with the property list encoder
    
//    func saveItems() {
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to:dataFilePath!)
//        } catch {
//            print ("ERror encoding item array , \(error)")
//        }
//
//        self.tableView.reloadData()
//    }
    
//    func saveItems() {
//
//        do {
//            try context.save()
//        } catch {
//            print ("Error saving Context \(error)")
//        }
//
//        self.tableView.reloadData()
//    }

//    function created with the property decoder
//    func loadItems() {
//
//        if let data = try? Data (contentsOf: dataFilePath!) {
//           let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print ("Error when decoding data \(error)")
//            }
//
//        }
//
//    }
    

//
    //    MARK: COREDATA loaditems
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
////            let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//
//            do {
//                itemArray = try context.fetch(request)
//            } catch {
//                print ("Error fetching data from context \(error)")
//            }
//            tableView.reloadData()
//        }
//
//}
    //    MARK: REALMSWIFT load the items of a realm
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

//MARK: - Search bar methods
//
//extension TodoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
////        [cd] stands for disabling case and diacritic sensitiveness
//        let predicate = NSPredicate( format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//
//        searchBar.resignFirstResponder()
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//
//
}
    //    MARK: REALMSWIFT searchbar methods
    extension TodoListViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            print("searchBarpressed with text \(searchBar.text!)")
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadItems()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
    
            }
        }
    }

