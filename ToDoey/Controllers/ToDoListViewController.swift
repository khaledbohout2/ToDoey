//
//  ViewController.swift
//  ToDoey
//
//  Created by Khaled Bohout on 4/21/19.
//  Copyright © 2019 Khaled Bohout. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFliePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        loaditems()
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
        
        let item = itemArray[indexPath.row]
        item.done = !(item.done)
        print(item.done)
    
         
         self.saveItem()
        
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New TDoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //tap add item
            print("success")
            
            let newitem = Item()
            
            newitem.title = textfield.text!
            
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
        
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFliePath!)
            
        } catch{
            print("error encoding item array, \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loaditems(){
        
        if let data = try? Data(contentsOf: dataFliePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("error decoding array , \(error)")
            }
        }
    }
    
}

