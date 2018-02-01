//
//  PersonViewController.swift
//  SDS-iOS-APP
//
//  Created by 石川諒 on 2018/01/31.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import UIKit
import AVFoundation
import ProjectOxfordFace

class PersonViewController: UITableViewController, SDSViewControllerType, FaceManagerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var alertView = SDSAlertView()
    var faceAPIClient = FaceAPIClient()
    var personGroupId: String!
    var person: MPOPerson!
    var persistedFaceIds: [String] = []    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPersistedFaceIds(ids: person.persistedFaceIds)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowFaceManageView",
            let childViewController = segue.destination as? FaceManageViewController else {
                return
        }
        childViewController.delegate = self
        childViewController.userData = person.userData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mangePersistedFaceId() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }

    func startUIImagePicker() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = UIImagePickerControllerSourceType.camera
        cameraPicker.cameraDevice = UIImagePickerControllerCameraDevice.front
        cameraPicker.delegate = self
        self.present(cameraPicker, animated: true, completion: nil)
    }

    func addPersonFace() {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        var errorMessage:String? = nil
        switch status {
        case .authorized:
            // アクセス許可あり
            startUIImagePicker()
        case .notDetermined:
            // まだアクセス許可を聞いていない
            // カメラが利用可能かチェック
            if !UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.camera) {
                errorMessage = "カメラが起動できませんでした。"
            } else {
                startUIImagePicker()
            }
        case .restricted:
            // ユーザー自身にカメラへのアクセスが許可されていない
            errorMessage = "カメラを使用する許可がありません。"
        case .denied:
            // アクセス許可されていない
            errorMessage = "許可がありません。カメラ使うには、設定よりカメラへのアクセスを許可してください。"
        }
        if let message = errorMessage {
            showErrorAlert(title: "エラー", message: message, handler: nil)
        }
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

    func deletePersistedFaceid(id: String) {
        faceAPIClient.deletePersistedFaceId(
            groupId: personGroupId,
            personId: person.personId,
            persistedFaceId: id) { error in
                if let error = error {
                    self.showErrorAlert(
                        title: "エラー",
                        message: error.localizedDescription,
                        handler: nil
                    )
                }
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

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0, persistedFaceIds.count > 0 {
            return true
        } else {
            return false
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == UITableViewCellEditingStyle.delete else {
            return
        }
        let id = persistedFaceIds[indexPath.row]
        let deleteAlert = alertView.deleteAlert(
            title: "顔情報の削除",
            message: "登録した顔情報、\(id)は、削除されます。") { _ in
                self.deletePersistedFaceid(id: id)
                self.persistedFaceIds.remove(at: indexPath.row)
                self.tableView.reloadData()
                if self.persistedFaceIds.count == 0 {
                    self.tableView.setEditing(false, animated: true)
                }
        }
        present(deleteAlert, animated: true, completion: nil)
    }

}
