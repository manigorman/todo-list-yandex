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
    func didTapSaveButton()
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
    
    func didTapSaveButton() {
        print("save")
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
