//
//  ViewController.swift
//  ToDoList
//
//  Created by Ajay Singh on 11/2/19.
//  Copyright © 2019 Intellinum. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
   var toDoListArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
   let defaults = UserDefaults.standard
   //  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)

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
            
            let newItem = Item(context: self.context)
            if let newItemTextFiled = textField.text {
                newItem.title = newItemTextFiled
                newItem.done = false
                newItem.newCategory = self.selectedCategory
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
        
        do {
            try context.save()
        }catch{
            print("Error in saving context")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil)  {
        
        let categoryPredicate = NSPredicate(format: "newCategory.name MATCHES %@", selectedCategory!.name!)

        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }
        
        do {
            toDoListArray =  try context.fetch(request)
        }catch {
            print("error while fetching \(error)")
        }
        
        tableView.reloadData()
    }
}
// MARK:- Search bar method
extension ToDoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
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
