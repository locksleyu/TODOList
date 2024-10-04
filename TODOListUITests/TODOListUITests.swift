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
	
	func testAdd() throws {
		let app = XCUIApplication()
		app.launch()
		
		XCTAssert(app.staticTexts["TODO List Application Challenge"].exists)

		app.buttons["Start"].tap()

		XCTAssert(app.buttons["Back to home page"].waitForExistence(timeout: 3))
		
		let countBefore = app.buttons.matching(identifier: "ItemButton").count

		app.buttons["Add Item"].tap()
		
		XCTAssert(app.staticTexts["Add task"].waitForExistence(timeout: 3))
		
		XCTAssert(app.textViews["AddTaskTextField"].waitForExistence(timeout: 3))
		
		app.textViews["AddTaskTextField"].tap()

		app.textViews["AddTaskTextField"].typeText("myitem")
	
		app.buttons["Save"].tap()
		
		let countAfter = app.buttons.matching(identifier: "ItemButton").count

		displayElements()
		
		XCTAssert(app.buttons["myitem"].waitForExistence(timeout: 3))

		XCTAssert(countAfter == countBefore + 1)

		
	}

	func displayElements() {
		let app = XCUIApplication()

		print("text fields:")
		
		for item in app.textFields.allElementsBoundByIndex{
			print("=>" + item.label + "," + item.title + "," + item.identifier)
		}
		print("buttons:")

		for item in app.buttons.allElementsBoundByIndex{
			print("=>" + item.label + "," + item.title + "," + item.identifier)
		}
		print("static texts:")

		for item in app.staticTexts.allElementsBoundByIndex{
			print("=>" + item.label + "," + item.title + "," + item.identifier)
		}
		print("text views:")

		for item in app.textViews.allElementsBoundByIndex{
			print("=>" + item.label + "," + item.title + "," + item.identifier)
		}
		
		print("secure text fields:")

		for item in app.secureTextFields.allElementsBoundByIndex{
			print("=>" + item.label + "," + item.title + "," + item.identifier)
		}
		
	}
}
