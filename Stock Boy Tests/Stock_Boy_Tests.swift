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
    var string = stringByReplacingParameter(string: "hey${oh}", parameter: "no")
    XCTAssertEqual(string, "heyno")

    string = "123.3213202".toUSD()
    XCTAssertEqual(string, "$123.32")

    string = "1.037294".toPercentChange()
    XCTAssertEqual(string, "+3.7%")

    string = "0.88231".toPercentChange()
    XCTAssertEqual(string, "-11.7%")

    string = "1234".toVolume()
    XCTAssertEqual(string, "1.234K")

    string = "123.421421".trimDecimals()
    XCTAssertEqual(string, "123")
  }

  func testURL() {
    var url = chartURLFor(symbol: "URRE")
    XCTAssertNotNil(url)

    url = chartURLFor(symbol: "dog")
    XCTAssertNotNil(url)
  }
  
}
