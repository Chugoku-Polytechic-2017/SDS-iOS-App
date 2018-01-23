//
//  FaceAPIType.swift
//  SDS-iOS-APP
//
//  Created by 石川諒 on 2018/01/24.
//  Copyright © 2018年 石川諒. All rights reserved.
//

import Foundation
import ProjectOxfordFace
import Keys

protocol FaceAPIType {
    var keys: SDSIOSAPPKeys { get }
    var faceAPIClient: MPOFaceServiceClient { get set }
}
