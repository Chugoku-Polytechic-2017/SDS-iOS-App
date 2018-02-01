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

    func createPersonGroup(name: String, userData:String?, response: @escaping (Error?) -> ()) {
        _ = faceAPIClient.createPersonGroup(
            withId: name,
            name: name,
            userData: userData,
            completionBlock: response
        )
    }

    func deletePersonGroup(withGroupId groupId: String, response: @escaping (Error?) -> ()) {
        _ = faceAPIClient.deletePersonGroup(withPersonGroupId: groupId, completionBlock: response
        )
    }

    func deletePerson(groupId: String, personId: String, response: @escaping (Error?) -> ()) {
        _ = faceAPIClient.deletePerson(
            withPersonGroupId: groupId,
            personId: personId,
            completionBlock: response
        )
    }

    func deletePersistedFaceId(groupId: String, personId: String, persistedFaceId: String, response: @escaping (Error?) -> ()) {
        _ = faceAPIClient.deletePersonFace(
            withPersonGroupId: groupId,
            personId: personId,
            persistedFaceId: persistedFaceId,
            completionBlock: response
        )
    }

}
