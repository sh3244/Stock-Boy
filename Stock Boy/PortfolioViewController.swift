//
//  PortfolioViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/26/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Stevia

class PortfolioViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
  var tableView = TableView()
  var refreshControl = UIRefreshControl()
  var statusView = StatusView("$10000.00", .gray)

  var items: [Position] = []

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Portfolio"

    statusView.alpha = 0
    statusView.title.font = UIFont.boldSystemFont(ofSize: 36)

    tableView.register(PortfolioCell.self, forCellReuseIdentifier: "portfolioCell")
    tableView.refreshControl = refreshControl
    tableView.dataSource = self
    tableView.delegate = self
    refreshControl.rx.controlEvent(.valueChanged)
      .subscribe { _ in
        self.update()
        self.refreshControl.endRefreshing()
      }
      .addDisposableTo(disposeBag)

    let counter = myInterval(2.0)
    _ = counter
      .subscribe(onNext: { (value) in
        self.update()
      })
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([tableView, statusView])
    view.layout(
      0,
      |statusView| ~ 80,
      |tableView|,
      0
    )
  }

  func update() {
    if let auth = LoginManager.shared.auth {
      DataManager.shared.fetchRobinhoodPortfolioWith(auth: auth, completion: { (portfolio) in
        if portfolio.equity_previous_close > portfolio.equity {
          self.statusView.backgroundColor = .red
        } else {
          self.statusView.backgroundColor = .green
        }
        self.statusView.title.text = portfolio.equity.toUSD() + "   " + portfolio.equity.dividedBy(portfolio.equity_previous_close).toPercentChange()
        self.revealView(self.statusView)
      })

      DataManager.shared.fetchRobinhoodPositionsWith(auth: auth, completion: { (positions) in
        self.items = positions
        self.tableView.reloadData()
        self.revealView(self.tableView)
      })
    }
  }

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
    let cell = tableView.dequeueReusableCell(withIdentifier: "portfolioCell") as? PortfolioCell

    return cell ?? PortfolioCell()
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]

    if let portfolioCell = cell as? PortfolioCell {
      DataManager.shared.fetchRobinhoodInstrumentWith(url: item.instrument, completion: { (instrument) in
        portfolioCell.symbol.text = instrument.symbol
        DataManager.shared.fetchRobinhoodQuoteWith(symbol: instrument.symbol, completion: { (quote) in
          portfolioCell.change.text = quote.last_trade_price.dividedBy(item.average_buy_price).toPercentChange()
          portfolioCell.value.text = quote.last_trade_price.multipliedBy(item.quantity).toUSD()
        })
      })
      portfolioCell.cost.text = item.average_buy_price.multipliedBy(item.quantity).toUSD()
      portfolioCell.shares.text = item.quantity.toVolume()
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if selected.contains(indexPath) {
      return PortfolioCell.expandedHeightValue
    }
    return PortfolioCell.heightValue
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

}
