//
//  TasksPresenter.swift
//  ToDoList
//
//  Created by Igor Manakov on 22.08.2022.
//

import Foundation
import UIKit

protocol ITasksPresenter: AnyObject {
    func viewDidLoad()
    func didTapCell(at indexPath: IndexPath)
    func removeTask(at indexPath: IndexPath)
    func markCompletedTask(at indexPath: IndexPath)
    func showHideCompleted()
}

final class TasksPresenter {
    
    // Dependencies
    weak var view: ITasksView?
    
    private let router: ITasksRouter
    
    private lazy var viewModelFactory = TasksViewModelFactory()
    
    // Private
    private let cache = MockFileCacheService()
    
    private var isShowingCompleted = false
    
    // Models
    private var tasks: [ToDoItem] = [] {
        didSet {
            updateView(with: tasks)
        }
    }
    
    // MARK: - Initialization
    
    init(router: ITasksRouter) {
        self.router = router
    }
    
    // MARK: - Private
    
    private func updateView(with tasks: [ToDoItem]) {
        let viewModel = viewModelFactory.makeModel(tasks: tasks, showingCompleted: isShowingCompleted)
        
        view?.update(with: viewModel)
    }
    
    private func loadTasks() {
        cache.load(from: "Data.json") { result in
            switch result {
            case .success(let items):
                self.tasks = items.filter { $0.isCompleted == false }
                return
            case .failure(let error):
                print(error.localizedDescription)
                return
            }
        }
    }
}

// MARK: - ITasksPresenter

extension TasksPresenter: ITasksPresenter {
    
    func viewDidLoad() {
        loadTasks()
    }
    
    func didTapCell(at indexPath: IndexPath) {
        if indexPath.row < self.tasks.count {
            router.openNewTask(with: tasks[indexPath.row])
        } else {
            router.openNewTask(with: nil)
        }
    }
    
    func removeTask(at indexPath: IndexPath) {
        cache.delete(id: self.tasks[indexPath.row].id)
        
        cache.save(to: "Data.json") { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                NSLog(error.localizedDescription)
            }
        }
    }
    
    func markCompletedTask(at indexPath: IndexPath) {
        
    }
    
    func showHideCompleted() {
        isShowingCompleted.toggle()
        updateView(with: self.tasks)
    }
}
