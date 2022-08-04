//
//  TaskView.swift
//  ToDoList
//
//  Created by Igor Manakov on 31.07.2022.
//

import UIKit

final class TaskView: UIView {
    
    // MARK: - Properties
    
    var delegate: TaskViewDelegate?
    
    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .appColor(.secondaryBack)
        textView.font = .systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 17, right: 16)
        textView.layer.cornerRadius = 16
        textView.isScrollEnabled = false
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private lazy var listStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .appColor(.secondaryBack)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var importanceContainerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var importanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        label.font = .systemFont(ofSize: 17)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var importanceSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        let font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        segmentedControl.insertSegment(with: UIImage(systemName: "arrow.down",
                                                     withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withTintColor(.appColor(.lightGray) ?? .lightGray, renderingMode: .alwaysOriginal),
                                       at: 0,
                                       animated: false)
        segmentedControl.insertSegment(withTitle: "нет", at: 1, animated: false)
        segmentedControl.insertSegment(with: UIImage(systemName: "exclamationmark.2",
                                                     withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withTintColor(.appColor(.red) ?? .red, renderingMode: .alwaysOriginal),
                                       at: 2,
                                       animated: false)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor(.separator)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var deadlineContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var deadlineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Сделать до"
        label.font = .systemFont(ofSize: 17)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.appColor(.blue), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.contentHorizontalAlignment = .left
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var deadlineSwitch: UISwitch = {
        let toggle = UISwitch()
        
        
        toggle.translatesAutoresizingMaskIntoConstraints = false
        
        return toggle
    }()
    
    private lazy var divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor(.separator)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var pickerContainerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.minimumDate = Date()
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.appColor(.red), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.backgroundColor = .appColor(.secondaryBack)
        button.layer.cornerRadius = 16
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
        defaultConfigure()
        
        deadlineSwitch.addTarget(self, action: #selector(handleDateSwitch(_:)), for: .valueChanged)
        dateButton.addTarget(self, action: #selector(handleDateButton), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        
        textView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setConstraints()
    }
    
    // MARK: - Selectors
    
    @objc private func handleDateSwitch(_ sender: UISwitch) {
        
        UIView.animate(withDuration: 0.3) {
            if sender.isOn {
                self.showDateButton()
            } else {
                self.divider2.isHidden = true
                self.divider2.alpha = 0
                self.pickerContainerView.isHidden = true
                self.pickerContainerView.alpha = 0
                self.dateButton.isHidden = true
                self.datePicker.isHidden = true
                self.dateButton.alpha = 0
                self.listStackView.layoutIfNeeded()
            }
        }
    }
    
    @objc private func handleDateButton() {
        
        UIView.animate(withDuration: 0.3) {
            self.pickerContainerView.isHidden = false
            self.pickerContainerView.alpha = 1
            self.divider2.isHidden = false
            self.datePicker.isHidden = false
            self.divider2.alpha = 1
            self.listStackView.layoutIfNeeded()
            
        }
    }
    
    @objc private func handleDatePicker(_ sender: UIDatePicker) {
        self.dateButton.setTitle(DateFormatter.ruRuLong.string(from: sender.date), for: .normal)
    }
    
    @objc private func handleDelete() {
        self.defaultConfigure()
        textView.resignFirstResponder()
        delegate?.didTapDeleteButton()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap)
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        contentScrollView.contentInset = contentInsets
        contentScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        contentScrollView.contentInset = contentInsets
        contentScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
        for recognizer in gestureRecognizers ?? [] {
            removeGestureRecognizer(recognizer)
        }
    }
    
    // MARK: - Methods
    
    private func setupView() {
        backgroundColor = .appColor(.primaryBack)
        
        addSubview(contentScrollView)
        
        contentScrollView.addSubview(contentView)
        
        contentView.addSubview(textView)
        contentView.addSubview(listStackView)
        contentView.addSubview(deleteButton)
        
        listStackView.addArrangedSubview(importanceContainerView)
        listStackView.addArrangedSubview(divider)
        listStackView.addArrangedSubview(deadlineContainerView)
        listStackView.addArrangedSubview(divider2)
        listStackView.addArrangedSubview(pickerContainerView)
        
        importanceContainerView.addSubview(importanceLabel)
        importanceContainerView.addSubview(importanceSegmentedControl)
        
        deadlineContainerView.addSubview(deadlineStackView)
        deadlineContainerView.addSubview(deadlineSwitch)
        
        deadlineStackView.addArrangedSubview(deadlineLabel)
        deadlineStackView.addArrangedSubview(dateButton)
        pickerContainerView.addSubview(datePicker)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.constantPositive),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.constantPositive),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.constantNegative),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.textViewMinHeight)
        ])
        
        NSLayoutConstraint.activate([
            listStackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: Constants.constantPositive),
            listStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.constantPositive),
            listStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.constantNegative),
        ])
        
        NSLayoutConstraint.activate([
            importanceContainerView.topAnchor.constraint(equalTo: listStackView.topAnchor),
            importanceContainerView.leadingAnchor.constraint(equalTo: listStackView.leadingAnchor),
            importanceContainerView.trailingAnchor.constraint(equalTo: listStackView.trailingAnchor),
            importanceContainerView.heightAnchor.constraint(equalToConstant: Constants.containerHeight),
            
            importanceLabel.topAnchor.constraint(equalTo: importanceContainerView.topAnchor, constant: 17),
            importanceLabel.leadingAnchor.constraint(equalTo: importanceContainerView.leadingAnchor, constant: Constants.constantPositive),
            importanceLabel.trailingAnchor.constraint(equalTo: importanceSegmentedControl.leadingAnchor),
            importanceLabel.heightAnchor.constraint(equalToConstant: 22),
            
            importanceSegmentedControl.topAnchor.constraint(equalTo: importanceContainerView.topAnchor, constant: 10),
            importanceSegmentedControl.trailingAnchor.constraint(equalTo: importanceContainerView.trailingAnchor, constant: -12),
            importanceSegmentedControl.widthAnchor.constraint(equalToConstant: Constants.segmentedControlWidth),
            importanceSegmentedControl.heightAnchor.constraint(equalToConstant: Constants.segmentedControlHeight)
        ])
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: importanceContainerView.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: listStackView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: listStackView.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            deadlineContainerView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            deadlineContainerView.leadingAnchor.constraint(equalTo: listStackView.leadingAnchor),
            deadlineContainerView.trailingAnchor.constraint(equalTo: listStackView.trailingAnchor),
            deadlineContainerView.heightAnchor.constraint(equalToConstant: Constants.containerHeight),
            
            deadlineSwitch.topAnchor.constraint(equalTo: deadlineContainerView.topAnchor, constant: 13.5),
            deadlineSwitch.trailingAnchor.constraint(equalTo: listStackView.trailingAnchor, constant: -12),
            deadlineSwitch.widthAnchor.constraint(equalToConstant: Constants.switchWidth),
            deadlineSwitch.heightAnchor.constraint(equalToConstant: Constants.switchHeight),
            
            deadlineStackView.centerYAnchor.constraint(equalTo: deadlineContainerView.centerYAnchor),
            deadlineStackView.leadingAnchor.constraint(equalTo: listStackView.leadingAnchor, constant: Constants.constantPositive),
            deadlineStackView.trailingAnchor.constraint(equalTo: deadlineSwitch.leadingAnchor, constant: Constants.constantNegative),
        ])
        
        NSLayoutConstraint.activate([
            divider2.topAnchor.constraint(equalTo: deadlineContainerView.bottomAnchor),
            divider2.leadingAnchor.constraint(equalTo: listStackView.leadingAnchor),
            divider2.trailingAnchor.constraint(equalTo: listStackView.trailingAnchor),
            divider2.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            pickerContainerView.topAnchor.constraint(equalTo: divider2.bottomAnchor),
            pickerContainerView.leadingAnchor.constraint(equalTo: listStackView.leadingAnchor),
            pickerContainerView.trailingAnchor.constraint(equalTo: listStackView.trailingAnchor),
            
            datePicker.topAnchor.constraint(equalTo: pickerContainerView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor, constant: Constants.constantPositive),
            datePicker.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor, constant: Constants.constantNegative),
            datePicker.bottomAnchor.constraint(equalTo: pickerContainerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: listStackView.bottomAnchor, constant: Constants.constantPositive),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.constantPositive),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.constantNegative),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.constantNegative),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.containerHeight)
        ])
    }
    
    public func defaultConfigure() {
        UIView.animate(withDuration: 0.3) {
            self.textView.text = "Что надо сделать?"
            self.textView.textColor = .appColor(.tertiary)
            
            self.importanceSegmentedControl.selectedSegmentIndex = 1
            
            self.dateButton.isHidden = true
            self.dateButton.alpha = 0
            
            self.deadlineSwitch.isOn = false
            
            
            self.divider2.isHidden = true
            self.divider2.alpha = 0
            
            self.pickerContainerView.isHidden = true
            self.pickerContainerView.alpha = 0
            
            self.datePicker.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            
            self.dateButton.setTitle(DateFormatter.ruRuLong.string(from: self.datePicker.date), for: .normal)
        }
    }
    
    public func configure(with task: ToDoItem) {
        textView.text = task.text
        
        switch task.importance {
        case .low:
            importanceSegmentedControl.selectedSegmentIndex = 0
        case .basic:
            importanceSegmentedControl.selectedSegmentIndex = 1
        case .important:
            importanceSegmentedControl.selectedSegmentIndex = 2
        }
        
        guard let deadline = task.deadline else {
            datePicker.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            return
        }
        
        deadlineSwitch.isOn = true
        dateButton.setTitle(DateFormatter.ruRuLong.string(from: deadline), for: .normal)
        datePicker.date = deadline
        
        showDateButton()
    }
    
    private func showDateButton() {
        dateButton.isHidden = false
        dateButton.alpha = 1
        listStackView.layoutIfNeeded()
    }
    
    public func getTask() -> ToDoItem {
        let importance: Importance
        
        switch importanceSegmentedControl.selectedSegmentIndex {
        case 0:
            importance = Importance.low
        case 2:
            importance = Importance.important
        default:
            importance = Importance.basic
        }
        
        return ToDoItem(text: textView.textColor == .appColor(.tertiary) ? "" : textView.text,
                        importance: importance,
                        deadline: deadlineSwitch.isOn ? datePicker.date : nil)
    }
}

protocol TaskViewDelegate {
    func didTapDeleteButton()
}
