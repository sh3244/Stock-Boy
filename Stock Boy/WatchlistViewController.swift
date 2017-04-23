//
//  WatchlistViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia

class WatchlistViewController: ViewController, UISearchBarDelegate {
  var searchBar = SearchBar()
  var tableView = UITableView()
  var refreshControl = UIRefreshControl()

  var quotes: [Quote] = []

  var selected: [IndexPath] = []

  override func viewDidLoad() {
    super.viewDidLoad()
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
}

extension WatchlistViewController : UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    if selected.contains(indexPath) {
      if let index = selected.index(of: indexPath) {
        selected.remove(at: index)

      }
    }
    else {
      selected.append(indexPath)
    }
    tableView.beginUpdates()
    tableView.endUpdates()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = QuoteCell()

    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let quoteCell = cell as? QuoteCell {
      let quote = quotes[indexPath.row]
      quoteCell.symbol.text = quote.symbol
      quoteCell.price.text = quote.last_trade_price.toUSD()
      quoteCell.change.text = String(Double(quote.last_trade_price)! / Double(quote.adjusted_previous_close)!).toPercentChange()
      if quote.last_trade_price > quote.adjusted_previous_close {
        quoteCell.apply(color: .green)
      } else if quote.last_trade_price < quote.adjusted_previous_close {
        quoteCell.apply(color: .red)
      } else {
        quoteCell.apply(color: .gray)
      }
      DataManager.shared.fetchRobinhoodInstrumentWith(url: quote.instrument, completion: { (instrument) in
        quoteCell.name.text = instrument.name
      })
      DataManager.shared.fetchRobinhoodFundamentalsWith(symbol: quote.symbol, completion: { (fundamentals) in
        quoteCell.open.text = "Open: " + fundamentals.open.toUSD()
        quoteCell.high.text = "High: " + fundamentals.high.toUSD()
        quoteCell.low.text = "Low: " + fundamentals.low.toUSD()
        quoteCell.volume.text = "Vol: " + fundamentals.volume.toVolume()
        quoteCell.average_volume.text = "Average Vol: " + fundamentals.average_volume.toVolume()
        quoteCell.high_52_weeks.text = "52 Week High: " + fundamentals.high_52_weeks.toUSD()
        quoteCell.low_52_weeks.text = "52 Week Low: " + fundamentals.low_52_weeks.toUSD()
        quoteCell.market_cap.text = "Market Cap: " + fundamentals.market_cap.toVolume()
      })
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if selected.contains(indexPath) {
      return QuoteCell.expandedHeightValue
    }
    return QuoteCell.heightValue
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return quotes.count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}

