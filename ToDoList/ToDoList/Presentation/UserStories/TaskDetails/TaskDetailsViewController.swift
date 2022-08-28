//
//  TaskDetailsViewController.swift
//  ToDoList
//
//  Created by Igor Manakov on 22.08.2022.
//

import Foundation
import UIKit
import SnapKit

protocol ITaskDetailsView: AnyObject {
    func update(with model: TaskDetailsViewController.Model?)
    func shouldActivityIndicatorWorking(_ flag: Bool)
}

final class TaskDetailsViewController: UIViewController {
    
    struct Model {
        let text: String
        let importance: Int
        let date: Date?
    }
    
    // Dependencies
    private let presenter: ITaskDetailsPresenter
    
    // Private
    
    // UI
    private lazy var scrollView = UIScrollView()
    
    private lazy var containerView = UIView()
    
    private lazy var textView = UITextView()
    
    private lazy var stackView = UIStackView()
    
    private lazy var importanceContainerView = UIView()
    
    private lazy var importanceLabel = UILabel()
    
    private lazy var importanceSegmentedControl = UISegmentedControl()
    
    private lazy var divider = UIView()
    
    private lazy var deadlineContainerView = UIView()
    
    private lazy var deadlineStackView = UIStackView()
    
    private lazy var deadlineLabel = UILabel()
    
    private lazy var dateButton = UIButton()
    
    private lazy var deadlineSwitch = UISwitch()
    
    private lazy var divider2 = UIView()
    
    private lazy var pickerContainerView = UIView()
    
    private lazy var datePicker = UIDatePicker()
    
    private lazy var deleteButton = UIButton()
    
    // MARK: - Initialization
    
