//
//  ViewController.swift
//  ToDoey
//
//  Created by Khaled Bohout on 4/21/19.
//  Copyright © 2019 Khaled Bohout. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArr = [String]()
    var textfield = UITextField()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = defaults.array(forKey: "itemArr") {
            itemArr =  item  as! [String]
        }
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListItemCell", for: indexPath)
        cell.textLabel?.text = itemArr[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New TDoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //tap add item
            print("success")
            self.itemArr.append(self.textfield.text!)
            self.defaults.setValue(self.itemArr, forKey: "itemArr")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Add New Item"
            self.textfield = alerttextfield
            
            
        }
        present(alert, animated: true)
    }
    
}

