//
//  StudentRecordCache.swift
//  On The Map
//
//  Created by aekachai tungrattanavalee on 19/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import Foundation

class StudentRecordCache {
    static let instance = StudentRecordCache()
    
    private var studentRecords = [StudentRecord]()
    
    func set(_ records: [StudentRecord]) {
        studentRecords = records
    }
    
    func getAll() -> [StudentRecord] {
        return studentRecords
    }
    
    func get(fromIndex index: Int) -> StudentRecord? {
        if (index >= studentRecords.count) {
            print("Student record index out of bounds.")
            return nil
        }
        return studentRecords[index]
    }
}
