//
//  TaskDetailsViewModelFactory.swift
//  ToDoList
//
//  Created by Igor Manakov on 24.08.2022.
//

import Foundation
import UIKit

final class TaskDetailsViewModelFactory {
    func makeModel(task: ToDoItem?) -> TaskDetailsViewController.Model? {
        guard let task = task else {
            return nil
        }
        
        var importance: Int = -1
        var dateText: String?
        
        switch task.importance {
        case .low:
            importance = 0
        case .basic:
            importance = 1
        case .important:
            importance = 2
        }
        
        if let date = task.deadline {
            dateText = DateFormatter.ruRuLong.string(from: date)
        }
        
        return .init(text: task.text,
                     importance: importance,
                     dateText: dateText,
                     date: task.deadline,
                     deleteButtonText: "Удалить")
    }
}
