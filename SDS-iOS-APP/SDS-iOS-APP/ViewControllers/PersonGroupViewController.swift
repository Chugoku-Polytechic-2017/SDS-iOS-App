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

    var faceAPIClient = FaceAPIClient()
    var personGroup: MPOPersonGroup!
    var persons: [MPOPerson] = []
    private var numberOfCell: Int {
        return persons.count + 1
    }    

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationBarの境界線を透明にする。
        navigationController?.navigationBar.shadowImage = UIImage()
        faceAPIClient.fetchPersonList(inPersonGroup: personGroup.personGroupId) { result in
            self.persons = result
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
    }

    func setPersonCell(cell: UITableViewCell, row: Int) -> UITableViewCell {        
        cell.textLabel?.text = persons[row].name
        cell.detailTextLabel?.text = persons[row].userData
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell"), indexPath.row == 0 {
            headerCell.textLabel?.text = personGroup.userData
            return headerCell
        }
        if let personCell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") {
            // 最初のcellはheaderだから、(row - 1)がperonsのindex。
            return setPersonCell(cell: personCell, row: indexPath.row - 1)
        }
        let cell = UITableViewCell()
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCell
    }

}
