//
//  TaskDetailsRouter.swift
//  ToDoList
//
//  Created by Igor Manakov on 22.08.2022.
//

import Foundation
import UIKit

protocol ITaskDetailsRouter: AnyObject {
    func dismiss()
}

final class TaskDetailsRouter: ITaskDetailsRouter {
    
    // MARK: - Dependencies
    
    weak var transitionHandler: UIViewController?
    
    // MARK: - ITasksRouter
    
    func dismiss() {
        transitionHandler?.dismiss(animated: true)
    }
}
