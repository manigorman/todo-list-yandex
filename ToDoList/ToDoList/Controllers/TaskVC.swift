//
//  ViewController.swift
//  ToDoList
//
//  Created by Igor Manakov on 30.07.2022.
//

import UIKit

final class TaskVC: UIViewController {
    
    // MARK: - Properties
    
    lazy var task = ToDoItem(text: "")
    
    lazy private var contentView: TaskView = {
        let view = TaskView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        
        contentView.delegate = self
    }
    
    // MARK: - Selectors
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleDone() {
        let item = contentView.getTask()
        
        FileCache.shared.addNewItem(ToDoItem(id: self.task.id,
                                             text: item.text,
                                             importance: item.importance,
                                             deadline: item.deadline,
                                             isCompleted: self.task.isCompleted,
                                             createdAt: self.task.createdAt,
                                             changedAt: Date()))
        
        do {
            try FileCache.shared.saveJSONItems(to: "Data.json")
        } catch {
            print(error)
        }
        
        dismiss(animated: true)
    }
    
    // MARK: - Methods
    
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Дело"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(handleDone))
        
        view.addSubview(contentView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    public func configure(with task: ToDoItem) {
        self.task = task
        self.contentView.configure(with: task)
    }
    
    public func defaultConfigure() {
        self.contentView.defaultConfigure()
    }
}

// MARK: - Extensions

extension TaskVC: TaskViewDelegate {
    func didTapDeleteButton() {
        FileCache.shared.removeItem(with: task.id)
        self.dismiss(animated: true)
        do {
            try FileCache.shared.saveJSONItems(to: "Data.json")
        } catch {
            print(error)
        }
    }
}
