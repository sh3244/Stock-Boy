//
//  Stock_Boy_Tests.swift
//  Stock Boy Tests
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import XCTest
import Just

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

    url = chartURLFor(symbol: "")
    XCTAssertNotNil(url)

    url = chartURLFor(symbol: "~")
    XCTAssertNotNil(url)
  }

  func testModels() {

  }

}
