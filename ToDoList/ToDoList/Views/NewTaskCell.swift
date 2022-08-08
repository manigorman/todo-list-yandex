//
//  NewTaskCell.swift
//  ToDoList
//
//  Created by Igor Manakov on 06.08.2022.
//

import UIKit

final class NewTaskCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let id = "newTaskCellId"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Новое"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .appColor(.tertiary)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .appColor(.secondaryBack)
        contentView.addSubview(label)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstants.topInset),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.newCellLeadingInset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingInset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: LayoutConstants.bottomInset),
        ])
    }
}
