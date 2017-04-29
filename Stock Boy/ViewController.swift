//
//  ViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate {
  var selected: [IndexPath] = []

  var searchBlock: ((String) -> Void) = {string in }

  var tap: UITapGestureRecognizer = UITapGestureRecognizer()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UISettings.backgroundColor
    tap = UITapGestureRecognizer(target: self, action: #selector(resign))
  }

  func resign() {
    for subview in view.subviews {
      subview.resignFirstResponder()
    }
    view.removeGestureRecognizer(tap)
  }

  // MARK: UITextFieldDelegate

  func textFieldDidBeginEditing(_ textField: UITextField) {
    view.addGestureRecognizer(tap)
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    resign()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    resign()
    return true
  }

  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    return true
  }

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    return true
  }

  // MARK: UISearchBarDelegate

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    view.addGestureRecognizer(tap)
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    resign()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    resign()
    if let text = searchBar.text {
      searchBlock(text)
    }
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    resign()
  }

  func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    return true
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText == "" {
      resign()
    }
    else {
      searchBar.showsCancelButton = true
    }
  }

  // MARK: Scroll View + Transitions

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    TransitionManager.shared.shouldAnimate = false
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    TransitionManager.shared.shouldAnimate = true
  }

  // MARK: Controller Features

  func revealView(_ view: UIView) {
    if view.alpha == 0 {
      UIView.animate(withDuration: 1) {
        view.alpha = 1
      }
    }
  }
}
