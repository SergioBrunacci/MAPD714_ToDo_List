//
//  ViewController.swift
//  MAPD714_ToDo_List
//  RememBR App
//  Sergio de Almeida Brunacci - 300910506
//  Rafael Timbo Matos - 300962678
//  View controller that lists the ToDos

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "RememBR"
        
        // set up add button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.didTapAddItemButton(_:)))
        
        // notify if the app is going to background so we save the todos
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),
            name: NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil)
        
        // load all todos from file and display an alert on error
        if ToDoItem.loadPersistence(){
            let alert = UIAlertController(
                title: "Error",
                message: "Could not load the to-do items!",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    // refresh todos on screen reappearance ( specially when coming back from a todo detail view)
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
            
            // display checkmark for completed todos
            let accessory: UITableViewCellAccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }

    
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
            // delete todo at row indexPath.row
            ToDoItem.removeRow(Row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    // pass todo to DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tableViewCell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)!
        let toDo = ToDoItem.todoItems[indexPath.row]
        
        if segue.identifier == "ShowToDoDetails" {
            let detailsVC = segue.destination as! DetailViewController
            
            detailsVC.toDo = toDo
            detailsVC.row = indexPath.row
        }else{
            //error
        }
        
    }
    
    // save todos when the application goes to background
    @objc
    public func applicationDidEnterBackground(_ notification: NSNotification)
    {
        ToDoItem.writePersistence()
    }
    
    
    // toggle completion status of a todo
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let isCompleted: Bool = ToDoItem.isCompleted(Row: indexPath.row)
        var title : String;
        var cellColor : UIColor;
        var buttonColor: UIColor;
        
        if isCompleted {
            title = "Redo"
            cellColor = .white
            buttonColor = .orange
        } else {
            title = "Complete"
            cellColor = .green
            buttonColor = .green
        }
        
        let closeAction = UIContextualAction(style: .normal, title: title, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Completion Toggled")
            ToDoItem.toggleCompletionRow(Row:indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_todo", for: indexPath)
            cell.contentView.backgroundColor = cellColor
            self.tableView.reloadData()
            success(true)
        })
        closeAction.image = UIImage(named: "tick")
        closeAction.backgroundColor = buttonColor
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    

}

