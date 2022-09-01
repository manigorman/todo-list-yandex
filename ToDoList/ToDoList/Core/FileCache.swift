//
//  FileCache.swift
//  ToDoList
//
//  Created by Igor Manakov on 30.07.2022.
//

import Foundation
import UIKit
import CoreData

enum FileCacheErrors: Error {
    case noSuchFileInDirectory(url: URL)
    case noDataInFile(url: URL)
}

final class FileCache {
    
    static let shared = FileCache()
    
    private let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    
    private init() {}
    
    func load(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        do {
            let tasks = try managedContext.fetch(Task.fetchRequest())
            let list = tasks.map {
                ToDoItem(id: $0.id,
                         text: $0.text,
                         importance: Importance(rawValue: $0.importance!)!,
                         deadline: $0.deadline,
                         isCompleted: $0.isCompleted,
                         createdAt: $0.createdAt,
                         changedAt: $0.changedAt)
            }
            completion(.success(list))
        } catch {
            completion(.failure(error))
        }
    }
    
    func update(_ item: ToDoItem, completion: @escaping (Error?) -> Void) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(item.id)")
        
        var task: Task?
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            task = test[0]
        } catch {
            completion(error)
            return
        }
        
        guard let task = task else {
            return
        }
        
        task.snapshot(item, task: task.self)
        
        do {
            try managedContext.save()
        } catch {
            completion(error)
        }
        completion(nil)
    }
    
    func insert(_ item: ToDoItem, completion: @escaping (Error?) -> Void) {
        
        let newTask = Task(context: self.managedContext)
        newTask.snapshot(item, task: newTask.self)
        
        do {
            try self.managedContext.save()
        } catch {
            completion(error)
        }
        completion(nil)
    }
    
    func delete(with id: UUID, completion: @escaping (Error?) -> Void) {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id.description)")
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            for obj in test {
                managedContext.delete(obj)
            }
        } catch {
            completion(error)
        }
        
        do {
            try managedContext.save()
        } catch {
            completion(error)
        }
        completion(nil)
    }
}
