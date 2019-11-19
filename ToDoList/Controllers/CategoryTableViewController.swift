//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Ajay Singh on 11/15/19.
//  Copyright © 2019 Intellinum. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    
    var categoryItems = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    // MARK: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return categoryItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItems", for: indexPath)
        
        let categoriesName = categoryItems[indexPath.row]
        cell.textLabel?.text = categoriesName.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK:- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categoryItems[indexPath.row]
        }
    }
    
    //MARK:- Data Manipulation Method.
    
    func saveData()  {
        do {
            try context.save()
        }
        catch{
            print("Category not saved \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest())
    {
        do {
           categoryItems = try context.fetch(request)
        }
        catch{
            print("Error while loading data \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //MARK:- Add New Catgory method.
    
    @IBAction func addCategory(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        let alert = UIAlertController(title: "", message: "Add New Category", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Add New Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            if let newCategoryName = textField.text {
                newCategory.name = newCategoryName
                self.categoryItems.append(newCategory)
                self.saveData()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
