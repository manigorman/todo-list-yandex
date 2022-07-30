//
//  FileCacheTests.swift
//  ToDoListTests
//
//  Created by Igor Manakov on 30.07.2022.
//

import XCTest
@testable import ToDoList

class FileCacheTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testToDoItem_canLoadJson() {
        
        let fileName = "Test.json"
        let fileURL = FileManager.cachesDirectoryURL.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try! FileManager.default.removeItem(atPath: fileURL.path)
        }
        
        XCTAssertThrowsError(try FileCache.shared.loadJSONItems(from: fileName))
        
        var str = ""
        try! str.write(to: fileURL, atomically: true, encoding: .utf8)
        XCTAssertThrowsError(try FileCache.shared.loadJSONItems(from: fileName))
        
        str = "[]"
        try! str.write(to: fileURL, atomically: true, encoding: .utf8)
        XCTAssertThrowsError(try FileCache.shared.loadJSONItems(from: fileName))
        
        str = """
        {
        "list": []
        }
        """
        try! str.write(to: fileURL, atomically: true, encoding: .utf8)
        XCTAssertNoThrow(try FileCache.shared.loadJSONItems(from: fileName))
        
        str = """
        {
        "list": [
          {
            "id": "7A2A7CC7-8941-4489-9AF4-A1289442651E",
            "text": "Do first homework in Yandex",
            "importance": "important",
            "deadline": "1659273203",
            "done": false,
            "created_at": "1659111472",
            "changed_at": "1659114472"
          },
          {
            "id": "9224518d-5821-43e2-87b2-3a74259f76a8",
            "text": "Do second homework in Yandex",
            "done": false,
            "created_at": "1659111472",
          }
        ]
        }
        """
        try! str.write(to: fileURL, atomically: true, encoding: .utf8)
        XCTAssertNoThrow(try FileCache.shared.loadJSONItems(from: fileName))
    }
    
    func testToDoItem_canSaveJson() {
        XCTAssertNoThrow(try FileCache.shared.saveJSONItems(to: "Test.json"))
    }
    
//    func testToDoItem_canAddNewItem() {
//        FileCache.shared.addNewItem()
//    }
    
    func testToDoItem_canRemoveItem() {
        let fileName = "Test.json"
        let fileURL = FileManager.cachesDirectoryURL.appendingPathComponent(fileName)
        
        let str = """
        {
        "list": [
          {
            "id": "7A2A7CC7-8941-4489-9AF4-A1289442651E",
            "text": "Do first homework in Yandex",
            "importance": "important",
            "deadline": "1659273203",
            "done": false,
            "created_at": "1659111472",
            "changed_at": "1659114472"
          }
        ]
        }
        """
        try! str.write(to: fileURL, atomically: true, encoding: .utf8)
        
        try! FileCache.shared.loadJSONItems(from: fileName)
        XCTAssertNil(FileCache.shared.removeItem(with: UUID(uuidString: "7A2A7CC7-8941-4489-9AF4-A1289442651A")!))
        XCTAssertNotNil(FileCache.shared.removeItem(with: UUID(uuidString: "7A2A7CC7-8941-4489-9AF4-A1289442651E")!))
    }
}
