//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Igor Manakov on 30.07.2022.
//

import Foundation

struct ToDoItem {
    
    let id: UUID
    let text: String
    let importance: Importance
    let deadline: Date?
    let isCompleted: Bool
    let createdAt: Date
    let changedAt: Date?
    
    init(id: UUID = UUID(),
         text: String,
         importance: Importance = Importance.basic,
         deadline: Date? = nil,
         isCompleted: Bool = false,
         createdAt: Date = Date(),
         changedAt: Date? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.changedAt = changedAt
    }
}

enum Importance: String {
    case low, basic, important
}

extension ToDoItem {
    
    var json: Any {
        var dict: [String: Any] = ["id": self.id.uuidString,
                                   "text": self.text,
                                   "done": self.isCompleted,
                                   "created_at": String(self.createdAt.timeIntervalSince1970)]
        
        if self.importance != .basic {
            dict["importance"] = importance.rawValue
        }
        
        if let deadline = self.deadline {
            dict["deadline"] = String(deadline.timeIntervalSince1970)
        }
        
        if let changedAt = self.changedAt {
            dict["changed_at"] = String(changedAt.timeIntervalSince1970)
        }
        
        return dict
    }
    
    static func parse(json: Any) -> ToDoItem? {
        
        guard let dict = json as? [String: Any] else {
            print("Cannot cast json to [String: Any]")
            return nil
        }
        
        guard let id = dict["id"] as? String,
              let id = UUID(uuidString: id),
              let text = dict["text"] as? String,
              let isCompleted = dict["done"] as? Bool,
              let createdAt = dict["created_at"] as? String,
              let createdAt = Double(createdAt) else {
            print("Missing required values")
            return nil
        }
        
        let importance = (dict["importance"] as? String).flatMap{ Importance(rawValue: $0) } ?? .basic
        
        let deadline: Date?
        if let dead = dict["deadline"] as? String,
           let dead = Double(dead) {
            deadline = Date(timeIntervalSince1970: dead)
        } else {
            deadline = nil
        }
        
        let changedAt: Date?
        if let change = dict["changed_at"] as? String,
           let change = Double(change) {
            changedAt = Date(timeIntervalSince1970: change)
        } else {
            changedAt = nil
        }
        
        return ToDoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        isCompleted: isCompleted,
                        createdAt: Date(timeIntervalSince1970: createdAt),
                        changedAt: changedAt)
    }
}

extension ToDoItem {
    public func asCompleted() -> ToDoItem {
        ToDoItem(id: self.id,
                 text: self.text,
                 importance: self.importance,
                 deadline: self.deadline,
                 isCompleted: !self.isCompleted,
                 createdAt: self.createdAt,
                 changedAt: self.changedAt)
    }
}
