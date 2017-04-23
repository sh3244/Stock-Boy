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

  func testRobinhoodWatchlist() {
    let expect = expectation(description: "Watchlist call works")

    DataManager.shared.fetchRobinhoodAuthWith { (auth) in
      DataManager.shared.fetchRobinhoodDefaultWatchlistWith(auth: auth, completion: { (data) in
        XCTAssertNotNil(data)
        expect.fulfill()
      })
    }

    waitForExpectations(timeout: 1) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }

  func testRobinhoodWatchlistQuotes() {
    let expect = expectation(description: "Watchlist quotes call works")

    DataManager.shared.fetchRobinhoodAuthWith { (auth) in
      DataManager.shared.fetchRobinhoodDefaultWatchlistWith(auth: auth, completion: { (watchlist) in
        DataManager.shared.fetchRobinhoodInstrumentsWith(watchlist: watchlist.results, completion: { (instruments) in
          DataManager.shared.fetchRobinhoodQuotesWith(instruments: instruments, completion: { (quotes) in
            print(quotes.count)
            XCTAssertNotNil(quotes)
            expect.fulfill()
          })
        })
      })
    }

    waitForExpectations(timeout: 5) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }

}
