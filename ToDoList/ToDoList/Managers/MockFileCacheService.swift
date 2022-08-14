//
//  MockFileCacheService.swift
//  ToDoList
//
//  Created by Igor Manakov on 14.08.2022.
//

import Foundation

class MockFileCacheService: FileCacheService {    
    func save(to file: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try FileCache.shared.saveJSONItems(to: file)
            }
            catch {
                completion(.failure(error))
            }
        }
        
        completion(.success(()))
    }
    
    func add(_ newItem: ToDoItem) {
        
    }
    
    func delete(id: String) {
        
    }
    
    func load(
        from file: String,
        completion: @escaping (Result<[ToDoItem], Error>) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let list = try FileCache.shared.loadJSONItems(from: file)
                completion(.success(list))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        completion(.success(FileCache.shared.list))
    }
}
