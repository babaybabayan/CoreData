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
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    // MARK: - tableview methods
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
        
//        context.delete(itemArr[indexPath.row])
//        itemArr.remove(at: indexPath.row)
        
        itemArr[indexPath.row].isDone = !itemArr[indexPath.row].isDone
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - controller data
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text == "" {
                let str = "textfield is empty"
                let disAlert = UIAlertController(title: str, message: str, preferredStyle: .alert)
                let disAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
                    self.present(alert, animated: true, completion: nil)
                })
                disAlert.addAction(disAction)
                self.present(disAlert, animated: true, completion: nil)
                return
            }
            
            let newItem = Item(context: context)
            newItem.title = textField.text!
            newItem.isDone = false
            newItem.parentCategory = self.selectedCategory
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
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do {
            itemArr = try context.fetch(request)
        } catch {
            print("Error Load Data \(error)")
        }
        tableView.reloadData()
    }
}

// MARK: - searchbar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

