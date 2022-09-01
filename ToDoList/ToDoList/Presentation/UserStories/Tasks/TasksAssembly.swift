//
//  TasksAssembly.swift
//  ToDoList
//
//  Created by Igor Manakov on 22.08.2022.
//

import Foundation
import UIKit

final class TasksAssembly {
    
    // MARK: - Public
    
    func assemble() -> UIViewController {
        let fileCacheService = FileCacheService()
        
        let router = TasksRouter()
        
        let presenter = TasksPresenter(router: router, fileCacheService: fileCacheService)
        
        let controller = TasksViewController(presenter: presenter)
        
        presenter.view = controller
        router.transitionHandler = controller
        
        return controller
    }
}
