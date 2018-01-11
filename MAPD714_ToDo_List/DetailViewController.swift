//  DetailViewController.swift
//  MAPD714_ToDo_List
//  RememBR App
//  Sergio de Almeida Brunacci - 300910506
//  Rafael Timbo Matos - 300962678
//  DetailViewController: Display details of a todo and edit them

import UIKit

class DetailViewController: UIViewController {
    
    var row: Int = 0
    
    var toDo: ToDoItem = ToDoItem(title:"RememBR", notes:"")
    
    // todo's title
    @IBOutlet weak var titleLabel: UITextField!
    
    // todo's notes
    @IBOutlet weak var notesLabel: UITextView!
    
   
    // update the todo
    @IBAction func updateButton(_ sender: UIButton) {
        toDo.title = titleLabel.text!
        toDo.notes = notesLabel.text
        ToDoItem.updateRow(Row: row, ToDoItem: toDo)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // display the todo
        titleLabel.text = toDo.title
        notesLabel.text = toDo.notes
    }
}
