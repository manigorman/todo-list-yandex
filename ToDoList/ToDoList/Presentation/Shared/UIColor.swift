//
//  UIColor.swift
//  ToDoList
//
//  Created by Igor Manakov on 03.08.2022.
//

import Foundation
import UIKit

enum AssetsColor {
    
    /// support
    case separator
    case overlay
    case navBar
    
    /// label
    case primaryLabel
    case secondaryLabel
    case tertiary
    case disable
    
    /// color
    case red
    case green
    case blue
    case gray
    case lightGray
    
    /// back
    case iOSPrimary
    case primaryBack
    case secondaryBack
    case elevated
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex >> 16) & 0xff) / 255
        let g = CGFloat((hex >> 08) & 0xff) / 255
        let b = CGFloat((hex >> 00) & 0xff) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension UIColor {
    
    static func appColor(_ name: AssetsColor) -> UIColor {
        switch name {
        case .separator:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0x000000, alpha: 0.2) : UIColor(hex: 0xFFFFFF, alpha: 0.2)}
        case .overlay:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0x000000, alpha: 0.06) : UIColor(hex: 0x000000, alpha: 0.32)}
        case .navBar:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0xF9F9F9).withAlphaComponent(0.8) : UIColor(hex: 0x191919).withAlphaComponent(0.9)}
        case .primaryLabel:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0x000000) : UIColor(hex: 0xFFFFFF)}
        case .secondaryLabel:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0x000000).withAlphaComponent(0.6) : UIColor(hex: 0xFFFFFF).withAlphaComponent(0.6)}
        case .tertiary:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0x000000).withAlphaComponent(0.3) : UIColor(hex: 0xFFFFFF).withAlphaComponent(0.4)}
        case .disable:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0x000000).withAlphaComponent(0.15) : UIColor(hex: 0xFFFFFF).withAlphaComponent(0.15)}
        case .red:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0xFF3A30) : UIColor(hex: 0xFF443A)}
        case .green:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0x33C659) : UIColor(hex: 0x33D649)}
        case .blue:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0x007AFF) : UIColor(hex: 0x0A84FF)}
        case .gray:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0x8E8E93) : UIColor(hex: 0x8E8E93)}
        case .lightGray:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0xD1D1D6) : UIColor(hex: 0x474749)}
        case .iOSPrimary:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0xF2F2F7) : UIColor(hex: 0x000000)}
        case .primaryBack:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0xF7F7F2) : UIColor(hex: 0x161616)}
        case .secondaryBack:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x232328)}
        case .elevated:
            return UIColor { traitCollection -> UIColor in
                traitCollection.userInterfaceStyle == .light ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x3A3A3F)}
        }
    }
}
