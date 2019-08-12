//
//  ViewController.swift
//  Todoey
//
//  Created by Fivecode on 13/07/19.
//  Copyright © 2019 Fivecode. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var itemArr: Results<Item>?
    
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
        return itemArr?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)
        
        if let item = itemArr?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.isDone ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No title added"
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArr?[indexPath.row] {
            
            try! realm.write {
//                realm.delete(item)
               item.isDone = !item.isDone
            }
        }
        tableView.reloadData()
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
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd.MM.yyy"
                        
                        newItem.title = textField.text!
                        newItem.dateCreated = "\(date)"
                        currentCategory.items.append(newItem)
                        self.tableView.reloadData()
                    }
                    
                }catch{
                    print(error)
                }
            }
        }
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Create New Item"
            textField = UITextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("error save item \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        
        itemArr = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

// MARK: - searchbar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArr = itemArr?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

