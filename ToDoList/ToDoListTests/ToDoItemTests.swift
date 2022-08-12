//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Igor Manakov on 30.07.2022.
//

import XCTest
@testable import ToDoList

class ToDoItemTests: XCTestCase {
    
//    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
    
//    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    
    func testToDoItem_canCreateInstance() {
        
        let partialInstance = ToDoItem(text: "Hello world",
                                       isCompleted: false,
                                       createdAt: Date())
        
        let fullInstance = ToDoItem(id: UUID(),
                                    text: "Hello world",
                                    importance: .important,
                                    deadline: Date(),
                                    isCompleted: true,
                                    createdAt: Date(),
                                    changedAt: Date())
        
        XCTAssertNotNil(partialInstance)
        XCTAssertNotNil(fullInstance)
    }
    
    func testToDoItem_canCreateJson() {
        
        let id = UUID()
        let text = "Hello world"
        let importance = Importance.basic
        let isCompleted = true
        let date = Date()
        
        let instance = ToDoItem(id: id,
                                text: text,
                                importance: importance,
                                deadline: nil,
                                isCompleted: true,
                                createdAt: date,
                                changedAt: nil)
            .json as? [String: AnyObject]
        
        XCTAssertEqual(instance?.count, 4)
        
        XCTAssertEqual(instance?["id"] as? String, id.uuidString)
        
        XCTAssertEqual(instance?["text"] as? String, text)
        
        XCTAssertNil(instance?["importance"])
        
        XCTAssertNil(instance?["deadline"])
        
        XCTAssertEqual(instance?["done"] as? Bool, isCompleted)
        
        XCTAssertEqual(instance?["created_at"] as? String, String(date.timeIntervalSince1970))
        
        XCTAssertNil(instance?["deadline"])
    }
    
    func testToDoItem_canParseJson() {
        
        var json: [String: Any] = [:]
        XCTAssertNil(ToDoItem.parse(json: json))
        
        json["id"] = "7A2A7CC7-8941-4489-9AF4-A1289442651E"
        XCTAssertNil(ToDoItem.parse(json: json))
        
        json["text"] = "Do first homework in Yandex"
        XCTAssertNil(ToDoItem.parse(json: json))
        
        json["done"] = false
        XCTAssertNil(ToDoItem.parse(json: json))
        
        json["created_at"] = "1659111472"
        XCTAssertNotNil(ToDoItem.parse(json: json))
        
        json["id"] = "7A2A7CC7-8941-4489-9AF4"
        XCTAssertNil(ToDoItem.parse(json: json))
        
        json["id"] = "7A2A7CC7-8941-4489-9AF4-A1289442651E"
        json["done"] = 0
        XCTAssertNil(ToDoItem.parse(json: json))
        
        json["done"] = false
        json["created_at"] = "january, 08"
        XCTAssertNil(ToDoItem.parse(json: json))
        
        json["created_at"] = "1659111472"
        json["importance"] = nil
        XCTAssertNotNil(ToDoItem.parse(json: json))
    }
}
