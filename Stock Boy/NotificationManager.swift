//
//  NotificationManager.swift
//  Stock Boy
//
//  Created by S on 5/16/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import Argo
import Alamofire
import RxSwift

class NotificationManager: NSObject {
    
    static let shared: NotificationManager = {
        let instance = NotificationManager()
        
        return instance
    }()
    
}
