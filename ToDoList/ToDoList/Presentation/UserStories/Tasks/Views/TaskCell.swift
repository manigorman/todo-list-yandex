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
        labelStack.distribution = .fill
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        titleText.font = .systemFont(ofSize: 17)
        titleText.textColor = .appColor(.primaryLabel)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.numberOfLines = 3
        
        subtitleText.font = .systemFont(ofSize: 15)
        subtitleText.textColor = .appColor(.tertiary)
        subtitleText.translatesAutoresizingMaskIntoConstraints = false
        
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
            $0.size.equalTo(16)
        }
        
        addSubview(labelStack)
        labelStack.snp.makeConstraints {
            $0.leading.equalTo(radioImage.snp.trailing).offset(16)
            $0.top.trailing.bottom.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(42)
        }
        
        labelStack.addArrangedSubview(titleText)
        labelStack.addArrangedSubview(subtitleText)
    }
    
    public func configure(with task: TaskCell.Model) {
        self.radioImage.image = task.radioImage
        self.titleText.attributedText = task.titleText
        guard let subtitleText = task.subtitleText else {
            self.subtitleText.isHidden = true
            return
        }
        self.subtitleText.attributedText = subtitleText
    }
}
