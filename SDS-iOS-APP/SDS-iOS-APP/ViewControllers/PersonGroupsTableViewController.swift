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
import SVProgressHUD

class PersonGroupsTableViewController: UITableViewController, SDSViewControllerType {

    var personGroups: [MPOPersonGroup] = []    
    var alertView = SDSAlertView()

    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPersonGroupList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchPersonGroupList() {
        SVProgressHUD.show()
        faceAPIClient.listPersonGroups { (result, error) in
            if let error = error {
                print(error)
                self.showErrorAlert(title: "エラー", message: error.localizedDescription, handler: nil)
                return
            }
            guard let groups = result else {
                return
            }
            self.personGroups = groups
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }

    func createPersonGroup(name:String, userData: String?) {
        SVProgressHUD.show(withStatus: "追加中")
        faceAPIClient.createPersonGroup(
            withId: name,
            name: name,
            userData: userData) { error in
                if let error = error {
                    SVProgressHUD.dismiss()
                    self.showErrorAlert(title: "エラー", message: error.localizedDescription, handler: nil)
                    return
                }
                SVProgressHUD.dismiss()
                self.fetchPersonGroupList()
        }
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = alertView.addAlert(
        title: "新しいグループを作成",
        message: "グループ名とUserDataを入力してください。") { (action, name, userData) in
            self.createPersonGroup(name: name, userData: userData)
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func setCell(cell: UITableViewCell, row: Int) -> UITableViewCell {
        cell.textLabel?.text = personGroups[row].name
        cell.detailTextLabel?.text = personGroups[row].userData
        return cell
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PersonGroupCell") {
            return setCell(cell: cell, row: indexPath.row)
        }
        let cell = UITableViewCell()
        return setCell(cell: cell, row: indexPath.row)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personGroups.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowGroupDetail",
            let personGroupViewController = segue.destination as? PersonGroupViewController,
            let group = sender as? MPOPersonGroup else {
            return
        }
        personGroupViewController.personGroup = group
        personGroupViewController.navigationItem.title = group.name
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowGroupDetail", sender: personGroups[indexPath.row])
    }

}

