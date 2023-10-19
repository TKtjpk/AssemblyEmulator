//
//  TOMUITests.swift
//  TOMUITests
//
//  Created by Tomasz Kubicki on 17/10/2023.
//

import XCTest
@testable import TOM

final class TOMUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    override func setUp() {
        
        app.launch()
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
        //screenShot(app)
        let stepperUp = app.steppers["Stepper"].incrementArrows.element

        stepperUp.tap()
        stepperUp.tap()
        stepperUp.tap()
        let name = String(self.name)
        let incrementArrow = XCUIApplication().windows["Untitled"].steppers["Stepper"].children(matching: .incrementArrow).element
        incrementArrow.click()
        incrementArrow.click()
        incrementArrow.click()
        app.steppers["Stepper"].decrementArrows.element.tap()
        screenShot(app, name: name)
        testTakeScreenshots()
        app.buttons["Play"].tap()
        screenShot(app, name: name)
        testTakeScreenshots()
        app.buttons["Reset"].tap()
        screenShot(app, name: name)
        testTakeScreenshots()
        app.buttons["Play"].tap()
        screenShot(app, name: name)
        testTakeScreenshots()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func screenShot(_ app: XCUIApplication, name: String) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testTakeScreenshots() {

        // Take a screenshot of the current device's main screen.
        let mainScreenScreenshot = XCUIScreen.main.screenshot()
        
        // Take a screenshot of an app's first window.
        let app = XCUIApplication()
        app.launch()
        let windowScreenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: windowScreenshot)
        attachment.lifetime = .keepAlways
        add(attachment)

    }
}
