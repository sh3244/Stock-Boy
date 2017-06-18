//
//  RobinhoodAPITests.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/22/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import XCTest

class RobinhoodAPITests: XCTestCase {

  func testRobinhoodQuote() {
    let expect = expectation(description: "Quote call works")
    DataManager.shared.fetchRobinhoodQuoteWith(symbol: "URRE") { (data) in
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
      XCTAssertNotNil(data)
      expect.fulfill()
    }

    waitForExpectations(timeout: 1) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }

  func testRobinhoodQuotesMultiple() {
    let expect = expectation(description: "Watchlist quotes call works")

    DataManager.shared.fetchRobinhoodQuotesWith(symbols: ["MSFT", "URRE"]) { (quotes) in
      print(quotes)
      XCTAssertNotNil(quotes)
      expect.fulfill()
    }

    waitForExpectations(timeout: 1) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }
}
