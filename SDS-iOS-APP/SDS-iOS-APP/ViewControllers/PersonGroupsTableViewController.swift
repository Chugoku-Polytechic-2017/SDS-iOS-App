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

class PersonGroupsTableViewController: UITableViewController {

    var personGroups: [MPOPersonGroup] = []
    var faceAPIClient = FaceAPIClient()

    override func viewDidLoad() {
        super.viewDidLoad()        
        faceAPIClient.fetchPersonGroupList { (groups) in
            self.personGroups = groups
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setCell(cell: UITableViewCell, row: Int) -> UITableViewCell {
        cell.textLabel?.text = personGroups[row].name
        cell.detailTextLabel?.text = personGroups[row].userData
        return cell
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "subtitle") {
            return setCell(cell: cell, row: indexPath.row)
        }
        let cell = UITableViewCell()
        return setCell(cell: cell, row: indexPath.row)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personGroups.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowPersonDetail", sender: nil)
    }

}

