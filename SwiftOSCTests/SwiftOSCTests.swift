//
//  SwiftOSCTests.swift
//  SwiftOSCTests
//
//  Created by Devin Roth on 7/14/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import XCTest
import SwiftOSC

class SwiftOSCTests: XCTestCase {

    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var client = OSCClient(address: "localhost", port: 8080)
        var server = OSCServer(address: "", port: 8080)
        server.start()
        var message = OSCMessage(OSCAddressPattern("/"))
        client.send(message)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
