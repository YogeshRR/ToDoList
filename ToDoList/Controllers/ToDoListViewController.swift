//
//  ViewController.swift
//  ToDoList
//
//  Created by Ajay Singh on 11/2/19.
//  Copyright © 2019 Intellinum. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
   var toDoListArray = [Item]()
   let defaults = UserDefaults.standard
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

       loadItems()
   
    }
    
    // MARK - UITableview Datasource method.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoList", for: indexPath)
        
       let item = toDoListArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == false{
//            cell.accessoryType = .none
//        }else{
//            cell.accessoryType = .checkmark
//        }
        
        return cell
    }
    
    // MARK - UITableview Delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(toDoListArray[indexPath.row])
        
        toDoListArray[indexPath.row].done = !toDoListArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK : UINavigation Bar button Item click event.
    @IBAction func addNewItemClicked(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Item", style: .default) { (action) in
            let newItem = Item()
            if let newItemTextFiled = textField.text {
                newItem.title = newItemTextFiled
                self.toDoListArray.append(newItem)
                self.saveItems()
                
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New User"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems()  {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.toDoListArray)
            try data.write(to: dataFilePath!)
            print("file Path \(String(describing: dataFilePath))")
        }catch{
            print("Found following error \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems()  {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                toDoListArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("Error found \(error)")
            }
            
            
        }
    }
}

