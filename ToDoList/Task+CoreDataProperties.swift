//
//  Task+CoreDataProperties.swift
//  ToDoList
//
//  Created by Igor Manakov on 28.08.2022.
//
//

import Foundation
import CoreData

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var changedAt: Date?
    @NSManaged public var importance: String?
    @NSManaged public var isCompleted: Bool

    func snapshot(_ item: ToDoItem, task: Task) {
        task.id = item.id
        task.text = item.text
        task.importance = item.importance.rawValue
        task.isCompleted = item.isCompleted
        task.deadline = item.deadline
        task.createdAt = item.createdAt
        task.changedAt = item.changedAt
    }
}

extension Task: Identifiable {

}