    init(presenter: ITaskDetailsPresenter) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)

        deadlineSwitch.addTarget(self, action: #selector(handleDateSwitch(_:)), for: .valueChanged)
        dateButton.addTarget(self, action: #selector(handleDateButton), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpConstraints()
        setUpDelegates()
        
        presenter.viewDidLoad()
    }
    
    // MARK: - Actions
    
    // keyboard
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        for recognizer in view.gestureRecognizers ?? [] {
            view.removeGestureRecognizer(recognizer)
        }
    }
    
    // controls
    @objc private func handleDateSwitch(_ sender: UISwitch) {
        UIView.animate(withDuration: 0.3) {
            if sender.isOn {
                self.showDateButton()
                self.view.layoutIfNeeded()
            } else {
                self.divider2.isHidden = true
                self.divider2.alpha = 0
                self.pickerContainerView.isHidden = true
                self.pickerContainerView.alpha = 0
                self.dateButton.isHidden = true
                self.dateButton.alpha = 0
//                self.datePicker.isHidden = true
                self.view.setNeedsLayout()
            }
        }
    }
    
    @objc private func handleDateButton() {
        UIView.animate(withDuration: 0.3) {
            self.pickerContainerView.isHidden = false
            self.pickerContainerView.alpha = 1
            self.divider2.isHidden = false
            self.divider2.alpha = 1
//            self.datePicker.isHidden = false
            self.view.setNeedsLayout()
        }
    }
    
    @objc private func handleDatePicker(_ sender: UIDatePicker) {
        self.dateButton.setTitle(DateFormatter.ruRuLong.string(from: sender.date), for: .normal)
    }
    
    @objc private func handleDelete() {
        //        self.defaultConfigure()
        //        textView.resignFirstResponder()
        //        delegate?.didTapDeleteButton()
    }
    
    @objc private func handleCancel() {
        presenter.didTapCancelButton()
    }
    
    @objc private func handleSave() {
        var importance = Importance.basic
        
        switch importanceSegmentedControl.selectedSegmentIndex {
        case 0:
            importance = Importance.low
        case 2:
            importance = Importance.important
        default:
            importance = Importance.basic
        }
        
        presenter.didTapSaveButton(with: ToDoItem(text: textView.text == "Что надо сделать?" ? "" : textView.text,
                                                  importance: importance,
                                                  deadline: deadlineSwitch.isOn ? datePicker.date : nil))
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        title = "Дело"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(handleSave))
        
        view.backgroundColor = .appColor(.primaryBack)
        
        textView.backgroundColor = .appColor(.secondaryBack)
        textView.font = .systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 16,
                                                   left: 16,
                                                   bottom: 16,
                                                   right: 16)
        textView.layer.cornerRadius = 16
        textView.isScrollEnabled = false
        textView.autocapitalizationType = .sentences
        textView.autocorrectionType = .no
        textView.textColor = .appColor(.tertiary)
        
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .appColor(.secondaryBack)
        
        importanceLabel.text = "Важность"
        importanceLabel.font = .systemFont(ofSize: 17)
        importanceLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        importanceSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)], for: .normal)
        
        importanceSegmentedControl.insertSegment(with: SFSymbols.lowImage,
                                                 at: 0,
                                                 animated: false)
        importanceSegmentedControl.insertSegment(withTitle: "нет", at: 1, animated: false)
        importanceSegmentedControl.insertSegment(with: SFSymbols.importantImage,
                                                 at: 2,
                                                 animated: false)
        
        divider.backgroundColor = .appColor(.separator)
        
        deadlineStackView.axis = .vertical
        deadlineStackView.distribution = .fillEqually
        
        deadlineLabel.text = "Сделать до"
        deadlineLabel.font = .systemFont(ofSize: 17)
        
        dateButton.setTitleColor(.appColor(.blue), for: .normal)
        dateButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        dateButton.contentHorizontalAlignment = .left
        
        divider2.backgroundColor = .appColor(.separator)
        
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.minimumDate = Date()
        
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.appColor(.red), for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 17)
        deleteButton.backgroundColor = .appColor(.secondaryBack)
        deleteButton.layer.cornerRadius = 16
    }
    
    private func setUpConstraints() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.bottom.equalToSuperview()
        }
        
        containerView.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(120)
        }
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
        stackView.addArrangedSubview(importanceContainerView)
        
        importanceContainerView.addSubview(importanceLabel)
        importanceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.leading.equalToSuperview().inset(16)
        }
        
        importanceContainerView.addSubview(importanceSegmentedControl)
        importanceSegmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(150)
            $0.height.equalTo(36)
        }
        
        importanceContainerView.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalTo(importanceSegmentedControl.snp.bottom).offset(11)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(1)
            $0.trailing.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(deadlineContainerView)
        deadlineContainerView.addSubview(deadlineStackView)
        deadlineStackView.addArrangedSubview(deadlineLabel)
        deadlineStackView.addArrangedSubview(dateButton)
        
        deadlineStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(4)
        }
        
        deadlineContainerView.addSubview(deadlineSwitch)
        deadlineSwitch.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(51)
            $0.height.equalTo(31)
            $0.bottom.equalToSuperview().inset(13)
        }
        
        stackView.addArrangedSubview(pickerContainerView)
        pickerContainerView.addSubview(divider2)
        divider2.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        pickerContainerView.addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.top.equalTo(divider2).offset(1)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        containerView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setUpDelegates() {
        textView.delegate = self
    }
    
    private func showDateButton() {
        UIView.animate(withDuration: 0.3) {
            self.dateButton.isHidden = false
            self.dateButton.alpha = 1
        }
    }
}

extension TaskDetailsViewController: ITaskDetailsView {
    
    func shouldActivityIndicatorWorking(_ flag: Bool) {
    }
    
    func update(with model: Model?) {
        guard let model = model else {
            textView.text = "Что надо сделать?"
            textView.textColor = .appColor(.tertiary)
            
            importanceSegmentedControl.selectedSegmentIndex = 1
            
            deadlineSwitch.isOn = false
            
            datePicker.date = Date()
            
            dateButton.setTitle(DateFormatter.ruRuLong.string(from: Date()), for: .normal)
            
            dateButton.isHidden = true
            dateButton.alpha = 0
            pickerContainerView.isHidden = true
            pickerContainerView.alpha = 0
            return
        }
        
        textView.text = model.text
        textView.textColor = .appColor(.primaryLabel)
        
        importanceSegmentedControl.selectedSegmentIndex = model.importance
        
        if let date = model.date {
            deadlineSwitch.isOn = true
            dateButton.setTitle(DateFormatter.ruRuLong.string(from: date), for: .normal)
            dateButton.isHidden = false
            dateButton.alpha = 1
        } else {
            deadlineSwitch.isOn = false
            dateButton.isHidden = true
            pickerContainerView.isHidden = true
            pickerContainerView.alpha = 0
            dateButton.setTitle(DateFormatter.ruRuLong.string(from: Date()), for: .normal)
            dateButton.alpha = 0
        }
    }
}

extension TaskDetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Что надо сделать?" {
            textView.text = nil
            textView.textColor = .appColor(.primaryLabel)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = .appColor(.tertiary)
        }
    }
}
