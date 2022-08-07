//
//  FileCache.swift
//  ToDoList
//
//  Created by Igor Manakov on 30.07.2022.
//

import Foundation

enum FileCacheErrors: Error {
    case noSuchFileInDirectory(url: URL)
    case noDataInFile(url: URL)
}

final class FileCache {
    
    static let shared = FileCache()
    
    private(set) var list: [ToDoItem] = []
    
    private init() {}
    
    public func addNewItem(_ toDoItem: ToDoItem) {
        
        if let index = self.list.firstIndex(where: { $0.id == toDoItem.id }) {
            self.list[index] = toDoItem
        } else {
            self.list.append(toDoItem)
        }
        
        NotificationCenter.default.post(name: Notification.Name(NotificationKeys.fileCacheNotificationKey), object: self)
    }
    
    @discardableResult public func removeItem(with id: UUID) -> ToDoItem? {
        
        guard let index = self.list.firstIndex(where: { $0.id == id }) else {
            print("There is no such item")
            return nil
        }
        let removedObject = self.list.remove(at: index)
        
        NotificationCenter.default.post(name: Notification.Name(NotificationKeys.fileCacheNotificationKey), object: self)
        
        return removedObject
    }
    
    public func saveJSONItems(to file: String) throws {
        
        let dict: [String: Any] = ["list": self.list.map { $0.json }]
        
        let url = FileManager.cachesDirectoryURL.appendingPathComponent(file)
        
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        
        try jsonData.write(to: url, options: .atomic)
    }
    
    public func loadJSONItems(from file: String) throws {
        
        let url = FileManager.cachesDirectoryURL.appendingPathComponent(file)
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw FileCacheErrors.noSuchFileInDirectory(url: url)
        }
        
        let data = try Data(contentsOf: url)

        guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let list = dictionary["list"] as? [[String: Any]] else {
            throw FileCacheErrors.noDataInFile(url: url)
        }
        
        self.list = list.compactMap{ ToDoItem.parse(json: $0) }.sorted{ $0.createdAt < $1.createdAt }
    }
}
