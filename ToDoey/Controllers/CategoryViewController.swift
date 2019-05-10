//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Khaled Bohout on 5/9/19.
//  Copyright © 2019 Khaled Bohout. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoriesArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadcategories()
    
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoriesArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            
            destination.selectedcategory = categoriesArray[indexpath.row]
        }
    }

    @IBAction func addByttonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert =  UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newcategory = Category(context: self.context)
            
            newcategory.name = textField.text
            
            self.categoriesArray.append(newcategory)
            
            self.savecategories()
            
        }
        alert.addAction(action)
        
        alert.addTextField(configurationHandler: { (alerttextField) in
            
            alerttextField.placeholder = "Type Category Name"
            
            textField = alerttextField
            
        })
        present(alert, animated: true)
        
    }
    
    func savecategories(){
        do{
        try context.save()
        }
        catch{
            print("error saving category, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadcategories(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
        categoriesArray = try context.fetch(request)
        }
        catch{
            print("error loading items ,\(error)")
        }
        tableView.reloadData()
    }

}
