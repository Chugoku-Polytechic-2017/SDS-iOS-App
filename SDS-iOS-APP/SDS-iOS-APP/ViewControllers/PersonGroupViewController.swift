//
//  PersonGroupViewController.swift
//  SDS-iOS-APP
//
//  Created by 石川諒 on 2018/01/24.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class PersonGroupViewController: UITableViewController {

    var personGroup: MPOPersonGroup!
    var persons: [MPOPerson] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationBarの境界線を透明にする。
        navigationController?.navigationBar
            .setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell"), indexPath.row == 0 {
            headerCell.textLabel?.text = personGroup.userData
            return headerCell
        }
        if let personCell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") {
            return personCell
        }
        let cell = UITableViewCell()
        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
