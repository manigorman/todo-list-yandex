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
    
    private let fileCacheService: IFileCacheService
    
    // Models
    
    // MARK: - Initialization
    
    init(router: ITaskDetailsRouter,
         fileCacheService: FileCacheService,
         task: ToDoItem?) {
        self.router = router
        self.fileCacheService = fileCacheService
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
        guard let task = task else {
            fileCacheService.insert(ToDoItem(id: UUID(),
                                             text: item.text,
                                             importance: item.importance,
                                             deadline: item.deadline,
                                             isCompleted: false,
                                             createdAt: Date(),
                                             changedAt: nil)) { [weak self] error in
                if let error = error {
                    print(error)
                    return
                } else {
                    self?.fileCacheService.load { _ in
                    }
                    DispatchQueue.main.async {
                        self?.router.dismiss()
                    }
                }
            }
            return
        }
        
        fileCacheService.update(ToDoItem(id: task.id,
                                         text: item.text,
                                         importance: item.importance,
                                         deadline: item.deadline,
                                         isCompleted: task.isCompleted,
                                         createdAt: self.task?.createdAt ?? Date(),
                                         changedAt: Date())) { [weak self] error in
            if let error = error {
                print(error)
            } else {
                self?.fileCacheService.load { _ in
                }
                DispatchQueue.main.async {
                    self?.router.dismiss()
                }
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
