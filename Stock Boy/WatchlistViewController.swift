//
//  WatchlistViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class WatchlistViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  var searchBar = SearchBar()
  var tableView = UITableView()
  var refreshControl = UIRefreshControl()

  var quotes: [Quote] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    title = "Robinhood Watchlist"

    searchBar.delegate = self

    tableView.register(QuoteCell.self, forCellReuseIdentifier: "quoteCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .black
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)

    view.sv([searchBar, tableView])
    refreshTable()
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.layout(
      0,
      |searchBar|,
      |tableView|,
      0
    )
  }

  func refreshTable() {
    DataManager.shared.fetchRobinhoodAuthWith { (auth) in
      DataManager.shared.fetchRobinhoodDefaultWatchlistWith(auth: auth, completion: { watchlist in
        DataManager.shared.fetchRobinhoodInstrumentsWith(watchlist: watchlist.results, completion: { (instruments) in
          DataManager.shared.fetchRobinhoodQuotesWith(instruments: instruments, completion: { (quotes) in
            self.quotes = quotes
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
          })
        })
      })
    }
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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = QuoteCell()

    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let quoteCell = cell as? QuoteCell{
      let quote = quotes[indexPath.row]
      quoteCell.symbol.text = quote.symbol
      quoteCell.price.text = quote.last_trade_price
      quoteCell.change.text = String(Double(quote.last_trade_price)! / Double(quote.adjusted_previous_close)!)
      if quote.last_trade_price > quote.adjusted_previous_close {
        quoteCell.apply(color: .green)
      } else {
        quoteCell.apply(color: .red)
      }
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

