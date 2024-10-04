//
//  TODOListTests.swift
//  TODOListTests
//
//  Created by Jeffrey Wisgo on 10/1/24.
//

import XCTest
@testable import TODOList

final class TODOListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	// In this test we will avoid doing much validation on the values since there is no guarantee they will not change later
	// and we don't want a test to fail since someone changed the backend. So we will just do a minimum of checks to make sure
	// we got some data.
	func testFetchRemoteData() throws {
		let expectation = XCTestExpectation(description: "fetch")
		
		TodoItemsLogic.fetchRemoteDataFromNetwork { todoItems, error in
			guard (error == nil) else {
				XCTFail("error is non nil")
				return
			}
			if let todoItems = todoItems {
				XCTAssert(todoItems.count >= 1)
				expectation.fulfill()
			}
			else {
				XCTFail("items is nil")
			}
		}
		
		wait(for: [expectation], timeout: 30.0)
	}
	func testItemEquality() throws {
		let item1 = TodoItem(userId: 1, id: 1, title: "item 1", completed: false)
		let item2 = TodoItem(userId: 1, id: 1, title: "item 1", completed: false)
		let item3 = TodoItem(userId: 1, id: 2, title: "item 3", completed: false)
		let item4 = TodoItem(userId: 2, id: 1, title: "item 1", completed: false)
		let item5 = TodoItem(userId: 1, id: 2, title: "item 1", completed: false)
		let item6 = TodoItem(userId: 1, id: 1, title: "item 1", completed: true)
		
		XCTAssert(item1 == item2)
		XCTAssert(item1 != item3)
		XCTAssert(item1 != item4)
		XCTAssert(item1 != item5)
		XCTAssert(item1 != item6)
	}
	func testSpecialItemLogic() throws {
		let item1 = TodoItem(userId: 1, id: 1, title: "item 1", completed: false)
		let item2 = TodoItem.createAddItem()
		
		XCTAssert(item1.isRegularItem())
		XCTAssertFalse(item1.isAddItem())
		
		XCTAssert(item2.isAddItem())
		XCTAssertFalse(item2.isRegularItem())
		
		// sanity check to make sure values were properly set
		
		XCTAssert(item1.userId == 1)
		XCTAssert(item1.id == 1)
		XCTAssert(item1.title == "item 1")
		XCTAssert(item1.completed == false)
	}
}
