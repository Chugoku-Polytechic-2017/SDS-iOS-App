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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPersonList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func createPerson (name: String, userData: String?) {
        faceAPIClient.createPerson(
            withPersonGroupId: personGroup.personGroupId,
            name: name,
            userData: userData) { (result, error) in
                if let error = error {
                    self.showErrorAlert(title: "エラー", message: error.localizedDescription, handler: nil)
                }
                self.fetchPersonList()
        }
    }

    func fetchPersonList() {
        faceAPIClient.listPersons(withPersonGroupId: personGroup.personGroupId) { (result, error) in
            if let error = error {
                self.showErrorAlert(title: "エラー", message: error.localizedDescription, handler: nil)
            }
            guard let personList = result else {
                return
            }
            self.persons = personList
            self.tableView.reloadData()
        }
    }

    private func deletePersonGroup() {
        faceAPIClient.deletePersonGroup(withPersonGroupId: personGroup.personGroupId) { error in
            if let error = error {
                self.showErrorAlert(title: "エラー", message: error.localizedDescription, handler: nil)
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let deleteAlert = alertView.addAlert (
            title: "新しいユーザーを追加",
            message: "ユーザー名とuserDataを入力してください") {
                (action, name, userData) in
                self.createPerson(name: name, userData: userData)
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
