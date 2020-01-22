//
//  StudentsMapViewController.swift
//  On The Map
//
//  Created by aekachai tungrattanavalee on 19/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import UIKit
import MapKit

class StudentsMapViewController: UIViewController, MKMapViewDelegate {

    let pinReuseID = "Pin"
    @IBOutlet weak var mapView: MKMapView!
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (tabBarController! as! StudentsTabBarController).updateMapView = displayStudentRecords
    }
    
    func displayStudentRecords() {
        //remove old annotations from the map
        let oldAnnotations = mapView.annotations
        mapView.removeAnnotations(oldAnnotations)
        
        //create new annotations
        var annotations = [MKPointAnnotation]()
        let records = StudentRecordCache.instance.getAll()
        
        for record in records {
            let lat = CLLocationDegrees(record.latitude)
            let long = CLLocationDegrees(record.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = "\(record.firstName) \(record.lastName)"
            annotation.subtitle = record.mediaURL
            
            annotations.append(annotation)
        }
        
        //add annotations to map
        mapView.addAnnotations(annotations)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinReuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinReuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaUrl = view.annotation?.subtitle! {
                Utilities.openURL(mediaUrl)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
