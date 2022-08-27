//
//  MockFileCacheService.swift
//  ToDoList
//
//  Created by Igor Manakov on 14.08.2022.
//

import Foundation

class MockFileCacheService: FileCacheService {
    
    private let syncQueue = DispatchQueue(label: "FileCacheService")
    
    func save(to file: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        self.syncQueue.asyncAfter(deadline: .now() + 2) {
            do {
                try FileCache.shared.saveJSONItems(to: file)
            } catch {
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }
    
    func add(_ newItem: ToDoItem) {
        
    }
    
    func delete(id: String) {
        
    }
    
    func load(
        from file: String,
        completion: @escaping (Result<[ToDoItem], Error>) -> Void
    ) {
        self.syncQueue.asyncAfter(deadline: .now()) {
            do {
                let list = try FileCache.shared.loadJSONItems(from: file)
                completion(.success(list))
            } catch {
                completion(.failure(error))
            }
        }
        
        completion(.success(FileCache.shared.list))
    }
}
