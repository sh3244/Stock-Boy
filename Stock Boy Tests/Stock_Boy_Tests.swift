//
//  Stock_Boy_Tests.swift
//  Stock Boy Tests
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import XCTest

class Stock_Boy_Tests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testRegex() {
    let string = stringByReplacingParameter(string: "hey${oh}", parameter: "no")
    XCTAssertEqual(string, "heyno")
  }

  func testURL() {
    var url = chartURLFor(symbol: "URRE")
    XCTAssertNotNil(url)

    url = chartURLFor(symbol: "dog")
    XCTAssertNotNil(url)
  }

  func testRobinhoodQuote() {
    let expect = expectation(description: "Quote call works")
    DataManager.shared.fetchRobinhoodQuoteWith(symbol: "URRE") { (data) in
      print(data)
      XCTAssertNotNil(data)
      expect.fulfill()
    }

    waitForExpectations(timeout: 1) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }

  func testRobinhoodAuth() {
    let expect = expectation(description: "Auth call works")

    DataManager.shared.fetchRobinhoodAuthWith { (data) in
      print(data)
      XCTAssertNotNil(data)
      expect.fulfill()
    }

    waitForExpectations(timeout: 1) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }

  func testRobinhoodInstruments() {
    let expect = expectation(description: "Instruments call works")

    DataManager.shared.fetchRobinhoodInstruments { (data) in
      print(data)
      XCTAssertNotNil(data)
      expect.fulfill()
    }

    waitForExpectations(timeout: 1) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }

  func testRobinhoodFundamentals() {
    let expect = expectation(description: "Fundamentals call works")

    DataManager.shared.fetchRobinhoodFundamentalsWith(symbol: "MSFT") { (data) in
      print(data)
      XCTAssertNotNil(data)
      expect.fulfill()
    }

    waitForExpectations(timeout: 1) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }

}
