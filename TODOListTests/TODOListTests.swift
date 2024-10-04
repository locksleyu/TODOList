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
	
}
