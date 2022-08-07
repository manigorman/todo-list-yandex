//
//  ListVC.swift
//  ToDoList
//
//  Created by Igor Manakov on 04.08.2022.
//

import UIKit

final class ListVC: UIViewController {
    
    // MARK: - Properties
    
    private lazy var list: [ToDoItem] = []
    
    private var isShowingCompleted = false
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .appColor(.primaryBack)
        
        table.register(TaskCell.self, forCellReuseIdentifier: "taskCellId")
        table.register(NewTaskCell.self, forCellReuseIdentifier: "newTaskCellId")
        table.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(modelUpdatedNotification), name: NSNotification.Name(rawValue: NotificationKeys.fileCacheNotificationKey), object: nil)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Мои дела"
        
        setupViews()
        setDelegate()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            try FileCache.shared.loadJSONItems(from: "Data.json")
        } catch {
            print(error)
            return
        }
        
        self.list = FileCache.shared.list.filter { $0.isCompleted == false }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        try! FileCache.shared.saveJSONItems(to: "Data.json")
    }
    
    // MARK: - Selectors
    
    @objc private func modelUpdatedNotification() {
        print("Updating table")
        
        self.list = self.isShowingCompleted ? FileCache.shared.list : FileCache.shared.list.filter { $0.isCompleted == false }
        self.list = self.list.sorted{ $0.createdAt < $1.createdAt }
        self.tableView.reloadData()
    }
    
    
    // MARK: - Methods
    
    private func setupViews() {
        self.view.addSubview(tableView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func handleMarkAsCompleted(at indexPath: IndexPath) {
        let item = self.list[indexPath.row]
        let newItem = ToDoItem(id: item.id,
                               text: item.text,
                               importance: item.importance,
                               deadline: item.deadline,
                               isCompleted: !item.isCompleted,
                               createdAt: item.createdAt,
                               changedAt: item.changedAt)
        FileCache.shared.addNewItem(newItem)
    }
    
    private func handleMoveToTrash(at indexPath: IndexPath) {
//        let deletedElement = self.list.remove(at: indexPath.row)
//        self.tableView.deleteRows(at: [indexPath], with: .fade)
        FileCache.shared.removeItem(with: self.list[indexPath.row].id)
        do {
            try FileCache.shared.saveJSONItems(to: "Data.json")
        } catch {
            print(error)
        }
    }
    
    private func handleEdit(at indexPath: IndexPath) {
        let taskVC = TaskVC()
        taskVC.configure(with: self.list[indexPath.row])
        let navigationVC = UINavigationController(rootViewController: taskVC)
        navigationVC.modalPresentationStyle = .pageSheet
        present(navigationVC, animated: true, completion: nil)
    }
    
}

// MARK: - Extensions

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.list.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.list.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellId", for: indexPath) as! TaskCell
            cell.accessoryType = .disclosureIndicator
            cell.configure(with: self.list[indexPath.row])
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newTaskCellId", for: indexPath) as! NewTaskCell
            cell.accessoryType = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = HeaderView()
        headerView.configure(title: self.isShowingCompleted ? "Скрыть" : "Показать", number: FileCache.shared.list.filter{ $0.isCompleted == true }.count)
        headerView.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let taskVC = TaskVC()
        if indexPath.row < self.list.count {
            taskVC.configure(with: list[indexPath.row])
        } else {
            taskVC.defaultConfigure()
        }
        
        let navigationVC = UINavigationController(rootViewController: taskVC)
        navigationVC.modalPresentationStyle = .pageSheet
        present(navigationVC, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.row < self.list.count {
            
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completionHandler in
                self?.handleMoveToTrash(at: indexPath)
                
                completionHandler(true)
            }
            deleteAction.backgroundColor = .appColor(.red)
            deleteAction.image = SFSymbols.trashImage
            
            let infoAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] action, view, completionHandler in
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
        if indexPath.row < self.list.count {
            let doneAction = UIContextualAction(style: .normal, title: "Done") { [weak self] action, view, completionHandler in
                self?.handleMarkAsCompleted(at: indexPath)
                completionHandler(true)
            }
            doneAction.backgroundColor = .appColor(.green)
            doneAction.image = SFSymbols.checkmarkImage.withTintColor(.appColor(.white) ?? .white, renderingMode: .alwaysOriginal)
            
            return UISwipeActionsConfiguration(actions: [doneAction])
        } else {
            return UISwipeActionsConfiguration(actions: [])
        }
    }
}

extension ListVC: HeaderViewDelegate {
    func didTapShowCompleted() {
        self.isShowingCompleted = !self.isShowingCompleted
        self.list = self.isShowingCompleted ? FileCache.shared.list : FileCache.shared.list.filter { $0.isCompleted == false }
        self.tableView.reloadData()
    }
}
