//
//  TaskCell.swift
//  ToDoList
//
//  Created by Igor Manakov on 04.08.2022.
//

import UIKit

final class TaskCell: UITableViewCell {
    
    // MARK: - Properties
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 17)
        label.textColor = .appColor(.primaryLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        
        return label
    }()
    
    public lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 15)
        label.textColor = .appColor(.tertiary)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var radioImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "circle",
                                                   withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withTintColor(.appColor(.green) ?? UIColor.green, renderingMode: .alwaysOriginal))
        imageView.contentMode = .scaleToFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
        self.dateLabel.isHidden = false
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .appColor(.secondaryBack)
        
        contentView.addSubview(radioImage)
        contentView.addSubview(labelStack)
        labelStack.addArrangedSubview(descriptionLabel)
        labelStack.addArrangedSubview(dateLabel)
        
    }
    
    public func configure(with task: ToDoItem) {
        let importanceImageAttachment = NSTextAttachment()
        let fullDescriptionString = NSMutableAttributedString(string: "")
        
        switch task.importance {
        case .low:
            importanceImageAttachment.image = SFSymbols.lowImage
            fullDescriptionString.append(NSAttributedString(attachment: importanceImageAttachment))
        
            if task.isCompleted {
            fullDescriptionString.append(NSAttributedString(string: " \(task.text)", attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]))
            } else {
                fullDescriptionString.append(NSAttributedString(string: " \(task.text)"))
            }
        case .important:
            importanceImageAttachment.image = SFSymbols.importantImage
            fullDescriptionString.append(NSAttributedString(attachment: importanceImageAttachment))
           
            if task.isCompleted {
            fullDescriptionString.append(NSAttributedString(string: " \(task.text)", attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]))
            } else {
                fullDescriptionString.append(NSAttributedString(string: " \(task.text)"))
            }
        case .basic:
           
            if task.isCompleted {
            fullDescriptionString.append(NSAttributedString(string: "\(task.text)", attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]))
            } else {
                fullDescriptionString.append(NSAttributedString(string: "\(task.text)"))
            }
        }
        
        descriptionLabel.attributedText = fullDescriptionString
        
        if task.isCompleted {
            radioImage.image = SFSymbols.checkmarkImage
        } else {
                radioImage.image = task.importance == Importance.important ? SFSymbols.circleFilledImage : SFSymbols.circleImage
        }
        
        guard let deadline = task.deadline else {
            dateLabel.isHidden = true
            return
        }
        
        let dateImageAttachment = NSTextAttachment()
        let fullDateString = NSMutableAttributedString(string: "")
        dateImageAttachment.image = SFSymbols.calendarImage
        fullDateString.append(NSAttributedString(attachment: dateImageAttachment))
        fullDateString.append(NSAttributedString(string: " \(DateFormatter.ruRuLong.string(from: deadline))"))
        
        dateLabel.attributedText = fullDateString
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            radioImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.leadingInset),
            radioImage.widthAnchor.constraint(equalToConstant: LayoutConstants.radioImageSize),
            radioImage.heightAnchor.constraint(equalToConstant: LayoutConstants.radioImageSize),
            
            labelStack.leadingAnchor.constraint(equalTo: radioImage.trailingAnchor, constant: LayoutConstants.cellLeadingInset),
            labelStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingInset),
            labelStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstants.cellTopInset),
            labelStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: LayoutConstants.cellBottomInset),
            labelStack.heightAnchor.constraint(greaterThanOrEqualToConstant: LayoutConstants.labelStackMinHeight)
        ])
    }
}
