 //
//  ViewController.swift
//  ToDoey
//
//  Created by Khaled Bohout on 4/21/19.
//  Copyright © 2019 Khaled Bohout. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedcategory: Category? {
        didSet{
            loaditems()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
 
        }
        else {
            cell.textLabel?.text = "No Items"
        }
        
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
        if let item = todoItems?[indexPath.row] {
            do{
        try realm.write {
            item.done = !item.done
        }
            } catch{
                print("error saving done property , \(error)")
            }
         }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

        
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New TDoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //tap add item
            print("success")
            
            if let currentcategory = self.selectedcategory {
                do {
                try self.realm.write {
                    
                    let newitem = Item()
                    newitem.title = textfield.text!
                    newitem.dateCreated = Date()
                    currentcategory.items.append(newitem)
                }
                } catch{
                    print("error saving items , \(error)")
                }
            }
            
            self.tableView.reloadData()

            
        }
        alert.addAction(action)
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Add New Item"
            textfield = alerttextfield
            
            
        }
        present(alert, animated: true)
    }
    
    func loaditems(){
        
        todoItems = selectedcategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
//
//
   }

    
}

extension ToDoListViewController:UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
       
         todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
         tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loaditems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

