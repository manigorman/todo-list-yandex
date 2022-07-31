//
//  ViewController.swift
//  ToDoList
//
//  Created by Igor Manakov on 30.07.2022.
//

import UIKit

class TaskViewController: UIViewController {
    
    // MARK: - Properties
    
    var id: UUID = UUID()
    
    let contentView = TaskView()
    
    var deadline: Date? = nil
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Дело"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(handleDone))
        
        view.backgroundColor = UIColor(named: "PrimaryBackground")
        view.addSubview(contentView)
        
        contentView.textView.delegate = self
        
        contentView.deadlineSwitch.addTarget(self, action: #selector(handleDateSwitch(_:)), for: .valueChanged)
        contentView.dateButton.addTarget(self, action: #selector(handleDateButton), for: .touchUpInside)
        contentView.deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        contentView.datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.frame = view.bounds
        
    }
    
    // MARK: - Selectors
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        for recognizer in self.view.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(recognizer)
        }
    }
    
    @objc private func handleCancel() {
    }
    
    @objc private func handleDone() {
        let importance: Importance
        switch contentView.importanceSegmentedControl.selectedSegmentIndex {
        case 0:
            importance = Importance.low
        case 2:
            importance = Importance.important
        default:
            importance = Importance.basic
        }
        
        FileCache.shared.addNewItem(ToDoItem(id: self.id,
                                             text: contentView.textView.text,
                                             importance: importance,
                                             deadline: self.deadline,
                                             isCompleted: false,
                                             createdAt: Date()))
        
        print(FileCache.shared.list)
        do {
            try FileCache.shared.saveJSONItems(to: "Data.json")
        } catch {
            print(error)
        }
    }
    
    @objc private func handleDateSwitch(_ sender: UISwitch) {
        
        UIView.animate(withDuration: 0.3) {
            if sender.isOn {
                self.showDateButton()
                self.deadline = self.contentView.datePicker.date
            } else {
                self.deadline = nil
                self.contentView.divider2.isHidden = true
                self.contentView.divider2.alpha = 0
                self.contentView.pickerContainerView.isHidden = true
                self.contentView.pickerContainerView.alpha = 0
                self.contentView.dateButton.isHidden = true
                self.contentView.dateButton.alpha = 0
                self.contentView.listStackView.layoutIfNeeded()
            }
        }
    }
    
    
    @objc private func handleDateButton() {
        
        UIView.animate(withDuration: 0.3) {
            self.contentView.pickerContainerView.isHidden = false
            self.contentView.pickerContainerView.alpha = 1
            self.contentView.divider2.isHidden = false
            self.contentView.divider2.alpha = 1
            self.contentView.listStackView.layoutIfNeeded()
        }
    }
    
    @objc private func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        
        self.deadline = sender.date
        self.contentView.dateButton.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    }
    
    @objc private func handleDelete() {
        let _ = FileCache.shared.removeItem(with: id)
        print(FileCache.shared.list)
        do {
            try FileCache.shared.saveJSONItems(to: "Data.json")
        } catch {
            print(error)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        contentView.contentScrollView.contentInset = contentInsets
        contentView.contentScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        contentView.contentScrollView.contentInset = contentInsets
        contentView.contentScrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - Methods
    
    private func configure() {
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
        
        self.id = task.id
        self.deadline = task.deadline
        self.contentView.textView.text = task.text
        
        let index: Int
        switch task.importance {
        case .low:
            index = 0
        case .important:
            index = 2
        default:
            index = 1
        }
        self.contentView.importanceSegmentedControl.selectedSegmentIndex = index
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        
        guard let deadline = task.deadline else {
            return
        }
        
        self.contentView.dateButton.setTitle(dateFormatter.string(from: deadline), for: .normal)
        self.contentView.datePicker.date = deadline
        
        self.showDateButton()
        self.contentView.deadlineSwitch.isOn = true
    }
    
    private func showDateButton() {
        self.contentView.dateButton.isHidden = false
        self.contentView.dateButton.alpha = 1
        self.contentView.listStackView.layoutIfNeeded()
    }
}
