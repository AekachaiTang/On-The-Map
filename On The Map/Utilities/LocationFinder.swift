//
//  LocationFinder.swift
//  On The Map
//
//  Created by aekachai tungrattanavalee on 19/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import Foundation
import CoreLocation

class LocationFinder {
    static func find(_ searchString: String, _ findCompletion: @escaping (_ coordinate: CLLocationCoordinate2D?) -> Void) {
        CLGeocoder().geocodeAddressString(searchString, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!.localizedDescription)
                findCompletion(nil)
                return
            }
            
            if placemarks == nil || placemarks!.count == 0 {
                findCompletion(nil)
                return
            }
            
            guard let coordinate = placemarks![0].location?.coordinate else {
                findCompletion(nil)
                return
            }
            
            print("Coordinate: \(coordinate.latitude), \(coordinate.longitude)")
            findCompletion(coordinate)
        })
    }
}
