//
//  NewTaskCell.swift
//  ToDoList
//
//  Created by Igor Manakov on 06.08.2022.
//

import UIKit
import SnapKit

private extension CGFloat {
    static let margin: CGFloat = 16
    static let leadingInset: CGFloat = 52
}

final class NewTaskCell: UITableViewCell {
    
    static let id = "newTaskCellId"
    
    // UI
    private lazy var label = UILabel()
    
    // MARK: - Init
    
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
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        backgroundColor = .appColor(.secondaryBack)
        
        label.text = "Новое"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .appColor(.tertiary)
    }
    
    private func setUpConstraints() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(CGFloat.margin)
            $0.leading.equalToSuperview().inset(CGFloat.leadingInset)
        }
    }
}
