//
//  ToDo.swift
//  MAPD714_ToDo_List
//
//  Created by Sergio de Almeida Brunacci on 2018-01-08.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import Foundation

class ToDoItem
{
    var title: String
    var done: Bool
    
    public init(title: String)
    {
        self.title = title
        self.done = false
    }
}

extension ToDoItem
{
    public class func getMockData() -> [ToDoItem]
    {
        return [
            ToDoItem(title: "Milk"),
            ToDoItem(title: "Chocolate"),
            ToDoItem(title: "Light bulb"),
            ToDoItem(title: "Dog food")
        ]
    }
}
