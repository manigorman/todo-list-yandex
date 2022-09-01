//
//  DelegatesList.swift
//  ToDoList
//
//  Created by Igor Manakov on 28.08.2022.
//

import Foundation

final public class DelegatesList<T>: Sequence {
    
    // Private
    private let delegatesHashTable = NSHashTable<AnyObject>.weakObjects()
    
    private let accessQueue = DispatchQueue(label: "delegates_list_access_queue")
    
    // MARK: - Public
    
    public init() { }
    
    public func addDelegate(_ delegate: T) {
        accessQueue.sync {
            delegatesHashTable.add(delegate as AnyObject)
        }
    }
    
    // MARK: - Sequence
    
    public func makeIterator() -> Array<T>.Iterator {
        accessQueue.sync {
            let delegates = delegatesHashTable.allObjects.compactMap { $0 as? T}
            return delegates.makeIterator()
        }
    }
    
}
