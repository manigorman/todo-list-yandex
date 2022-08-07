//
//  HeaderView.swift
//  ToDoList
//
//  Created by Igor Manakov on 05.08.2022.
//

import UIKit

final class HeaderView: UIView {
    
    // MARK: - Properties
    
    var delegate: HeaderViewDelegate?
    
    private lazy var completedCount: UILabel = {
        let label = UILabel()
        label.text = "Выполнено — 0"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .appColor(.tertiary)
        
        return label
    }()
    
    private lazy var showButton: UIButton = {
        let button = UIButton()
        button.setTitle("Показать", for: .normal)
        button.setTitleColor(.appColor(.blue), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        showButton.addTarget(self, action: #selector(handleShow), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        completedCount.frame = CGRect(x: 16, y: 0, width: (bounds.width - 32) / 2, height: 20)
        showButton.frame = CGRect(x: completedCount.frame.maxX, y: 0, width: (bounds.width - 32) / 2, height: 20)
    }
    
    // MARK: - Setup
    
    func setupViews() {
        addSubview(completedCount)
        addSubview(showButton)
    }
    
    func configure(title: String, number: Int) {
        self.showButton.setTitle(title, for: .normal)
        self.completedCount.text = "Выполнено — \(number)"
    }
    
    @objc private func handleShow() {
        delegate?.didTapShowCompleted()
    }
}

// MARK: - Protocols

protocol HeaderViewDelegate {
    func didTapShowCompleted()
}
