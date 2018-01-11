//
//  DetailViewController.swift
//  MAPD714_ToDo_List
//
//  Created by Sergio de Almeida Brunacci on 2018-01-10.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    
    var toDo: ToDoItem = ToDoItem(title:"RememBR", notes:"")
    
    
    @IBOutlet weak var titleLabel: UITextField!
    
    
    @IBOutlet weak var notesLabel: UITextView!
    
    
    @IBAction func updateButton(_ sender: UIButton) {
        //toDo persist data
        toDo.title = titleLabel.text!
        toDo.notes = notesLabel.text
        //toDo.encode(with: "title", "notes", "done")
        
        
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = toDo.title
        notesLabel.text = toDo.notes

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
