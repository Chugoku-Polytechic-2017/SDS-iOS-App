//
//  FaceManageViewController.swift
//  SDS-iOS-APP
//
//  Created by 石川諒 on 2018/02/01.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import UIKit

protocol FaceManagerViewControllerDelegate {
    func mangePersistedFaceId ()
    func addButtonTapped ()
}

class FaceManageViewController: UIViewController {

    @IBOutlet weak var userDataLabel: UILabel!
    var userData: String?
    var delegate: FaceManagerViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataLabel.text = userData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func manageButtonTapped(_ sender: Any) {
        delegate?.mangePersistedFaceId()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate.addButtonTapped()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
