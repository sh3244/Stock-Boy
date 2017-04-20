//
//  ChartViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class ChartViewController: ViewController, UISearchBarDelegate {
  var imageView: UIImageView = UIImageView()
  var searchBar: SearchBar = SearchBar()
  var scrollView: UIScrollView = UIScrollView()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Chart"
    searchBar.delegate = self
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewDidLayoutSubviews() {
    loadChartFor(symbol: "URRE")
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([searchBar, scrollView])
    view.layout(
      0,
      |searchBar|,
      |scrollView|,
      0
    )
    scrollView.sv(imageView)
    scrollView.layout(
      0,
      |imageView|,
      0
    )
    imageView.contentMode = .scaleAspectFit
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    if let text = searchBar.text {
      loadChartFor(symbol: text)
    }
  }

  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    return true
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

  }

  func loadChartFor(symbol: String) {
    guard let url = chartURLFor(symbol: symbol) else {
      return
    }

    let data = try! Data(contentsOf: url)
    if !data.isEmpty {
      DispatchQueue.main.async {
        self.imageView.image = UIImage(data: data)
      }
    }
  }

}
