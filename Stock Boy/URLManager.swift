//
//  URLManager.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import Regex

//// Use `Regex.init(_:)` to build a regex from a static pattern
//
//let greeting = Regex("hello (world|universe)")
//
//// Use `Regex.init(string:)` to construct a regex from dynamic data, and
//// gracefully handle invalid input
//
//var validations: [String: Regex]
//
//for (name, pattern) in config.loadValidations() {
//  do {
//    validations[name] = try Regex(string: pattern)
//  } catch {
//    print("error building validation \(name): \(error)")
//  }
//}
//Match:
//
//  if greeting.matches("hello universe!") {
//  print("wow, you're friendly!")
//}
//Pattern match:
//
//switch someTextFromTheInternet {
//case Regex("DROP DATABASE (.+)"):
//// TODO: patch security hole
//default:
//  break
//}
//Capture:
//
//let greeting = Regex("hello (world|universe|swift)")
//
//if let subject = greeting.match("hello swift")?.captures[0] {
//  print("ohai \(subject)")
//}
//Find and replace:
//
//"hello world".replacingFirstMatching("h(ello) (\\w+)", with: "H$1, $2!")
//// "Hello, world!"
//Accessing the last match:
//
//switch text {
//case Regex("hello (\\w+)"):
//  if let friend = Regex.lastMatch?.captures[0] {
//    print("lovely to meet you, \(friend)!")
//  }
//case Regex("goodbye (\\w+)"):
//  if let traitor = Regex.lastMatch?.captures[0] {
//    print("so sorry to see you go, \(traitor)!")
//  }
//default:
//  break
//}
//Options:
//
//let totallyUniqueExamples = Regex("^(hello|foo).*$", options: [.IgnoreCase, .AnchorsMatchLines])
//let multilineText = "hello world\ngoodbye world\nFOOBAR\n"
//let matchingLines = totallyUniqueExamples.allMatches(multilineText).map { $0.matchedString }
//// ["hello world", "FOOBAR"]

func chartURLFor(symbol: String) -> URL? {
  let template = "http://stockcharts.com/c-sc/sc?s=${symbol}&p=D&b=5&g=0&i=0&r=1492555502079"
  var url: URL? = URL(string: "")
  url = URL(string: stringByReplacingParameter(string: template, parameter: symbol))
  return url ?? nil
}

func stringByReplacingParameter(string: String, parameter: String) -> String {
  return string.replacingFirstMatching("\\$\\{[a-zA-Z]+\\}", with: parameter)
}

