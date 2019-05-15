//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Khaled Bohout on 5/9/19.
//  Copyright © 2019 Khaled Bohout. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoriesArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadcategories()
    
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoriesArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoriesArray?[indexPath.row]{
        
        cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: (category.cellColor)) else { fatalError() }
        
        cell.backgroundColor = categoryColour
            
        cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! ToDoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            
            destination.selectedcategory = categoriesArray?[indexpath.row]
        }
    }
    

    @IBAction func addByttonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert =  UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newcategory = Category()
            
            newcategory.name = textField.text!
            
            newcategory.cellColor = UIColor.randomFlat.hexValue()
            
            self.save(category: newcategory)
            
        }
        alert.addAction(action)
        
        alert.addTextField(configurationHandler: { (alerttextField) in
            
            alerttextField.placeholder = "Type Category Name"
            
            textField = alerttextField
            
        })
        present(alert, animated: true)
        
    }
    
    func save(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("error saving category, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadcategories(){
        
        categoriesArray = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    override func updateModel(at indexpath: IndexPath) {
        
                        if let categoryfordeletion = self.categoriesArray?[indexpath.row] {
                            do{
                                try self.realm.write {
                                    self.realm.delete(categoryfordeletion)
                                }
                            } catch {
                                print("error deleting category , \(error)")
                            }
                        }
    }
    


}


