//
//  JSONParser.swift
//  On The Map
//
//  Created by aekachai tungrattanavalee on 19/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import Foundation

class JSONParser {
    static func stringify<T: Encodable>(_ codable: T) -> String {
        do {
            let jsonData = try JSONEncoder().encode(codable)
            return String(data: jsonData, encoding: .utf8)!
        }
        catch {
            print("Could not encode the given object to JSON: \(error.localizedDescription)")
            return ""
        }
    }
    
    static func decode<T : Decodable>(_ data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        }
        catch {
            print("Could not decode the given data to type \(T.self): \(error.localizedDescription)")
            return nil
        }
    }
    
    static func deserialize(_ data: Data) -> AnyObject? {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            print("Could not deserialize the given data to JSON: \(error.localizedDescription)")
        }
        return parsedResult
    }
}
