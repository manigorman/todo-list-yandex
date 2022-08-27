//
//  Constants.swift
//  ToDoList
//
//  Created by Igor Manakov on 03.08.2022.
//

import Foundation
import UIKit

enum SFSymbols {
    static let trashImage: UIImage = UIImage(systemName: "trash.fill",
                                             withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))!
        .withTintColor(.white, renderingMode: .alwaysOriginal)
    
    static let infoImage: UIImage = UIImage(systemName: "info.circle.fill",
                                            withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))!
        .withTintColor(.white, renderingMode: .alwaysOriginal)
    
    static let checkmarkImage: UIImage = UIImage(systemName: "checkmark.circle.fill",
                                                 withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))!
        .withTintColor(.appColor(.green), renderingMode: .alwaysOriginal)
    
    static let circleImage: UIImage = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))!
        .withTintColor(.appColor(.separator), renderingMode: .alwaysOriginal)
    
    static let lowImage: UIImage = UIImage(systemName: "arrow.down",
                                           withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
        .withTintColor(.appColor(.lightGray), renderingMode: .alwaysOriginal)
    
    static let importantImage: UIImage = UIImage(systemName: "exclamationmark.2",
                                                 withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
        .withTintColor(.appColor(.red), renderingMode: .alwaysOriginal)
    
    static let calendarImage: UIImage = UIImage(systemName: "calendar",
                                                withConfiguration: UIImage.SymbolConfiguration(weight: .light))!
        .withTintColor(.appColor(.tertiary), renderingMode: .alwaysOriginal)
    
    static let circleFilledImage: UIImage = UIImage(systemName: "circle.inset.filled",
                                                    withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!.withTintColor(
                                                        UIColor(named: "lightRed") ?? .systemRed,
                                                        renderingMode: .alwaysOriginal)
}
