//
//  PersonGroupViewController.swift
//  SDS-iOS-APP
//
//  Created by 石川諒 on 2018/01/24.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class PersonGroupViewController: UITableViewController, SDSViewControllerType {

    var faceAPIClient = FaceAPIClient()
    var personGroup: MPOPersonGroup!
    var persons: [MPOPerson] = []
    var alertView = SDSAlertView()
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
        self.faceAPIClient.deletePersonGroup(withGroupId: self.personGroup.personGroupId) {error in
            if let error = error {
                print(error)
                self.showErrorAlert(
                    title: "エラー",
                    message: error.localizedDescription,
                    handler: nil
                )
            }
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
                    response: { error in
                    if let error = error {
                        self.showErrorAlert(title: "エラー", message: error.localizedDescription, handler: nil)
                    }
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

    func setPersonCell(cell: UITableViewCell?, row: Int) -> UITableViewCell? {
        cell?.textLabel?.text = persons[row].name
        cell?.detailTextLabel?.text = persons[row].userData
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
            cell?.textLabel?.text = personGroup.userData
        case persons.count + 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "DeleteCell")
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell")
            cell = setPersonCell(cell: cell, row: indexPath.row - 1)
        }
        if let reuseCell = cell {
            return reuseCell
        } else {
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowPersonDetail",
            let personViewController = segue.destination as? PersonViewController,
            let person = sender as? MPOPerson else {
                return
        }
        personViewController.person = person
        personViewController.personGroupId = personGroup.personGroupId
        personViewController.navigationItem.title = person.name
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1...persons.count:
            performSegue(withIdentifier: "ShowPersonDetail", sender: persons[indexPath.row - 1])
        default:
            break
        }
    }

}
