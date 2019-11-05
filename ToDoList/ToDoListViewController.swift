//
//  ViewController.swift
//  ToDoList
//
//  Created by Ajay Singh on 11/2/19.
//  Copyright © 2019 Intellinum. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
   var toDoListArray = ["Learn Udemy Course", "Drink a Tea", "Put a resignation"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    // MARK - UITableview Datasource method.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoList", for: indexPath)
        cell.textLabel?.text = toDoListArray[indexPath.row]
        return cell
    }
    
    // MARK - UITableview Delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(toDoListArray[indexPath.row])
        
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK : UINavigation Bar button Item click event.
    @IBAction func addNewItemClicked(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Item", style: .default) { (action) in
            
            if let newItemTextFiled = textField.text {
                self.toDoListArray.append(newItemTextFiled)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New User"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

