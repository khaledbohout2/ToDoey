//
//  ViewController.swift
//  ToDoey
//
//  Created by Khaled Bohout on 4/21/19.
//  Copyright © 2019 Khaled Bohout. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArr = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newitem = Item()
        newitem.title = "Learn DS"
        itemArr.append(newitem)
        
        let newitem2 = Item()
        newitem2.title = "Learn DS"
        itemArr.append(newitem2)
        
        let newitem3 = Item()
        newitem3.title = "Learn DS"
        itemArr.append(newitem3)
        
        
        //defaults.removeObject(forKey: "itemArr")
        if let items = defaults.array(forKey: "itemArr") as? [Item] {
            itemArr =  items
        }
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListItemCell", for: indexPath)
        let item = itemArr[indexPath.row]
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
        
        let item = itemArr[indexPath.row]
        item.done = !(item.done)
        print(item.done)
    
         
         tableView.reloadData()
        
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New TDoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //tap add item
            print("success")
            let newitem = Item()
            newitem.title = textfield.text!
            self.itemArr.append(newitem)
            self.defaults.setValue(self.itemArr, forKey: "itemArr")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Add New Item"
            textfield = alerttextfield
            
            
        }
        present(alert, animated: true)
    }
    
}

