//
//  ViewController.swift
//  todoey
//
//  Created by ricard on 10.12.18.
//  Copyright © 2018 ricard. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
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
    
        loadItems()
        
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done  ? .checkmark : .none
        
//        ---- previous statement replaces the following
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print (itemArray[indexPath.row])
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            // once selected, it gets a checkmark
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//      deselects the cell after selected with animation like highlight
        
        saveItems()
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert
        )
     
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIALERT
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)//        once selected, it gets a checkmark
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)
        } catch {
            print ("ERror encoding item array , \(error)")
        }
    
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data (contentsOf: dataFilePath!) {
           let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print ("Error when decoding data \(error)")
            }
            
        }
        
    }
    
}

