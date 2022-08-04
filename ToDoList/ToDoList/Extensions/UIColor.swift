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
    case white
    
    /// back
    case iOSPrimary
    case primaryBack
    case secondaryBack
    case elevated
}

extension UIColor {

    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        
        case .separator:
            return UIColor(named: "supportSeparator")
        case .overlay:
            return UIColor(named: "supportOverlay")
        case .navBar:
            return UIColor(named: "supportNavBarBlur")
        case .primaryLabel:
            return UIColor(named: "labelPrimary")
        case .secondaryLabel:
            return UIColor(named: "labelSecondary")
        case .tertiary:
            return UIColor(named: "labelTertiary")
        case .disable:
            return UIColor(named: "labelDisable")
        case .red:
            return UIColor(named: "colorRed")
        case .green:
            return UIColor(named: "colorGreen")
        case .blue:
            return UIColor(named: "colorBlue")
        case .gray:
            return UIColor(named: "colorGray")
        case .lightGray:
            return UIColor(named: "colorLightGray")
        case .white:
            return UIColor(named: "colorWhite")
        case .iOSPrimary:
            return UIColor(named: "backIOSPrimary")
        case .primaryBack:
            return UIColor(named: "backPrimary")
        case .secondaryBack:
            return UIColor(named: "backSecondary")
        case .elevated:
            return UIColor(named: "backElevated")
        }
    }
}
