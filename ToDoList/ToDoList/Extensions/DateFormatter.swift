//
//  DateFormatter.swift
//  ToDoList
//
//  Created by Igor Manakov on 03.08.2022.
//

import Foundation

extension DateFormatter {
    
    static let ruRuLong: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
}
