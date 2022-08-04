//
//  ViewController.swift
//  ToDoList
//
//  Created by Igor Manakov on 30.07.2022.
//

import UIKit

final class TaskViewController: UIViewController {
    
    // MARK: - Properties
    
    var id: UUID = UUID()
    
    private lazy var contentView = TaskView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        contentView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try FileCache.shared.loadJSONItems(from: "Data.json")
        } catch {
            print(error)
            return
        }
        
        guard let task = FileCache.shared.list.first else {
            print("No tasks in Data.json")
            return
        }
        
        id = task.id
        
        contentView.configure(with: task)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.frame = view.bounds
    }
    
    // MARK: - Selectors
    
    @objc private func handleCancel() {
    }
    
    @objc private func handleDone() {
        let task = contentView.getTask()
        
        FileCache.shared.addNewItem(ToDoItem(id: self.id,
                                             text: task.text,
                                             importance: task.importance,
                                             deadline: task.deadline,
                                             isCompleted: false,
                                             createdAt: Date()))
        
        print(FileCache.shared.list)
        do {
            try FileCache.shared.saveJSONItems(to: "Data.json")
        } catch {
            print(error)
        }
    }
    
    // MARK: - Methods
    
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Дело"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(handleDone))
        
        view.addSubview(contentView)
    }
}

extension TaskViewController: TaskViewDelegate {
    func didTapDeleteButton() {
        FileCache.shared.removeItem(with: id)
        print(FileCache.shared.list)
        do {
            try FileCache.shared.saveJSONItems(to: "Data.json")
        } catch {
            print(error)
        }
    }
}
