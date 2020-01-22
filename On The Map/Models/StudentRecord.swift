//
//  StudentRecord.swift
//  On The Map
//
//  Created by aekachai tungrattanavalee on 19/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import Foundation

struct StudentRecord {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
    
    init(_ studentRecordResponse: ParseClient.StudentRecordResponse) {
        createdAt = studentRecordResponse.createdAt!
        firstName = studentRecordResponse.firstName!
        lastName = studentRecordResponse.lastName!
        latitude = studentRecordResponse.latitude!
        longitude = studentRecordResponse.longitude!
        mapString = studentRecordResponse.mapString!
        mediaURL = studentRecordResponse.mediaURL!
        objectId = studentRecordResponse.objectId!
        uniqueKey = studentRecordResponse.uniqueKey!
        updatedAt = studentRecordResponse.updatedAt!
    }
}
