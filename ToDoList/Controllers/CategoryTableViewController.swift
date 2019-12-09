//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Ajay Singh on 11/15/19.
//  Copyright © 2019 Intellinum. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    var realmObject = try! Realm()
    
    var categoryItems : Results<Category>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    // MARK: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItems", for: indexPath)
        
        let categoriesName = categoryItems?[indexPath.row]
        cell.textLabel?.text = categoriesName?.name ?? "No Categories Created"
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
            destinationVC.selectedCategory = categoryItems?[indexPath.row]
        }
    }
    
    //MARK:- Data Manipulation Method.
    
    func saveData(category : Category)  {
        do {
           try realmObject.write {
                realmObject.add(category)
            }
        }
        catch{
            print("Category not saved \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategory()
    {
        categoryItems = realmObject.objects(Category.self)
        

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
            let newCategory = Category()
            if let newCategoryName = textField.text {
                newCategory.name = newCategoryName
                
                self.saveData(category: newCategory)
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
