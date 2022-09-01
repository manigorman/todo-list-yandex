//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Igor Manakov on 22.08.2022.
//

import Foundation
import UIKit
import SnapKit

protocol ITasksView: AnyObject {
    func update(with model: TasksViewController.Model)
}

final class TasksViewController: UIViewController {
    
    struct Model {
        let headerViewModel: HeaderView.Model
        let tasks: [ToDoItem]
    }
    
    // Dependencies
    private let presenter: ITasksPresenter
    
    // Private
    private var tasks: [ToDoItem] = []
    
    // UI
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var headerView = HeaderView()
    
    // MARK: - Initialization
    
    init(presenter: ITasksPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setUpUI()
        setUpConstraint()
        setUpDelegates()
    }
    
    // MARK: - Actions
    
    // MARK: - Private
    
    private func setUpUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Мои дела"
        
        tableView.backgroundColor = .appColor(.primaryBack)
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.id)
        tableView.register(NewTaskCell.self, forCellReuseIdentifier: NewTaskCell.id)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
    }
    
    private func setUpConstraint() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setUpDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func handleMarkAsCompleted(at indexPath: IndexPath) {
        presenter.markCompletedTask(at: indexPath)
    }
    
    private func handleMoveToTrash(at indexPath: IndexPath) {
        tasks.remove(at: indexPath.row)
        presenter.removeTask(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    private func handleEdit(at indexPath: IndexPath) {
//        let taskVC = TaskViewController()
//        taskVC.configure(with: self.tasks[indexPath.row])
//        let navigationVC = UINavigationController(rootViewController: taskVC)
//        navigationVC.modalPresentationStyle = .pageSheet
//        present(navigationVC, animated: true, completion: nil)
    }
}

// MARK: - ITasksView

extension TasksViewController: ITasksView {
    func update(with model: TasksViewController.Model) {
        DispatchQueue.main.async {
            self.headerView.configure(with: model.headerViewModel)
        }
        DispatchQueue.main.async {
            self.tasks = model.tasks
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        headerView.delegate = self
        
        return headerView
    }
}

// MARK: - UITableViewDataSource

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tasks.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.tasks.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.id, for: indexPath) as? TaskCell else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            cell.configure(with: self.tasks[indexPath.row])
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskCell.id, for: indexPath) as? NewTaskCell else {
                return UITableViewCell()
            }
            cell.accessoryType = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < self.tasks.count {
            presenter.didTapCell(task: tasks[indexPath.row])
        } else {
            presenter.didTapCell(task: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.row < self.tasks.count {
            
            let deleteAction = UIContextualAction(style: .destructive,
                                                  title: "Delete") { [weak self] _, _, completionHandler in
                self?.handleMoveToTrash(at: indexPath)
                
                completionHandler(true)
            }
            deleteAction.backgroundColor = .appColor(.red)
            deleteAction.image = SFSymbols.trashImage
            
            let infoAction = UIContextualAction(style: .normal,
                                                title: "Edit") { [weak self] _, _, completionHandler in
                self?.handleEdit(at: indexPath)
                completionHandler(true)
            }
            infoAction.backgroundColor = .appColor(.lightGray)
            infoAction.image = SFSymbols.infoImage
            
            return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
        } else {
            return UISwipeActionsConfiguration(actions: [])
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row < self.tasks.count {
            let doneAction = UIContextualAction(style: .normal,
                                                title: "Done") { [weak self] _, _, completionHandler in
                self?.handleMarkAsCompleted(at: indexPath)
                completionHandler(true)
            }
            doneAction.backgroundColor = .appColor(.green)
            doneAction.image = SFSymbols.checkmarkImage.withTintColor(.white, renderingMode: .alwaysOriginal)
            
            return UISwipeActionsConfiguration(actions: [doneAction])
        } else {
            return UISwipeActionsConfiguration(actions: [])
        }
    }
}

// MARK: - HeaderView

extension TasksViewController: HeaderViewDelegate {
    func didTapShowCompleted() {
        presenter.showHideCompleted()
    }
}
