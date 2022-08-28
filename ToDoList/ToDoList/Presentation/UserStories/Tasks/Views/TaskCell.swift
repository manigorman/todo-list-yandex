//
//  TaskCell.swift
//  ToDoList
//
//  Created by Igor Manakov on 04.08.2022.
//

import UIKit
import SnapKit

final class TaskCell: UITableViewCell {
    
    static let id = "taskCellId"
    
    struct Model {
        let radioImage: UIImage
        let titleText: NSMutableAttributedString
        let subtitleText: NSMutableAttributedString?
    }
    
    // UI
    private lazy var radioImage = UIImageView()

    private lazy var labelStack = UIStackView()
    
    private lazy var titleText = UILabel()
    
    private lazy var subtitleText = UILabel()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
        setUpConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.accessoryType = .none
        self.subtitleText.isHidden = false
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        backgroundColor = .appColor(.secondaryBack)
        
        labelStack.axis = .vertical
        labelStack.spacing = 5
        
        titleText.font = .systemFont(ofSize: 17)
        titleText.textColor = .appColor(.primaryLabel)
        titleText.numberOfLines = 3
        
        subtitleText.font = .systemFont(ofSize: 15)
        subtitleText.textColor = .appColor(.tertiary)
        
        radioImage.image = UIImage(systemName: "circle",
                                   withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?
            .withTintColor(.appColor(.green),
                           renderingMode: .alwaysOriginal)
        radioImage.contentMode = .scaleToFill
    }
    
    private func setUpConstraints() {
        addSubview(radioImage)
        radioImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        addSubview(labelStack)
        labelStack.addArrangedSubview(titleText)
        labelStack.addArrangedSubview(subtitleText)
        labelStack.snp.makeConstraints {
            $0.leading.equalTo(radioImage.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(40)
            $0.top.bottom.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    public func configure(with task: ToDoItem) {
        var radioImage = UIImage()
        let descriptionAttachment = NSTextAttachment()
        var descriptionString = ""
        let descriptionText = NSMutableAttributedString(string: "")
        let dateAttachment = NSTextAttachment()
        var dateText: NSMutableAttributedString! = nil
        
        switch task.importance {
        case .low:
            descriptionAttachment.image = SFSymbols.lowImage
            descriptionString = " \(task.text)"
            descriptionText.append(NSAttributedString(attachment: descriptionAttachment))
            
        case .important:
            descriptionAttachment.image = SFSymbols.importantImage
            descriptionString = " \(task.text)"
            descriptionText.append(NSAttributedString(attachment: descriptionAttachment))
        case .basic:
            descriptionString = task.text
        }
        
        if task.isCompleted {
            descriptionText.append(NSAttributedString(string: descriptionString,
                                                      attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]))
            radioImage = SFSymbols.checkmarkImage
        } else {
            descriptionText.append(NSAttributedString(string: descriptionString))
            radioImage = task.importance == .important ? SFSymbols.circleFilledImage : SFSymbols.circleImage
        }
        
        if let deadline = task.deadline {
            dateText = NSMutableAttributedString(string: "")
            dateAttachment.image = SFSymbols.calendarImage
            dateText.append(NSAttributedString(attachment: dateAttachment))
            dateText.append(NSAttributedString(string: " \(DateFormatter.ruRuLong.string(from: deadline))"))
        }
        
        self.radioImage.image = radioImage
        self.titleText.attributedText = descriptionText
        guard let subtitleText = dateText else {
            self.subtitleText.isHidden = true
            return
        }
        self.subtitleText.attributedText = subtitleText
    }
}
