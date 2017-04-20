//
//  QuoteViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class QuoteViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  var searchBar = UISearchBar()
  var tableView = UITableView()
  var refreshControl = UIRefreshControl()

  var quotes: [Quote] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    title = "Quote"

    searchBar.delegate = self

    tableView.register(QuoteCell.self, forCellReuseIdentifier: "quoteCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .black
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([searchBar, tableView])
    view.layout(
      0,
      |searchBar|,
      |tableView|,
      0
    )
  }

  func refreshTable() {
//    DataManager.shared.update(quotes: quotes)
    tableView.reloadData()
    refreshControl.endRefreshing()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    if let text = searchBar.text?.uppercased() {
      DataManager.shared.fetchRobinhoodQuoteWith(symbol: text, completion: { (quote) in
        self.quotes.append(quote)
        self.tableView.reloadData()
      })
    }
  }

  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    return true
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    
  }


  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = QuoteCell()

    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let quoteCell = cell as? QuoteCell{
      quoteCell.symbol.text = quotes[indexPath.row].symbol
      quoteCell.price.text = quotes[indexPath.row].last_trade_price
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return QuoteCell.heightValue
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return quotes.count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}

