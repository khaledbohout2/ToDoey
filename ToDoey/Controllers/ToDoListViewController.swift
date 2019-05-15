 //
//  ViewController.swift
//  ToDoey
//
//  Created by Khaled Bohout on 4/21/19.
//  Copyright © 2019 Khaled Bohout. All rights reserved.
//

import UIKit
import RealmSwift
 import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedcategory!.name

        guard let colourhex = selectedcategory?.cellColor else { fatalError() }
        
        updateNAveBar(withHexCode: colourhex)

            }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        updateNAveBar(withHexCode: "1D9BF6")

    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNAveBar( withHexCode colourHexCode: String){
        
        
        guard let navBar =  (navigationController?.navigationBar)  else {
            fatalError("navigationvontroller does not exist")
        }
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        navBar.barTintColor  = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        searchBar.barTintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedcategory!.cellColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
            
            cell.backgroundColor = color
                
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
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
                    newitem.cellColor = UIColor.randomFlat.hexValue()
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
    
    override func updateModel(at indexpath: IndexPath) {
        
        if let itemfordeletion = self.todoItems?[indexpath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(itemfordeletion)
                }
            } catch {
                print("error deleting item , \(error)")
            }
        }
    }

    
}

extension ToDoListViewController:UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
         todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
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

