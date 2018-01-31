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
    let alertView = SDSAlertView()
    private var numberOfCell: Int {
        return persons.count + 2
    }    

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationBarの境界線を透明にする。
        navigationController?.navigationBar.shadowImage = UIImage()
        fetchPersonList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func fetchPersonList() {
        faceAPIClient.fetchPersonList(inPersonGroup: personGroup.personGroupId) { result in
            self.persons = result
            self.tableView.reloadData()
        }
    }

    private func deletePersonGroup() {
        self.faceAPIClient.deletePersonGroup(withGroupId: self.personGroup.personGroupId) {
            self.navigationController?.popViewController(
                animated: true
            )
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let deleteAlert = alertView.addAlert (
            title: "新しいユーザーを追加",
            message: "ユーザー名とuserDataを入力してください") {
                (action, name, userData) in
                self.faceAPIClient.createPerson(
                    toPersonGroup: self.personGroup.personGroupId,
                    name: name,
                    userData: userData,
                    response: {
                    self.fetchPersonList()
                })
        }
        present(deleteAlert, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let deleteAlert = alertView.deleteAlert(
            title: "グループを削除します。",
            message: "\(personGroup.name)を削除しますか？\nグループのユーザー情報も失われます。") { _ in
            self.deletePersonGroup()
        }
        present(deleteAlert, animated: true, completion: nil)
    }

    func setPersonCell(cell: UITableViewCell, row: Int) -> UITableViewCell {        
        cell.textLabel?.text = persons[row].name
        cell.detailTextLabel?.text = persons[row].userData
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
            cell?.textLabel?.text = personGroup.userData
        case persons.count + 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "DeleteCell")
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell")
        }
        guard let reuseCell = cell else {
            return UITableViewCell()
        }
        
        if reuseCell.reuseIdentifier == "PersonCell" {
            return setPersonCell(cell: reuseCell, row: indexPath.row - 1)
        }
        return reuseCell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCell
    }

}
