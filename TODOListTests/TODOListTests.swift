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
    }

    override func tearDownWithError() throws {
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
	
	func testRemoteItem() throws {
		let item1 = TodoItem(userId: 1, id: 1, title: "item 1", completed: false)
		let item2 = TodoItem.createAddItem()
		
		var todoItems: [TodoItem] = [item1, item2];
		
		TodoItemsLogic.removeItemWithID(&todoItems, id: item2.id)
		
		XCTAssert(todoItems.count == 1)
		XCTAssert(todoItems[0].title == "item 1")
		
		TodoItemsLogic.removeItemWithID(&todoItems, id: item1.id)

		XCTAssert(todoItems.count == 0)
	}
	
	func testUpdateCompleteState() throws {
		let item1 = TodoItem(userId: 1, id: 1, title: "item 1", completed: false)
		let item2 = TodoItem.createAddItem()
		
		var todoItems: [TodoItem] = [item1, item2];

		TodoItemsLogic.updateCompleteStateOfItem(&todoItems, item: item1)
		
		XCTAssert(todoItems.count == 2)
		XCTAssert(todoItems[0].completed == true)
		
		TodoItemsLogic.updateCompleteStateOfItem(&todoItems, item: item1)
		
		XCTAssert(todoItems[0].completed == false)
	}
	func testGetNextId() throws {
		let item1 = TodoItem(userId: 1, id: 1, title: "item 1", completed: false)
		let item2 = TodoItem(userId: 1, id: 100, title: "item 2", completed: false)
		let item3 = TodoItem.createAddItem()
		
		var todoItems: [TodoItem] = [item1, item2, item3];

		let nextId = TodoItemsLogic.getNextId(todoItems)
		
		XCTAssert(nextId == 101)
	}
/*
	static func updateCompleteStateOfItem(_ todoItems: inout [TodoItem], item: TodoItem)
	{
		if let index = todoItems.firstIndex(of: item) {
			todoItems[index].completed = !todoItems[index].completed;
		}
	}
	 
	static func getNextId(_ todoItems: [TodoItem]) -> Int {
		let nextId = (todoItems.map {$0.id}.max() ?? 1000) + 1
		return nextId
	}
	 */
	
}
