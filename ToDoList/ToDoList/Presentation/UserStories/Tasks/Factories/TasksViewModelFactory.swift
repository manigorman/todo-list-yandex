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
        let incompletedTaskCells = tasks.filter { $0.isCompleted == false } .map { makeCellViewModel(task: $0) }
        
        return .init(headerViewModel: makeHeaderViewModel(count: tasks.count - incompletedTaskCells.count,
                                                          flag: showingCompleted),
              tasks: showingCompleted
              ? tasks.map { makeCellViewModel(task: $0) }
              : incompletedTaskCells)
    }
    
    private func makeHeaderViewModel(count: Int, flag: Bool) -> HeaderView.Model {
        return .init(titleText: "Выполнено — \(count)",
                     buttonTitle: flag ? "Скрыть" : "Показать")
    }
    
    private func makeCellViewModel(task: ToDoItem) -> TaskCell.Model {
                
        var radioImage = UIImage()
        let descriptionAttachment = NSTextAttachment()
        var descriptionString = ""
        let descriptionText = NSMutableAttributedString(string: "")
        let dateAttachment = NSTextAttachment()
        var dateText: NSMutableAttributedString! = nil
        
        switch task.importance {
        case .low:
            descriptionAttachment.image = SFSymbols.lowImage
            descriptionString = " \(task.text)"
            descriptionText.append(NSAttributedString(attachment: descriptionAttachment))
            
        case .important:
            descriptionAttachment.image = SFSymbols.importantImage
            descriptionString = " \(task.text)"
            descriptionText.append(NSAttributedString(attachment: descriptionAttachment))
        case .basic:
            descriptionString = task.text
        }
        
        if task.isCompleted {
            descriptionText.append(NSAttributedString(string: descriptionString,
                                                      attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]))
            radioImage = SFSymbols.checkmarkImage
        } else {
            descriptionText.append(NSAttributedString(string: descriptionString))
            radioImage = task.importance == .important ? SFSymbols.circleFilledImage : SFSymbols.circleImage
        }
        
        if let deadline = task.deadline {
            dateText = NSMutableAttributedString(string: "")
            dateAttachment.image = SFSymbols.calendarImage
            dateText.append(NSAttributedString(attachment: dateAttachment))
            dateText.append(NSAttributedString(string: " \(DateFormatter.ruRuLong.string(from: deadline))"))
        }
        
        return .init(radioImage: radioImage,
                     titleText: descriptionText,
                     subtitleText: dateText)
    }
}
