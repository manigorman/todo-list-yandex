//
//  TasksRouter.swift
//  ToDoList
//
//  Created by Igor Manakov on 22.08.2022.
//

import Foundation
import UIKit

protocol ITasksRouter: AnyObject {
    func openNewTask(with task: ToDoItem?)
}

final class TasksRouter: ITasksRouter {
    
    // MARK: - Dependencies
    
    weak var transitionHandler: UIViewController?
    
    // MARK: - ITasksRouter
    
    func openNewTask(with task: ToDoItem?) {
        let assembly = TaskDetailsAssembly()
        let controller = UINavigationController(rootViewController: assembly.assemble(task: task))
        
        transitionHandler?.present(controller, animated: true)
    }
}
