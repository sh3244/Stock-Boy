//
//  ChartViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class ChartViewController: ViewController, UIWebViewDelegate, UISearchBarDelegate {
//  var imageView: UIImageView = UIImageView()
  var searchBar: SearchBar = SearchBar()
  var webView: UIWebView = UIWebView()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Chart"

    webView.delegate = self
    searchBar.delegate = self
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([searchBar, webView])
    view.layout(
      0,
      |searchBar|,
      |webView|,
      0
    )
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    if let text = searchBar.text {
      loadChartFor(Symbol: text)
    }
  }

  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    return true
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

  }

  func loadChartFor(Symbol: String) {
    guard let url = URL(string: "http://stockcharts.com/h-sc/ui?s=" + Symbol) else {
      return
    }
    let request = URLRequest(url: url)
    webView.loadRequest(request)
  }

}
