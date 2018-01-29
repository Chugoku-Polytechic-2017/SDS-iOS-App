//
//  PersonGroups.swift
//  SDS-iOS-APP
//
//  Created by 石川諒 on 2018/01/24.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import Foundation
import ProjectOxfordFace
import Keys

struct FaceAPIClient: FaceAPIType {
    var keys: SDSIOSAPPKeys
    var faceAPIClient: MPOFaceServiceClient
    init() {
        keys = SDSIOSAPPKeys()
        faceAPIClient = MPOFaceServiceClient(endpointAndSubscriptionKey: keys.fACEAPIURL, key: keys.fACEAPIKEY)
    }

    func fetchPersonGroupList(response: @escaping ([MPOPersonGroup]) -> ()) {
        _ = faceAPIClient.listPersonGroups(completion: { (result, error) in
            if let error = error {
                print(error)
                return
            }
            guard let groups = result else {
                return
            }
            response(groups)
        })
    }

    func fetchPersonList(inPersonGroup groupId: String, response: @escaping ([MPOPerson]) -> ()) {
        _ = faceAPIClient.listPersons(withPersonGroupId: groupId, completionBlock: { (result, error) in
            if let error = error {
                print(error)
                return
            }
            guard let persons = result else {
                return
            }
            response(persons)
        })
    }

    func createPerson(toPersonGroup groupId: String, name: String, userData: String?, response: @escaping () -> ()) {        
        _ = faceAPIClient.createPerson(withPersonGroupId: groupId, name: name, userData: userData, completionBlock: { (_, error) in
            if let error = error {
                print(error)
                return
            }
            response()
        })
    }
    
}
