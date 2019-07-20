//
//  ViewController.swift
//  Todoey
//
//  Created by Fivecode on 13/07/19.
//  Copyright © 2019 Fivecode. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArr: [Item] = [Item]()
    let keyTodo = "TodoeyList"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadData()

//        tableView.delegate = self
//        tableView.dataSource = self
        
//        if let items = defaults.array(forKey: keyTodo) as? [Items] {
//            itemArr = items
//        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        
        cell.textLabel?.text = itemArr[indexPath.row].title
        
        cell.accessoryType = itemArr[indexPath.row].isDone ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArr[indexPath.row].isDone = !itemArr[indexPath.row].isDone
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: context)
            newItem.title = textField.text!
            newItem.isDone = false
            self.itemArr.append(newItem)
            
            self.saveData()
            
//            self.defaults.set(self.itemArr, forKey: self.keyTodo)
        }
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Create New Item"
            textField = UITextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {

        do {
            try context.save()
        }catch let error{
            print("Error Saving Data \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArr = try context.fetch(request)
        } catch {
            print("Error Load Data \(error)")
        }
        
    }
    
}

