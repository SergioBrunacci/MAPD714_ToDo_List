//
//  ViewController.swift
//  MAPD714_ToDo_List
//
//  Created by Sergio de Almeida Brunacci on 2018-01-08.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "RememBR"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.didTapAddItemButton(_:)))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),
            name: NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil)
        
        if ToDoItem.loadPersistence(){
            let alert = UIAlertController(
                title: "Error",
                message: "Could not load the to-do items!",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToDoItem.todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_todo", for: indexPath)
        
        if indexPath.row < ToDoItem.todoItems.count
        {
            let item = ToDoItem.todoItems[indexPath.row]
            cell.textLabel?.text = item.title
            
            let accessory: UITableViewCellAccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }
  /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < todoItems.count
        {
            let item = todoItems[indexPath.row]
            item.done = !item.done
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }*/
    
    @objc func didTapAddItemButton(_ sender:UIBarButtonItem)
    {
        //Create Alert for tittle
        
        let alert = UIAlertController(title: "New to-do item", message: "Insert the title of the new to-do item", preferredStyle: .alert)
        
        //Add text field for the new item
        alert.addTextField(configurationHandler: nil)
        
        //Cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //OK button
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let title = alert.textFields?[0].text
            {
                self.addNewToDoItem(title: title)
            }
        }))
        
        // Present alert
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addNewToDoItem(title: String)
    {
        //Index
        let newIndex = ToDoItem.todoItems.count
        
        //New item
        ToDoItem.todoItems.append(ToDoItem(title: title, notes: ""))
        
        //Tell the table view
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if indexPath.row < ToDoItem.todoItems.count
        {
            ToDoItem.removeRow(Row: indexPath.row)
            //refresh table
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tableViewCell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)!
        let toDo = ToDoItem.todoItems[indexPath.row]
        
        if segue.identifier == "ShowToDoDetails"{
            let detailsVC = segue.destination as! DetailViewController
            
            detailsVC.toDo = toDo
            detailsVC.row = indexPath.row
        }else{
            //error
        }
/*
        let tableViewCell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)!
        let font = fontForDisplay(atIndexPath: indexPath as NSIndexPath)
        
        if segue.identifier == "ShowFontSizes" {
            let sizesVC = segue.destination as! FontSizesViewController
            sizesVC.title = font.fontName
            sizesVC.font = font
        } else {
            let infoVC = segue.destination as! FontInfoViewController
            infoVC.title = font.fontName
            infoVC.font = font
            infoVC.favourite = FavouritesList.SharedFavouritesList.favourites.contains(font.fontName)
        }
        
        */
        
    }
    
    @objc
    public func applicationDidEnterBackground(_ notification: NSNotification)
    {
        ToDoItem.writePersistence()
    }
    
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            ToDoItem.completeRow(Row:indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_todo", for: indexPath)
            cell.backgroundColor = .green
            self.tableView.reloadData()
            success(true)
        })
        closeAction.image = UIImage(named: "tick")
        closeAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    

}

