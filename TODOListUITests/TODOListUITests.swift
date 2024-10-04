//
//  TODOListUITests.swift
//  TODOListUITests
//
//  Created by Jeffrey Wisgo on 10/1/24.
//

import XCTest

final class TODOListUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	/*
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
*/
	
	func testBasicNavigation() throws {
		let app = XCUIApplication()
		app.launch()
		
		XCTAssert(app.staticTexts["TODO List Application Challenge"].exists)

		app.buttons["Start"].tap()

		app.buttons["Back to home page"].tap()

		XCTAssert(app.buttons["Start"].waitForExistence(timeout: 3))
	}
	
	func testAddDelete() throws {
		let app = XCUIApplication()
		app.launch()
		
		XCTAssert(app.staticTexts["TODO List Application Challenge"].exists)

		app.buttons["Start"].tap()

		XCTAssert(app.buttons["Back to home page"].waitForExistence(timeout: 3))
		//let currentCount =
		
		app.buttons["Add Item"].tap()
		
		XCTAssert(app.staticTexts["Add task"].waitForExistence(timeout: 3)) 

		print("here1:")
		
		for item in app.textFields.allElementsBoundByIndex{
			print(item.label)
		}
		print("here2:")

		for item in app.buttons.allElementsBoundByIndex{
			print(item.label)
		}
		print("here3:")

		for item in app.staticTexts.allElementsBoundByIndex{
			print(item.label)
		}
		
		if (app.textFields["Add task details here"].exists) {
			print("tap1")
			app.textFields["Add task details here"].tap()
		}
		
		if (app.textFields["Add task details here"].exists) {
			print("tap2")
			app.textFields["Add task details here"].tap()
		}
		
		XCTAssert(app.textFields["AddTaskTextField"].waitForExistence(timeout: 3))

		XCTAssert(app.textFields["AddTaskTextField"].waitForExistence(timeout: 3))
		XCTAssert(app.textFields["Add task details here"].waitForExistence(timeout: 3))

		
		
		app.textFields["Add task details here"].typeText("new item!")
		
	
	}

}
