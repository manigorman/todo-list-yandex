//
//  TaskView.swift
//  ToDoList
//
//  Created by Igor Manakov on 31.07.2022.
//

import UIKit

final class TaskView: UIView {

    // MARK: - Properties
    
    public lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    public lazy var contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Что надо сделать?"
        textView.backgroundColor = .appColor(.secondaryBack)
        textView.textColor = .appColor(.lightGray)
        textView.font = .systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 17, right: 16)
        textView.layer.cornerRadius = 16
        textView.isScrollEnabled = false
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    public lazy var listStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .appColor(.secondaryBack)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    public lazy var importanceContainerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var importanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        label.font = .systemFont(ofSize: 17)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public lazy var importanceSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        let font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        segmentedControl.insertSegment(with: UIImage(systemName: "arrow.down",
                                                     withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withTintColor(.appColor(.lightGray) ?? .lightGray,
                                                                                    renderingMode: .alwaysOriginal),
                                       at: 0,
                                       animated: false)
        segmentedControl.insertSegment(withTitle: "нет", at: 1, animated: false)
        segmentedControl.insertSegment(with: UIImage(systemName: "exclamationmark.2",
                                                     withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withTintColor(.appColor(.red) ?? .red,
                                                                                    renderingMode: .alwaysOriginal),
                                       at: 2,
                                       animated: false)
        
        segmentedControl.selectedSegmentIndex = 1
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    public lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor(.separator)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var deadlineContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var deadlineStackView: UIStackView = {
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
    
    public lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setTitle("\(DateFormatter.ruRuLong.string(from: datePicker.date))", for: .normal)
        button.setTitleColor(.appColor(.blue), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.contentHorizontalAlignment = .left
        button.isHidden = true
        button.alpha = 0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    public lazy var deadlineSwitch: UISwitch = {
        let toggle = UISwitch()
        
        toggle.translatesAutoresizingMaskIntoConstraints = false
        
        return toggle
    }()
    
    public lazy var divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor(.separator)
        view.isHidden = true
        view.alpha = 0
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var pickerContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.minimumDate = Date()
        picker.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    public lazy var deleteButton: UIButton = {
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
        
        backgroundColor = .appColor(.primaryBack)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setConstraints()
    }

    // MARK: - Methods
    
    private func setup() {
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
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            listStackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            listStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            listStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            importanceContainerView.topAnchor.constraint(equalTo: listStackView.topAnchor),
            importanceContainerView.leadingAnchor.constraint(equalTo: listStackView.leadingAnchor),
            importanceContainerView.trailingAnchor.constraint(equalTo: listStackView.trailingAnchor),
            importanceContainerView.heightAnchor.constraint(equalToConstant: 56),
            
            importanceLabel.topAnchor.constraint(equalTo: importanceContainerView.topAnchor, constant: 17),
            importanceLabel.leadingAnchor.constraint(equalTo: importanceContainerView.leadingAnchor, constant: 16),
            importanceLabel.trailingAnchor.constraint(equalTo: importanceSegmentedControl.leadingAnchor),
            importanceLabel.heightAnchor.constraint(equalToConstant: 22),
            
            importanceSegmentedControl.topAnchor.constraint(equalTo: importanceContainerView.topAnchor, constant: 10),
            importanceSegmentedControl.trailingAnchor.constraint(equalTo: importanceContainerView.trailingAnchor, constant: -12),
            importanceSegmentedControl.widthAnchor.constraint(equalToConstant: 150),
            importanceSegmentedControl.heightAnchor.constraint(equalToConstant: 36)
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
            deadlineContainerView.heightAnchor.constraint(equalToConstant: 56),
            
            deadlineSwitch.topAnchor.constraint(equalTo: deadlineContainerView.topAnchor, constant: 13.5),
            deadlineSwitch.trailingAnchor.constraint(equalTo: listStackView.trailingAnchor, constant: -12),
            deadlineSwitch.widthAnchor.constraint(equalToConstant: 51),
            deadlineSwitch.heightAnchor.constraint(equalToConstant: 31),
            
            deadlineStackView.centerYAnchor.constraint(equalTo: deadlineContainerView.centerYAnchor),
            deadlineStackView.leadingAnchor.constraint(equalTo: listStackView.leadingAnchor, constant: 16),
            deadlineStackView.trailingAnchor.constraint(equalTo: deadlineSwitch.leadingAnchor, constant: -16),
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
            datePicker.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: pickerContainerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: listStackView.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            deleteButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
