//
//  ViewController.swift
//  ToDoList
//
//  Created by Ajay Singh on 11/2/19.
//  Copyright © 2019 Intellinum. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    var toDoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
   
   
   var realmObject = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)

    }
    
    // MARK - UITableview Datasource method.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoList", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = (item.done == true) ? .checkmark  : .none
        }
        else
        {
            cell.textLabel?.text = "No Item available for selected Category"
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // MARK - UITableview Delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let item = toDoItems?[indexPath.row]
        {
            do
            {
                try realmObject.write
                {
                    item.done = !item.done
                }
            }
            catch
            {
                print("Error while updating done value \(error)")
            }
        }
        
        tableView.reloadData()
        
//        //toDoListArray[indexPath.row].done = !toDoListArray[indexPath.row].done
//        context.delete(toDoListArray[indexPath.row])
//        toDoListArray.remove(at: indexPath.row)
//
//        saveItems()
//
//        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK : UINavigation Bar button Item click event.
    

    @IBAction func addNewItemClicked(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Item", style: .default) { (action) in
            
            
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realmObject.write
                    {
                        let newItem = Item()
                        if let newItemTextFiled = textField.text {
                            newItem.title = newItemTextFiled
                            let date = Date()
                            newItem.itemCreatedDate = date
                        }
                        currentCategory.items.append(newItem)
                    }
                }
                catch
                {
                    print("New Item not saved \(error)")
                }
    
            }
            
            
                self.tableView.reloadData()
         }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New User"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
   func loadItems()
   {
      toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
 
        tableView.reloadData()
    }
 
 
}
 
    
 
    

// MARK:- Search bar method
extension ToDoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
        toDoItems = toDoItems?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "itemCreatedDate", ascending: false)
        self.tableView.reloadData()
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text?.count == 0 {
            loadItems()
        }
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
}

