//
//  TasksViewModelFactory.swift
//  ToDoList
//
//  Created by Igor Manakov on 22.08.2022.
//

import Foundation
import UIKit

final class TasksViewModelFactory {
    func makeModel(tasks: [ToDoItem], showingCompleted: Bool) -> TasksViewController.Model {
        let incompletedTaskCells = tasks.filter { $0.isCompleted == false }
        
        return .init(headerViewModel: makeHeaderViewModel(count: tasks.count - incompletedTaskCells.count,
                                                          flag: showingCompleted),
              tasks: showingCompleted
              ? tasks
              : incompletedTaskCells)
    }
    
    private func makeHeaderViewModel(count: Int, flag: Bool) -> HeaderView.Model {
        return .init(titleText: "Выполнено — \(count)",
                     buttonTitle: flag ? "Скрыть" : "Показать")
    }
}
