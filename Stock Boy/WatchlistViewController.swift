//
//  WatchlistViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia
import RxSwift

class WatchlistViewController: ViewController {
  let tableView = TableView()
  let refreshControl = UIRefreshControl()
  let selectionView = SelectionView(["% ↑", "% ↓", "Sym ↑", "Sym ↓", "Risk ↑", "Risk ↓"])
  let headerView = HeaderView(["Symbol", "Name", "Price", "Risk", "%"], [50, -100, 50, 50, 50])

  var quotes: [Quote] = []
  var proposals: [Proposal] = []
  var instruments: [Instrument] = []

  var paused = true

  var sortBlock: ((Void) -> Void) = {}

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(QuoteCell.self, forCellReuseIdentifier: "quoteCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)

    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Paused", style: .plain, target: self, action: #selector(autoUpdate))

    sortBlock = {
      self.quotes = self.quotes.sorted(by: { (quote1, quote2) -> Bool in
        let first = String((Double(quote1.last_trade_price) ?? 1) / (Double(quote1.adjusted_previous_close) ?? 1))
        let second = String((Double(quote2.last_trade_price) ?? 1) / (Double(quote2.adjusted_previous_close) ?? 1))

        return first < second
      })
    }
    selectionView.delegate = self

    self.refreshTable()

    let counter = myInterval(3)
    _ = counter
      .subscribe(onNext: { (value) in
        if !self.paused && !self.isEditing {
          self.refreshTable()
        }
      })
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([tableView, selectionView, headerView])
    view.layout(
      8,
      |selectionView|,
      |headerView|,
      |tableView|,
      0
    )
  }

  func pullRefresh() {
    selected.removeAll()
    refreshTable()
  }

  func autoUpdate() {
    paused = !paused
    if paused {
      navigationItem.leftBarButtonItem?.title = "Paused"
    }
    else {
      navigationItem.leftBarButtonItem?.title = "Updating"
    }
  }

  func refreshTable() {
    refreshControl.endRefreshing()

    if let auth = LoginManager.shared.auth {
      DataManager.shared.fetchRobinhoodDefaultWatchlistWith(auth: auth, completion: { watchlist in
        DataManager.shared.fetchRobinhoodInstrumentsWith(watchlist: watchlist.results, completion: { (instruments) in
          self.instruments = instruments
          DataManager.shared.fetchRobinhoodQuotesWith(instruments: instruments, completion: { (quotes) in
            DecisionManager.shared.generateProposalsFor(quotes: self.quotes, completion: { (proposals) in
              DispatchQueue.main.async {
                self.quotes = quotes
                self.proposals = proposals
                self.sortBlock()
                self.tableView.reloadData()
                self.revealView(self.tableView)
              }
            })
          })
        })
      })
    }
  }
}

extension WatchlistViewController : UITableViewDataSource {

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
    let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell") as? QuoteCell

    return cell ?? QuoteCell()
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let quote = quotes[indexPath.row]

    if let quoteCell = cell as? QuoteCell {
      quoteCell.symbol.text = quote.symbol
      quoteCell.price.text = quote.last_trade_price
      //      quoteCell.change.text = String((Double(quote.last_trade_price) ?? 1) - (Double(quote.adjusted_previous_close) ?? 1))
      let proposal = proposals.first(where: { (proposal) -> Bool in
        return proposal.symbol == quote.symbol
      })
      quoteCell.change.text = proposal?.risk
      quoteCell.changePercent.text = String((Double(quote.last_trade_price) ?? 1) / (Double(quote.adjusted_previous_close) ?? 1))
      DataManager.shared.fetchRobinhoodInstrumentWith(url: quote.instrument, completion: { (instrument) in
        quoteCell.name.text = instrument.name
      })
      DataManager.shared.fetchRobinhoodFundamentalsWith(symbol: quote.symbol, completion: { (fundamentals) in
        quoteCell.open.text = fundamentals.open
        quoteCell.high.text = fundamentals.high
        quoteCell.low.text = fundamentals.low
        quoteCell.volume.text = fundamentals.volume
        quoteCell.average_volume.text = fundamentals.average_volume
        quoteCell.high_52_weeks.text = fundamentals.high_52_weeks
        quoteCell.low_52_weeks.text = fundamentals.low_52_weeks
        quoteCell.market_cap.text = fundamentals.market_cap
      })
      if selected.contains(indexPath) {
        guard let url = chartURLFor(symbol: quote.symbol) else {
          return
        }
        quoteCell.chart.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
      }
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

  // Editing

  func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
    self.setEditing(true, animated: false)

    let more = UITableViewRowAction(style: .normal, title: "Trade") { action, index in
      self.setEditing(false, animated: false)
      let quote = self.quotes[index.row]
      let controller = TradeViewController("Trade " + quote.symbol, symbol: quote.symbol)
      self.navigationController?.pushViewController(controller, animated: true)
    }

    more.backgroundColor = .red

    return [more]
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
}

extension WatchlistViewController: SelectionViewDelegate {

  func selected(title: String) {
    switch title {
    case "% ↑":
      sortBlock = {
        self.quotes = self.quotes.sorted(by: { (quote1, quote2) -> Bool in
          let first = String((Double(quote1.last_trade_price) ?? 1) / (Double(quote1.adjusted_previous_close) ?? 1))
          let second = String((Double(quote2.last_trade_price) ?? 1) / (Double(quote2.adjusted_previous_close) ?? 1))

          return first < second
        })
      }
    case "% ↓":
      sortBlock = {
        self.quotes = self.quotes.sorted(by: { (quote1, quote2) -> Bool in
          let first = String((Double(quote1.last_trade_price) ?? 1) / (Double(quote1.adjusted_previous_close) ?? 1))
          let second = String((Double(quote2.last_trade_price) ?? 1) / (Double(quote2.adjusted_previous_close) ?? 1))

          return first > second
        })
      }
    case "Sym ↑":
      sortBlock = {
        self.quotes = self.quotes.sorted(by: { (quote1, quote2) -> Bool in
          return quote1.symbol < quote2.symbol
        })
      }
    case "Sym ↓":
      sortBlock = {
        self.quotes = self.quotes.sorted(by: { (quote1, quote2) -> Bool in
          return quote1.symbol > quote2.symbol
        })
      }
    case "Risk ↑":
      sortBlock = {
        self.quotes = self.quotes.sorted(by: { (quote1, quote2) -> Bool in
          let first = self.proposals.first(where: { (proposal) -> Bool in
            return proposal.symbol == quote1.symbol
          })
          let second = self.proposals.first(where: { (proposal) -> Bool in
            return proposal.symbol == quote2.symbol
          })
          return Double(first?.risk ?? "") ?? 0.0 < Double(second?.risk ?? "") ?? 0.0
        })
      }
    case "Risk ↓":
      sortBlock = {
        self.quotes = self.quotes.sorted(by: { (quote1, quote2) -> Bool in
          let first = self.proposals.first(where: { (proposal) -> Bool in
            return proposal.symbol == quote1.symbol
          })
          let second = self.proposals.first(where: { (proposal) -> Bool in
            return proposal.symbol == quote2.symbol
          })
          return Double(first?.risk ?? "") ?? 0.0 > Double(second?.risk ?? "") ?? 0.0
        })
      }
    default:
      break
    }
    self.sortBlock()
    self.tableView.reloadData()
  }
}

