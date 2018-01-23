//
//  ViewController.swift
//  SDS-iOS-APP
//
//  Created by 石川諒 on 2018/01/14.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import UIKit
import ProjectOxfordFace
import Keys

class PersonGroupTableViewController: UITableViewController {

    var personGroups: [MPOPersonGroup] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let keys = SDSIOSAPPKeys()
        let faceClient = MPOFaceServiceClient(endpointAndSubscriptionKey: keys.fACEAPIURL, key: keys.fACEAPIKEY)        
        _ = faceClient?.listPersonGroups(completion: { (response, error) in
            if let e = error {
                print(e)
                return
            }
            guard let groups = response else {
                return
            }
            groups.forEach({ personGroup in
                print(personGroup.name)
                print(personGroup.personGroupId)
            })
            self.personGroups = groups
        })
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personGroups.count
    }

}

