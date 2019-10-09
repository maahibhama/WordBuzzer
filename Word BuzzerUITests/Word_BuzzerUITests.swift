//
//  Word_BuzzerUITests.swift
//  Word BuzzerUITests
//
//  Created by Kuliza-310 on 09/10/19.
//  Copyright © 2019 Mahendra Bhama. All rights reserved.
//

import XCTest

class Word_BuzzerUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInterface() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        XCTAssert(app.navigationBars["Start Game"].exists)
        XCTAssert(app.staticTexts["Number of Words"].exists)
        XCTAssert(app.buttons["20 Words"].exists)
        XCTAssert(app.buttons["40 Words"].exists)
        XCTAssert(app.buttons["60 Words"].exists)
        XCTAssert(app.buttons["80 Words"].exists)
        XCTAssert(app.buttons["Start Game"].exists)
    }
    
    //Check Alert Before Choose Number of Words
    func testClickOnStartGameButton() {
        let app = XCUIApplication()
        app.buttons["Start Game"].tap()
        
        XCTAssert(app.alerts["Error"].buttons["Ok"].exists)
        app.alerts["Error"].buttons["Ok"].tap()
        
    }
    
    //check Button Click Selection
    func testClickOnWordButton() {
        let app = XCUIApplication()
        XCTAssertFalse(app.buttons["20 Words"].images[""].exists)
        XCTAssertFalse(app.buttons["40 Words"].images[""].exists)
        XCTAssertFalse(app.buttons["60 Words"].images[""].exists)
        XCTAssertFalse(app.buttons["80 Words"].images[""].exists)
        app.buttons["20 Words"].tap()
        app.buttons["40 Words"].tap()
        app.buttons["60 Words"].tap()
        app.buttons["80 Words"].tap()
    }
    
    func testSelectedWordToStartGame() {
        let app = XCUIApplication()
        app.buttons["20 Words"].tap()
        app.buttons["Start Game"].tap()
        XCTAssert(app.navigationBars["Game"].exists)
    }
    
    func testGameScreenComponent() {
        let app = XCUIApplication()
        app.buttons["20 Words"].tap()
        app.buttons["Start Game"].tap()
        
        //Navigation Value
        XCTAssert(app.navigationBars["Game"].exists)
        XCTAssert(app.navigationBars["Game"].buttons["Start Game"].exists)
        
        //Buzzer Button Disable
        XCTAssertFalse(app.buttons["firstPlayerButton"].isEnabled)
        XCTAssertFalse(app.buttons["secondPlayerButton"].isEnabled)
        XCTAssertFalse(app.buttons["thirdPlayerButton"].isEnabled)
        XCTAssertFalse(app.buttons["fourthPlayerButton"].isEnabled)
        
        //check Tapping
        app.buttons["firstPlayerButton"].tap()
        app.buttons["secondPlayerButton"].tap()
        app.buttons["thirdPlayerButton"].tap()
        app.buttons["fourthPlayerButton"].tap()
        
        XCTAssertFalse(app.buttons["firstPlayerButton"].isSelected)
        XCTAssertFalse(app.buttons["secondPlayerButton"].isSelected)
        XCTAssertFalse(app.buttons["thirdPlayerButton"].isSelected)
        XCTAssertFalse(app.buttons["fourthPlayerButton"].isSelected)
        
        //First Player Label
        XCTAssert(app.staticTexts["firstPlayerName"].exists)
        XCTAssert(app.staticTexts["firstPlayerScore"].exists)
        XCTAssertFalse(app.images["firstPlayerRWImage"].exists)
        XCTAssertFalse(app.images["firstPlayerPrize"].exists)
        
        //Second Player Label
        XCTAssert(app.staticTexts["secondPlayerName"].exists)
        XCTAssert(app.staticTexts["secondPlayerScore"].exists)
        XCTAssertFalse(app.images["secondPlayerRWImage"].exists)
        XCTAssertFalse(app.images["secondPlayerPrize"].exists)
        
        //Third Player Label
        XCTAssert(app.staticTexts["thirdPlayerName"].exists)
        XCTAssert(app.staticTexts["thirdPlayerScore"].exists)
        XCTAssertFalse(app.images["thirdPlayerRWImage"].exists)
        XCTAssertFalse(app.images["thirdPlayerPrize"].exists)
        
        //Fourth Player Label
        XCTAssert(app.staticTexts["fourthPlayerName"].exists)
        XCTAssert(app.staticTexts["fourthPlayerScore"].exists)
        XCTAssertFalse(app.images["fourthPlayerRWImage"].exists)
        XCTAssertFalse(app.images["fourthPlayerPrize"].exists)
        
        //check Number of word and start game button
        XCTAssert(app.staticTexts["numberOfWords"].exists)
        XCTAssert(app.buttons["Start Game"].exists)
        XCTAssertFalse(app.buttons["randomWordButton"].exists)
        XCTAssertFalse(app.staticTexts["mainWordLabel"].exists)
        XCTAssertFalse(app.buttons["quitGameButton"].exists)
        app.buttons["GameStartGameButton"].tap()
        XCTAssert(app.buttons["quitGameButton"].exists)
        XCTAssert(app.staticTexts["mainWordLabel"].exists)
    }
    
    func testGameInitialWorkFlow() {
        let app = XCUIApplication()
        app.buttons["20 Words"].tap()
        app.buttons["Start Game"].tap()
        
        let randomButton = app.buttons["randomWordButton"]
        let mainWordLabel = app.staticTexts["mainWordLabel"]
        
        let firstPlayerButton = app.buttons["firstPlayerButton"]
        let secondPlayerButton = app.buttons["secondPlayerButton"]
        let thirdPlayerButton = app.buttons["thirdPlayerButton"]
        let fourthPlayerButton = app.buttons["fourthPlayerButton"]
        
        let exists = NSPredicate(format: "exists == true")
        let isEnabled = NSPredicate(format: "isEnabled == true")
        
        expectation(for: exists, evaluatedWith: randomButton, handler: nil)
        expectation(for: exists, evaluatedWith: mainWordLabel, handler: nil)
        
        expectation(for: isEnabled, evaluatedWith: firstPlayerButton, handler: nil)
        expectation(for: isEnabled, evaluatedWith: secondPlayerButton, handler: nil)
        expectation(for: isEnabled, evaluatedWith: thirdPlayerButton, handler: nil)
        expectation(for: isEnabled, evaluatedWith: fourthPlayerButton, handler: nil)
        
        app.buttons["GameStartGameButton"].tap()
        waitForExpectations(timeout: 1.2, handler: nil)
        
        XCTAssert(randomButton.exists)
        XCTAssert(mainWordLabel.exists)
        
        XCTAssert(firstPlayerButton.isEnabled)
        XCTAssert(secondPlayerButton.isEnabled)
        XCTAssert(thirdPlayerButton.isEnabled)
        XCTAssert(fourthPlayerButton.isEnabled)
        
        firstPlayerButton.tap()
        secondPlayerButton.tap()
        thirdPlayerButton.tap()
        fourthPlayerButton.tap()
        
    }
    
}
