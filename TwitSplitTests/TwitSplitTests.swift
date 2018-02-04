//
//  TwitSplitTests.swift
//  TwitSplitTests
//
//  Created by Mettamdaica on 1/30/18.
//  Copyright © 2018 Mettamdaica. All rights reserved.
//

import XCTest
@testable import TwitSplit

class TwitSplitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsMessageValid() {
        // case empty string
        let inputMessage = ""
        let result = MessageManager.isMessageValid(message: inputMessage)
        XCTAssertTrue(result == MessageValidation.invalidCharacter)
        
        let inputMessage2 = "              "
        let result2 = MessageManager.isMessageValid(message: inputMessage2)
        XCTAssertTrue(result2 == MessageValidation.invalidCharacter)
        
        // case message contains a span of non-whitespace characters longer than 20 characters
        let inputMessage3 = "This is the token : eyJhbGciOiJSUzI1NiIsImtpZCI6IlRuX0ZZblNyT2N1Wi1sZGZXOTdsWmRJMm9GNnEtd2w2REZsYV8yVnJMZHMifQ.eyJ2ZXIiOjEsImp0aSI6IkFULndfS0swcVhnS2Z4WExDYjVUbmlfTGpIOFBVNnZNQ2ZUUUNwUGZoalBtbzQiLCJpc3MiOiJodHRwczovL29wZXItamVwcGVzZW4ub2t0YXByZXZpZXcuY29tL29hdXRoMi9hdXNiaDdlcXBjYXBiOXZBbzBoNyIsImF1ZCI6Imh0dHBzOi8vZGVub3ByYXMwMWkuamVwcGVzZW4uY29tOjg0NDQvY3Jld01vYmlsZVNlcnZpY2VzIiwiaWF0IjoxNTAyMzM3MDc1LCJleHAiOjE1MDI0MjM0NzUsImNpZCI6Ijl6T09sS1hMQTJVeUVlc3NUMFdEIiwidWlkIjoiMDB1YmIxZXA1d0dQNHJOMzEwaDciLCJzY3AiOlsiYWRkcmVzcyIsImVtYWlsIiwib3BlbmlkIiwidHBzY2hrIiwicGhvbmUiLCJwcm9maWxlIl0sInN1YiI6ImpvaG5kb2VAZGV2bW9iaWxlLmNvbSIsImdyb3VwcyI6WyJPcGVyQ3VzdDEiLCJFdmVyeW9uZSJdLCJpc1Rwc"
        let result3 = MessageManager.isMessageValid(message: inputMessage3)
        XCTAssertTrue(result3 == MessageValidation.invalidLength)
        
        // case success
        let inputMessage4 = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let result4 = MessageManager.isMessageValid(message: inputMessage4)
        XCTAssertTrue(result4 == MessageValidation.valid)
    }
    
    func testSplitMessage() {
        // case input is less than 50
        let splitResult1 = MessageManager.splitMessage(inputMessage: "Hello world")
        XCTAssertTrue(splitResult1 == ["Hello world"])
        
        // case input is greater than 50
        let splitResult2 = MessageManager.splitMessage(inputMessage: "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.")
        XCTAssertTrue(splitResult2 == ["1/2 I can't believe Tweeter now supports chunking","2/2 my messages, so I don't have to do it myself."])
    }
    
}
