//
//  rx.swift
//  Stock Boy
//
//  Created by Sam on 4/23/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import Foundation
import RxSwift

func myInterval(_ interval: TimeInterval) -> Observable<Int> {
  return Observable.create { observer in
    let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    timer.scheduleRepeating(deadline: DispatchTime.now() + interval, interval: interval)

    let cancel = Disposables.create {
      timer.cancel()
    }

    var next = 0
    timer.setEventHandler {
      if cancel.isDisposed {
        return
      }
      observer.on(.next(next))
      next += 1
    }
    timer.resume()

    return cancel
  }
}
