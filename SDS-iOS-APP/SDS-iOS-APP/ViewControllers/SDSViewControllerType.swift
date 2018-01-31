//
//  SDSViewControllerType.swift
//  SDS-iOS-APP
//
//  Created by 石川諒 on 2018/01/31.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import Foundation
import UIKit

protocol SDSViewControllerType {
    var alertView: SDSAlertView { get set }
    func showErrorAlert(title: String, message: String, handler: ((UIAlertAction) -> ())?)
}

extension SDSViewControllerType where Self: UITableViewController {
    func showErrorAlert(title: String, message: String, handler: ((UIAlertAction) -> ())?) {
        let errorAlert =  alertView.failureAlert(
            title: title,
            message: message,
            handler: handler
        )
        present(errorAlert, animated: true, completion: nil)
    }
}
