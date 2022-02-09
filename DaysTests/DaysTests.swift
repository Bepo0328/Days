//
//  DaysTests.swift
//  DaysTests
//
//  Created by 전윤현 on 2022/02/09.
//

import XCTest
@testable import Days

class DaysTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLocalStorage() {
        let storage: EventStorage = LocalEventStorage(with: UserDefaults(suiteName: "test")!)
        
        storage.clear()
        
        XCTAssertTrue(storage.list().isEmpty)
        
        let firstDate = Date()
        let first = Event(title: "first", icon: 1, date: firstDate)
        
        storage.add(first)
        
        XCTAssertTrue(storage.list().count == 1)
        
        let fetchedFirst = storage.list()[0]
        XCTAssertTrue(fetchedFirst == first)
        XCTAssertTrue(fetchedFirst.title == first.title)
        
        let secondDate = Date()
        let second = Event(title: "second", icon: 2, date: secondDate)
        
        storage.add(second)
        
        XCTAssertTrue(storage.list().count == 2)
        
        storage.delete(first)
        
        XCTAssertTrue(storage.list().count == 1)
        
        let fetchedSecond = storage.list()[0]
        
        XCTAssertTrue(fetchedSecond == second)
        
        storage.delete(second)
        
        XCTAssertTrue(storage.list().isEmpty)
    }
}
