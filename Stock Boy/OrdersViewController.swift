//
//  OrdersViewController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/26/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa

class OrdersViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
  var tableView = TableView()
  var refreshControl = UIRefreshControl()
  let headerView = HeaderView(["Symbol", "Type", "Shares", "Price", "Value"])

  var items: [Order] = []

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Orders"

    tableView.register(OrderCell.self, forCellReuseIdentifier: "orderCell")
    tableView.refreshControl = refreshControl
    tableView.dataSource = self
    tableView.delegate = self
    refreshControl.rx.controlEvent(.valueChanged)
      .subscribe { _ in
        self.update()
        self.refreshControl.endRefreshing()
      }
      .addDisposableTo(disposeBag)

    let orders = DataManager.shared.orders
    orders.asObservable()
      .subscribe({ (orders) in
        if let ords = orders.element?.first?.results {
          self.items = ords
          self.tableView.reloadData()
          self.revealView(self.tableView)
        }
      })
      .addDisposableTo(disposeBag)

    update()
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.sv([headerView, tableView])
    view.layout(
      0,
      |headerView|,
      |tableView|,
      0
    )
  }

  func update() {
    if let auth = LoginManager.shared.auth {
      DataManager.shared.fetchRobinhoodOrdersWith(auth: auth, completion: { (orders) in
        DataManager.shared.orders.value.append(Orders(results: orders))
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as? OrderCell

    return cell ?? OrderCell()
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let order = items[indexPath.row]

    if let orderCell = cell as? OrderCell {
      DataManager.shared.fetchRobinhoodInstrumentWith(url: order.instrument, completion: { (instrument) in
        orderCell.symbol.text = instrument.symbol
      })
      orderCell.type.text = order.side
      orderCell.quantity.text = order.quantity
      orderCell.price.text = order.price ?? ""

      if let quantity = Double(order.quantity), let price = Double(order.price ?? "") {
        orderCell.cost.text = String(quantity * price)
      }
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if selected.contains(indexPath) {
      return OrderCell.expandedHeightValue
    }
    return OrderCell.heightValue
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
}
