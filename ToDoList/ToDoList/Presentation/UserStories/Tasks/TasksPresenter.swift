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
    func didTapCell(task: ToDoItem?)
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
    private let fileCacheService: IFileCacheService
    
    private var isShowingCompleted = false
    
    // Models
    private var tasks: [ToDoItem] = [] {
        didSet {
            updateView(with: tasks)
        }
    }
    
    // MARK: - Initialization
    
    init(router: ITasksRouter,
         fileCacheService: FileCacheService) {
        self.router = router
        self.fileCacheService = fileCacheService
    }
    
    // MARK: - Private
    
    private func updateView(with tasks: [ToDoItem]) {
        let viewModel = viewModelFactory.makeModel(tasks: tasks, showingCompleted: isShowingCompleted)
        
        view?.update(with: viewModel)
    }
    
    private func fetchTasks() {
        fileCacheService.load { result in
            switch result {
            case .success(let items):
                self.tasks = items
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - ITasksPresenter

extension TasksPresenter: ITasksPresenter {
    
    func viewDidLoad() {
        fileCacheService.addDelegate(self)
        fetchTasks()
    }
    
    func didTapCell(task: ToDoItem?) {
        router.openNewTask(with: task)
    }
    
    func removeTask(at indexPath: IndexPath) {
        fileCacheService.delete(by: self.tasks[indexPath.row].id) { [weak self] error in
            guard let error = error else {
                DispatchQueue.main.async {
                    self?.fileCacheService.load { _ in
}
                }
                return
            }
            print(error.localizedDescription)
        }
    }
    
    func markCompletedTask(at indexPath: IndexPath) {
        fileCacheService.update(ToDoItem(id: tasks[indexPath.row].id,
                              text: tasks[indexPath.row].text,
                              importance: tasks[indexPath.row].importance,
                              deadline: tasks[indexPath.row].deadline,
                              isCompleted: !tasks[indexPath.row].isCompleted,
                              createdAt: tasks[indexPath.row].createdAt,
                              changedAt: tasks[indexPath.row].changedAt)) { [weak self] error in
            guard let error = error else {
                DispatchQueue.main.async {
                    self?.fileCacheService.load { _ in
                    }
                }
                return
            }
            print(error.localizedDescription)
        }
    }
    
    func showHideCompleted() {
        isShowingCompleted.toggle()
        updateView(with: self.tasks)
    }
}

extension TasksPresenter: FileCacheServiceDelegate {
    func didUpdateTasks(_ tasks: [ToDoItem]) {
        self.tasks = tasks
    }
}
