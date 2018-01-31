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

    func deleteAction(title: String, message: String, handler: @escaping (UIAlertAction) -> ()) -> UIAlertController {
        let alertController = UIAlertController(
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

    
}
