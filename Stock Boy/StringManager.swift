//
//  StringManager.swift
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
  let template = "http://stockcharts.com/c-sc/sc?s=${symbol}&p=C&b=5&g=5&i=0"
  var url: URL? = URL(string: "")
  url = URL(string: stringByReplacingParameter(string: template, parameter: symbol))
  return url ?? nil
}

func stringByReplacingParameter(string: String, parameter: String) -> String {
  return string.replacingFirstMatching("\\$\\{[a-zA-Z]+\\}", with: parameter)
}

// MARK: Form Validation
extension String {
  func validateName() -> Bool {
    if self.characters.count > 3 {
      return true
    }
    return false
  }

  func validateEmail() -> Bool {
    let regex = Regex("[0-9a-zA-Z]+\\@[0-9a-zA-Z]+\\.[0-9a-zA-Z]+")
    return regex.matches(self)
  }

  func validatePassword() -> Bool {
    if self.characters.count > 3 {
      return true
    }
    return false
  }
}

// MARK: Money
extension String {

  func floatValueLow() -> Float {
    if let value = Float(self) {
      return value
    }
    return 0.0
  }

  func floatValueHigh() -> Float {
    if let value = Float(self) {
      return value
    }
    return 10000.0
  }

  func intValue() -> Int {
    if let value = Int(self) {
      return value
    }
    return 1
  }

  func tackZeros() -> String {
    return self + "00"
  }

  func toUSD() -> String {
    return self.tackZeros().replacingFirstMatching("([0-9]+)(.)?([0-9])?([0-9])?.*", with: "$1$2$3$4").trimTrailingZeros()
  }

  func toPercentChange() -> String {
    if let value = Double(self) {
      if value > 1 && value < 2 {
        return "+" + self.replacingFirstMatching("^[1]\\.([0-9]{2})([0-9]{1}).*", with: "$1.$2%").trimLeadingZeros()
      }
      else if value > 0 && value < 1 {
        let adjusted = String(1 - value)
        return "-" + adjusted.replacingFirstMatching("^.{0,4}\\.([0-9]{2})([0-9]{1}).*", with: "$1.$2%").trimLeadingZeros()
      }
    }
    return "0.00%"
  }

  func toVolume() -> String {
    let trimmed = self.replacingFirstMatching("^([0-9]+)\\..*", with: "$1")
    if trimmed.characters.count > 9 {
      return trimmed.replacingFirstMatching("([0-9]{3})[0-9]{6}$", with: ".$1").trimTrailingZeros() + "B"
    } else if trimmed.characters.count > 6 {
      return trimmed.replacingFirstMatching("([0-9]{3})[0-9]{3}$", with: ".$1").trimTrailingZeros() + "M"
    } else if trimmed.characters.count > 3 {
      return trimmed.replacingFirstMatching("([0-9]{3})$", with: ".$1").trimTrailingZeros() + "K"
    }
    return trimmed
  }

  func trimLeadingZeros() -> String {
    return self.replacingFirstMatching("^0{0,4}([0-9]\\.)", with: "$1")
  }

  func trimTrailingZeros() -> String {
    if self.replacingFirstMatching("^([^0\\.]+)\\.?0+$", with: "$1") == "$" {
      return "$0"
    }
    return self.replacingFirstMatching("^([^0\\.]+)\\.?0+$", with: "$1")
  }

  func trimDecimals() -> String {
    return self.replacingFirstMatching("^([0-9]+)\\..*$", with: "$1")
  }

  func dividedBy(_ string: String) -> String {
    if let first = Double(self), let second = Double(string) {
      return String(first / second)
    }
    return ""
  }

  func multipliedBy(_ string: String) -> String {
    if let first = Double(self), let second = Double(string) {
      return String(first * second)
    }
    return ""
  }

  func isGreaterThan(_ string: String) -> Bool {
    if let first = Double(self), let second = Double(string) {
      return first > second
    }
    return false
  }

  func isLessThan(_ string: String) -> Bool {
    if let first = Double(self), let second = Double(string) {
      return first < second
    }
    return false
  }
}
