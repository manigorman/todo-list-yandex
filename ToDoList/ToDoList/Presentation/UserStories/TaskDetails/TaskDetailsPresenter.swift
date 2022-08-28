//
//  TaskDetailsPresenter.swift
//  ToDoList
//
//  Created by Igor Manakov on 22.08.2022.
//

import Foundation

protocol ITaskDetailsPresenter: AnyObject {
    func viewDidLoad()
    func didTapCancelButton()
    func didTapSaveButton(with task: ToDoItem)
    func didTapDeleteButton()
}

final class TaskDetailsPresenter {
    
    // Dependencies
    weak var view: ITaskDetailsView?
    
    private let router: ITaskDetailsRouter
    
    private lazy var viewModelFactory = TaskDetailsViewModelFactory()
    
    // Private
    private var task: ToDoItem? {
        didSet {
            updateView(with: task)
        }
    }
    
    private let cache = MockFileCacheService()
    
    // Models
    
    // MARK: - Initialization
    
    init(router: ITaskDetailsRouter,
         task: ToDoItem?) {
        self.router = router
        self.task = task
    }
    
    // MARK: - Private
    
    private func updateView(with task: ToDoItem?) {
        let viewModel = viewModelFactory.makeModel(task: task)
        
        view?.update(with: viewModel)
    }
}

// MARK: - ITaskDetailsPresenter

extension TaskDetailsPresenter: ITaskDetailsPresenter {
    
    func didTapCancelButton() {
        router.dismiss()
    }
    
    func didTapSaveButton(with item: ToDoItem) {
        
        cache.add(ToDoItem(id: task?.id ?? UUID(),
                           text: item.text,
                           importance: item.importance,
                           deadline: item.deadline,
                           isCompleted: self.task?.isCompleted ?? false,
                           createdAt: self.task?.createdAt ?? Date(),
                           changedAt: self.task != nil ? Date() : nil))
        
        cache.save(to: "Data.json") { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                NSLog(error.localizedDescription)
            }
        }
        
        router.dismiss()
    }
    
    func viewDidLoad() {
        updateView(with: task)
    }
    
    func didTapDeleteButton() {
//        FileCache.shared.removeItem(with: task.id)
//        self.dismiss(animated: true)
//        do {
//            try FileCache.shared.saveJSONItems(to: "Data.json")
//        } catch {
//            NSLog(error.localizedDescription)
//        }
    }
}
