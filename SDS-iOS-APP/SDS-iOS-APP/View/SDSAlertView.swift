//
//  AlertView.swift
//  SDS-iOS-APP
//
//  Created by 石川諒 on 2018/01/31.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import Foundation
import UIKit

struct SDSAlertView {

    func failureAlert(title: String, message: String, handler: ((UIAlertAction) -> ())?) -> UIAlertController {
        let aletController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default) { action in
                guard let closure = handler else {
                    return
                }
                closure(action)
        }        
        aletController.addAction(action)
        return aletController
    }

    func deleteAlert(title: String, message: String, handler: @escaping (UIAlertAction) -> ()) -> UIAlertController {
        let alertController = UIAlertController (
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.actionSheet
        )

        let deleteAction = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.destructive) { action in
            handler(action)
        }

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        return alertController
    }

    func addAlert(title: String, message: String, handler: @escaping (UIAlertAction,String,String?) -> ()) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )

        alertController.addTextField { textField in
            textField.placeholder = "ユーザー名"
        }
        alertController.addTextField { textField in
            textField.placeholder = "userData(optional)"
        }

        let action = UIAlertAction(title: "OK", style: .default) { action in
            guard let paramsTextField = alertController.textFields else {
                return
            }
            let params = paramsTextField.map({ textField -> String? in
                textField.text
            })
            guard let name = params[0] else {
                return
            }
            let userData = params[1]
            handler(action, name, userData)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        return alertController
    }
    
}
