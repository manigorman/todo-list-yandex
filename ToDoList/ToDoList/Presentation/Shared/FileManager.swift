//
//  FileManager.swift
//  ToDoList
//
//  Created by Igor Manakov on 30.07.2022.
//

import Foundation

extension FileManager {
    
    static var cachesDirectoryURL: URL {
        `default`.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
