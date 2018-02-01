//
//  SDSViewControllerType.swift
//  SDS-iOS-APP
//
//  Created by 石川諒 on 2018/01/31.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import Foundation
import UIKit
import ProjectOxfordFace
import Keys

protocol SDSViewControllerType {
    var alertView: SDSAlertView { get set }
    var faceAPIClient: MPOFaceServiceClient { get }
    func showErrorAlert(title: String, message: String, handler: ((UIAlertAction) -> ())?)
}

extension SDSViewControllerType where Self: UITableViewController {
    var faceAPIClient: MPOFaceServiceClient {
        get {
            let keys = SDSIOSAPPKeys()
            return MPOFaceServiceClient(endpointAndSubscriptionKey: keys.fACEAPIURL, key: keys.fACEAPIKEY)
        }
    }

    func showErrorAlert(title: String, message: String, handler: ((UIAlertAction) -> ())?) {
        let errorAlert =  alertView.failureAlert(
            title: title,
            message: message,
            handler: handler
        )
        present(errorAlert, animated: true, completion: nil)
    }
}
