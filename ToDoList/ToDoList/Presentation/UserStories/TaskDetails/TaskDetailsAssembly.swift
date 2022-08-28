//
//  TaskDetailsAssembly.swift
//  ToDoList
//
//  Created by Igor Manakov on 22.08.2022.
//

import Foundation
import UIKit

final class TaskDetailsAssembly {
    
    // MARK: - Public
    
    func assemble(task: ToDoItem?) -> UIViewController {
        let fileCacheService = FileCacheService()
        
        let router = TaskDetailsRouter()
        
        let presenter = TaskDetailsPresenter(router: router, fileCacheService: fileCacheService, task: task)
        
        let controller = TaskDetailsViewController(presenter: presenter)
        
        presenter.view = controller
        router.transitionHandler = controller
        
        return controller
    }
}
