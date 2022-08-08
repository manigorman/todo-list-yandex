//
//  Constants.swift
//  ToDoList
//
//  Created by Igor Manakov on 03.08.2022.
//

import Foundation
import UIKit

enum SFSymbols {
    static let trashImage: UIImage = UIImage(systemName: "trash.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))!.withTintColor(.appColor(.white) ?? .white, renderingMode: .alwaysOriginal)
    
    static let infoImage: UIImage = UIImage(systemName: "info.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))!.withTintColor(.appColor(.white) ?? .white, renderingMode: .alwaysOriginal)
    
    static let checkmarkImage: UIImage = UIImage(systemName: "checkmark.circle.fill",
                                                 withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))!.withTintColor(.appColor(.green) ?? .systemGreen, renderingMode: .alwaysOriginal)
    
    static let circleImage: UIImage = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))!.withTintColor(.appColor(.separator) ?? .lightGray, renderingMode: .alwaysOriginal)
    
    static let lowImage: UIImage = UIImage(systemName: "arrow.down",
                                           withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!.withTintColor(.appColor(.lightGray) ?? .lightGray, renderingMode: .alwaysOriginal)
    
    static let importantImage: UIImage = UIImage(systemName: "exclamationmark.2",
                                                 withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!.withTintColor(.appColor(.red) ?? .red, renderingMode: .alwaysOriginal)
    
    static let calendarImage: UIImage = UIImage(systemName: "calendar",
                                                withConfiguration: UIImage.SymbolConfiguration(weight: .light))!.withTintColor(.appColor(.tertiary) ?? .lightGray, renderingMode: .alwaysOriginal)
    
    static let circleFilledImage: UIImage = UIImage(systemName: "circle.inset.filled",
                                                    withConfiguration: UIImage.SymbolConfiguration(paletteColors: [UIColor(named: "lightRed") ?? .systemRed, .appColor(.red) ?? .red]))!
}

enum NotificationKeys {
    static let fileCacheNotificationKey = "fileCacheNotificationKey"
}

enum LayoutConstants {
    
    static let leadingInset: CGFloat = 16
    static let trailingInset: CGFloat = -16
    static let topInset: CGFloat = 16
    static let bottomInset: CGFloat = -16
    
    static let cellLeadingInset: CGFloat = 16
    static let cellTopInset: CGFloat = 16
    static let cellBottomInset: CGFloat = -16
    
    static let controlTrailingInset: CGFloat = -12
    
    static let dividerHeight: CGFloat = 1
    
    static let textViewMinHeight: CGFloat = 120
    
    static let containerHeight: CGFloat = 56
    
    static let switchHeight: CGFloat = 31
    static let switchWidth: CGFloat = 51
    
    static let segmentedControlHeight: CGFloat = 36
    static let segmentedControlWidth: CGFloat = 150
    
    static let radioImageSize: CGFloat = 24
    
    static let labelStackMinHeight: CGFloat = 42
    
    static let newCellLeadingInset: CGFloat = 52
}
