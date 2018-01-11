//
//  ToDo.swift
//  MAPD714_ToDo_List
//
//  Created by Sergio de Almeida Brunacci on 2018-01-08.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import Foundation

class ToDoItem: NSObject, NSCoding
{
    //static let sharedToDoList = [ToDoItem]()
    
    public static var todoItems = [ToDoItem]()
    
    
    
    var title: String
    var notes: String
    var done: Bool
    
    
    
    public init(title: String, notes: String)
    {
        
        
        self.title = title
        self.notes = notes
        self.done = false
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        // Try to unserialize the "title" variable
        if let title = aDecoder.decodeObject(forKey: "title") as? String
        {
            self.title = title
        }
        else
        {
            // There were no objects encoded with the key "title",
            // so that's an error.
            return nil
        }
        
        if let notes = aDecoder.decodeObject(forKey: "notes") as? String
        {
            self.notes = notes
        }
        else
        {
            // There were no objects encoded with the key "notes",
            // so that's an error.
            return nil
        }
        
        // Check if the key "done" exists, since decodeBool() always succeeds
        if aDecoder.containsValue(forKey: "done")
        {
            self.done = aDecoder.decodeBool(forKey: "done")
        }
        else
        {
            // Same problem as above
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder)
    {
        // Store the objects into the coder object
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.notes, forKey: "notes")
        aCoder.encode(self.done, forKey: "done")
    }
    
    static func loadPersistence() -> Bool{
        do
        {
            // Try to load from persistence
            self.todoItems = try [ToDoItem].readFromPersistence()
        }
        catch let error as NSError
        {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError
            {
                NSLog("No persistence file found, not necesserially an error...")
            }
            else
            {
                NSLog("Error loading from persistence: \(error)")
                return true
            }
        }
        return false
    }
    
    static func writePersistence(){
        do
        {
            try todoItems.writeToPersistence()
        }
        catch let error
        {
            NSLog("Error writing to persistence: \(error)")
        }
    }
    
    static func updateRow(Row row: Int, ToDoItem toDo: ToDoItem){
        //toDo persist data
        todoItems[row] = toDo
        //toDo.encode(with: "title", "notes", "done")
        ToDoItem.writePersistence()
    }
    
    static func removeRow(Row row: Int){
        todoItems.remove(at: row)
        ToDoItem.writePersistence()
    }
    
}

/* Mock data
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
}*/

extension Collection where Iterator.Element == ToDoItem
{
    // Builds the persistence URL. This is a location inside
    // the "Application Support" directory for the App.
    private static func persistencePath() -> URL?
    {
        let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)
        
        return url?.appendingPathComponent("todoitems.bin")
    }
    
    // Write the array to persistence
    func writeToPersistence() throws
    {
        if let url = Self.persistencePath(), let array = self as? NSArray
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        }
        else
        {
            throw NSError(domain: "com.example.MAPD714_ToDo_List", code: 10, userInfo: nil)
        }
    }
    
    // Read the array from persistence
    static func readFromPersistence() throws -> [ToDoItem]
    {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?)
        {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ToDoItem]
            {
                return array
            }
            else
            {
                throw NSError(domain: "com.example.MAPD714_ToDo_List", code: 11, userInfo: nil)
            }
        }
        else
        {
            throw NSError(domain: "com.example.MAPD714_ToDo_List", code: 12, userInfo: nil)
        }
    }
}


