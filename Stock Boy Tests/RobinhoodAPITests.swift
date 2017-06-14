//
//  RobinhoodAPITests.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/22/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import XCTest

class RobinhoodAPITests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
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

//  func testRobinhoodAuth() {
//    let expect = expectation(description: "Auth call works")
//
//    DataManager.shared.fetchRobinhoodAuthWith { (data) in
//      print(data)
//      XCTAssertNotNil(data)
//      expect.fulfill()
//    }
//
//    waitForExpectations(timeout: 1) { error in
//      if let error = error {
//        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//      }
//    }
//  }
//
//  func testRobinhoodAccount() {
//    let expect = expectation(description: "Account call works")
//
//    DataManager.shared.fetchRobinhoodAuthWith { (auth) in
//      DataManager.shared.fetchRobinhoodAccountWith(auth: auth) { (data) in
//        XCTAssertNotNil(data)
//        expect.fulfill()
//      }
//    }
//
//    waitForExpectations(timeout: 1) { error in
//      if let error = error {
//        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//      }
//    }
//  }

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

//  func testRobinhoodWatchlist() {
//    let expect = expectation(description: "Watchlist call works")
//
//    DataManager.shared.fetchRobinhoodAuthWith { (auth) in
//      DataManager.shared.fetchRobinhoodDefaultWatchlistWith(auth: auth, completion: { (data) in
//        XCTAssertNotNil(data)
//        expect.fulfill()
//      })
//    }
//
//    waitForExpectations(timeout: 1) { error in
//      if let error = error {
//        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//      }
//    }
//  }
//
//  func testRobinhoodWatchlistQuotes() {
//    let expect = expectation(description: "Watchlist quotes call works")
//
//    DataManager.shared.fetchRobinhoodAuthWith { (auth) in
//      DataManager.shared.fetchRobinhoodDefaultWatchlistWith(auth: auth, completion: { (watchlist) in
//        DataManager.shared.fetchRobinhoodInstrumentsWith(watchlist: watchlist.results, completion: { (instruments) in
//          DataManager.shared.fetchRobinhoodQuotesWith(instruments: instruments, completion: { (quotes) in
//            print(quotes)
//            XCTAssertNotNil(quotes)
//            expect.fulfill()
//          })
//        })
//      })
//    }
//
//    waitForExpectations(timeout: 1) { error in
//      if let error = error {
//        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//      }
//    }
//  }

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

//  func testRobinhoodHistoricals() {
//    let expect = expectation(description: "Historicals call works")
//
//    DataManager.shared.fetchRobinhoodHistoricalsWith(symbol: "URRE") { historicals in
//      print(historicals)
//      XCTAssertNotNil(historicals)
//      expect.fulfill()
//    }
//
//    waitForExpectations(timeout: 1) { error in
//      if let error = error {
//        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//      }
//    }
//  }
//
//  func testRobinhoodOrders() {
//    let expect = expectation(description: "Orders call works")
//    DataManager.shared.fetchRobinhoodQuoteWith(symbol: "EDIT") { (quote) in
//      DataManager.shared.fetchRobinhoodAuthWith { (auth) in
//        DataManager.shared.submitRobinhoodBuyWith(auth: auth, quote: quote, price: 0.1, completion: { (order) in
//          print(order)
//          DataManager.shared.cancelRobinhoodOrderWith(auth: auth, order: order)
//          XCTAssertNotNil(order)
//          expect.fulfill()
//        })
//      }
//    }
//
//    waitForExpectations(timeout: 1) { error in
//      if let error = error {
//        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//      }
//    }
//  }
//
//  func testRobinhoodOrdersFetch() {
//    let expect = expectation(description: "Orders fetch call works")
//    DataManager.shared.fetchRobinhoodAuthWith { (auth) in
//      DataManager.shared.fetchRobinhoodOrdersWith(auth: auth, completion: { (orders) in
//        print(orders)
//        XCTAssertNotNil(orders)
//        expect.fulfill()
//      })
//    }
//
//    waitForExpectations(timeout: 1) { error in
//      if let error = error {
//        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//      }
//    }
//  }

}
