//
//  ViewController.swift
//  ToDoey
//
//  Created by Khaled Bohout on 4/21/19.
//  Copyright © 2019 Khaled Bohout. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedcategory: Category? {
        didSet{
            loaditems()
        }
    }
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        if item.done == true {
            
            cell.accessoryType = .checkmark
        }
            
        else if item.done == false {
            
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItem()
        
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New TDoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //tap add item
            print("success")
            
            
            
            let newitem = Item(context: self.context)
            
            newitem.title = textfield.text!
            
            newitem.done = false
            
            newitem.parentCategory = self.selectedcategory
            
            self.itemArray.append(newitem)
            
            self.saveItem()
        }
        alert.addAction(action)
        
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Add New Item"
            textfield = alerttextfield
            
            
        }
        present(alert, animated: true)
    }
    func saveItem(){
        
        do{
            try context.save()
            
        } catch{
            print("error saving context, \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loaditems(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil ){
        
        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedcategory!.name!)
        
        if let additionalpredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate,additionalpredicate])
        }
        else{
            request.predicate = categorypredicate
        }
//        let compoundpredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate,predicate])
//
//        request.predicate = compoundpredicate
        do{
            
        itemArray = try context.fetch(request)
            
        }catch{
            print("error fetching items , \(error)")
        }
        
        tableView.reloadData()


    }

    
}

extension ToDoListViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
      
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loaditems(with: request,predicate: predicate)
        
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

