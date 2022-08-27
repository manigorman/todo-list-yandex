//
//  HeaderView.swift
//  ToDoList
//
//  Created by Igor Manakov on 05.08.2022.
//

import UIKit

final class HeaderView: UIView {
    
    struct Model {
        let titleText: String
        let buttonTitle: String
    }
    
    var delegate: HeaderViewDelegate?
    
    // UI
    private lazy var titleText = UILabel()
    
    private lazy var button = UIButton()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        
        button.addTarget(self, action: #selector(handleShow), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleText.frame = CGRect(x: 16, y: 0, width: (bounds.width - 32) / 2, height: 20)
        button.frame = CGRect(x: titleText.frame.maxX, y: 0, width: (bounds.width - 32) / 2, height: 20)
    }
    
    // MARK: - Setup
    
    func setUpViews() {
        titleText.font = .systemFont(ofSize: 15)
        titleText.textColor = .appColor(.tertiary)
        
        button.setTitleColor(.appColor(.blue), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(handleShow), for: .touchUpInside)
        
        addSubview(titleText)
        addSubview(button)
    }
    
    func configure(with model: HeaderView.Model) {
        self.titleText.text = model.titleText
        self.button.setTitle(model.buttonTitle, for: .normal)
    }
    
    @objc private func handleShow() {
        delegate?.didTapShowCompleted()
    }
}

// MARK: - Protocols

protocol HeaderViewDelegate {
    func didTapShowCompleted()
}
