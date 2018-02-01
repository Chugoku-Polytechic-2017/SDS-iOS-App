//
//  PersonViewController.swift
//  SDS-iOS-APP
//
//  Created by 石川諒 on 2018/01/31.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import UIKit
import ProjectOxfordFace

class PersonViewController: UITableViewController, SDSViewControllerType {

    var alertView = SDSAlertView()
    var faceAPIClient = FaceAPIClient()
    var personGroupId: String!
    var person: MPOPerson!
    var persistedFaceIds: [String] = []    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setPersistedFaceIds(ids: person.persistedFaceIds)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setPersistedFaceIds(ids: [Any]) {
        persistedFaceIds = ids.map({ any -> String? in
            guard let id = any as? String else {
                return nil
            }
            return id
        }).flatMap({ (id) -> String? in
            id
        })
    }

    func deletePerson() {
        faceAPIClient.deletePerson(
            groupId: personGroupId,
            personId: person.personId) { error in
                if let error = error {
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

    @IBAction func deleteButtonTapped(_ sender: Any) {
        let deleteAlert = alertView.deleteAlert(
            title: "ユーザーの削除",
            message: "\(person.name)を削除しますか？\n登録済みの顔情報も失われます。") { _ in
                self.deletePerson()
        }
        present(deleteAlert, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return persistedFaceIds.count == 0 ? 1 : persistedFaceIds.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "PersistedFaceIdCell")
            guard persistedFaceIds.count != 0 else {
                cell?.textLabel?.text = "なし"
                break
            }
            cell?.textLabel?.text = persistedFaceIds[indexPath.row]
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "DeleteCell")
        default:
            cell = nil
        }
        if let reuseCell = cell {
            return reuseCell
        } else {
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "persistedFaceId"
        case 1:
            return "削除"
        default:
            return nil
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
