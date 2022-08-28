//
//  FileCacheService.swift
//  ToDoList
//
//  Created by Igor Manakov on 14.08.2022.
//

import Foundation

protocol FileCacheService {
  func save(
    to file: String,
    completion: @escaping (Result<Void, Error>) -> Void
  )
    
  func load(
    from file: String,
    completion: @escaping (Result<[ToDoItem], Error>) -> Void
  )
    
  func add(_ newItem: ToDoItem)
    
  func delete(id: UUID)
}
