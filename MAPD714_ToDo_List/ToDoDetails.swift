//
//  ToDoDetails.swift
//  MAPD714_ToDo_List
//
//  Created by Sergio de Almeida Brunacci on 2018-01-10.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import Foundation

class ToDoDetail: NSObject, NSCoding
{
    var title: String
    var done: Bool
    
    public init(title: String)
    {
        self.title = title
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
        aCoder.encode(self.done, forKey: "done")
    }
}

extension ToDoDetail
{
    public class func getMockData() -> [ToDoDetail]
    {
        return [
            ToDoDetail(title: "Milk"),
            ToDoDetail(title: "Chocolate"),
            ToDoDetail(title: "Light bulb"),
            ToDoDetail(title: "Dog food")
        ]
    }
}

extension Collection where Iterator.Element == ToDoDetail
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
        
        return url?.appendingPathComponent("tododetails.bin")
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


