//
//  FileCacheService.swift
//  ToDoList
//
//  Created by Igor Manakov on 14.08.2022.
//

import Foundation

protocol FileCacheServiceDelegate: AnyObject {
    func didUpdateTasks(_ tasks: [ToDoItem])
}

protocol IFileCacheService {
    func load(completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    
    func insert(_ item: ToDoItem, completion: @escaping (Error?) -> Void)
    
    func update(_ item: ToDoItem, completion: @escaping (Error?) -> Void)
    
    func delete(by id: UUID, completion: @escaping (Error?) -> Void)
    
    func addDelegate(_ delegate: FileCacheServiceDelegate)
}

final class FileCacheService: IFileCacheService {
    
    // MARK: - Private
    
    private let syncQueue = DispatchQueue(label: "file-cache-service-queue")
    
    private static let delegates = DelegatesList<FileCacheServiceDelegate>()
    
    // MARK: - Public
    
    func load(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        FileCache.shared.load { result in
            switch result {
            case .success(let tasks):
                DispatchQueue.main.async {
                    FileCacheService.delegates.forEach {
                        $0.didUpdateTasks(tasks)
                    }
                }
                
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }        
    }
    
    func insert(_ item: ToDoItem, completion: @escaping (Error?) -> Void) {
        FileCache.shared.insert(item, completion: completion)
    }
    
    func update(_ newItem: ToDoItem, completion: @escaping (Error?) -> Void) {
        FileCache.shared.update(newItem, completion: completion)
    }
    
    func delete(by id: UUID, completion: @escaping (Error?) -> Void) {
        FileCache.shared.delete(with: id, completion: completion)
    }
    
    func addDelegate(_ delegate: FileCacheServiceDelegate) {
        FileCacheService.delegates.addDelegate(delegate)
    }
}
