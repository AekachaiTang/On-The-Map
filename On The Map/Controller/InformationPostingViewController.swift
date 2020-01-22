//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by aekachai tungrattanavalee on 19/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {

  
    let pinReuseID = "Pin"
    let mapStringInputTag = 400
    let mediaUrlInputTag = 401
  
    var mapString = ""
    var coordinate: CLLocationCoordinate2D? = nil
    var activeField: UITextField?

    @IBOutlet var mapStringPrompt: UILabel!
    @IBOutlet var mapStringInput: UITextField!
    @IBOutlet var mediaURLPrompt: UILabel!
    @IBOutlet var mediaURLInput: UITextField!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
           super.viewDidLoad()
           mediaURLPrompt.isHidden = true
           mediaURLInput.isHidden = true
           mapView.isHidden = true
           
           mapStringInput.tag = mapStringInputTag
           mediaURLInput.tag = mediaUrlInputTag
           
           mapStringInput.delegate = self
           mediaURLInput.delegate = self
       }
       
      
    func findLocation() {
        mapString = mapStringInput.text!
        

        
        LocationFinder.find(mapString) { (coordinate) in
            DispatchQueue.main.async {
               
                
                if coordinate == nil {
                    Utilities.showErrorAlert(self, "Could not find the location of \"\(self.mapString)\".")
                } else {
                    self.coordinate = coordinate
                    self.showLocationAndAllowSubmit()
                }
            }
        }
    }
    
    func submit() {
        let mediaURL = mediaURLInput.text!
        if mediaURL.isEmpty {
            Utilities.showErrorAlert(self, "Please enter a URL.")
            return
        }
        
      
        
        ParseClient.shared.setStudentRecord(mapString,
                                            coordinate!.latitude,
                                            coordinate!.longitude,
                                            mediaURL) { (successful, displayError) in
            DispatchQueue.main.async {
             
                
                if (successful) {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    Utilities.showErrorAlert(self, displayError)
                }
            }
        }
    }

    private func showLocationAndAllowSubmit() {
        mapStringPrompt.isHidden = true
        mapStringInput.isHidden = true
        
        mapView.isHidden = false
        mediaURLPrompt.isHidden = false
        mediaURLInput.isHidden = false
        
        //navigate to map location
        mapView.setCenter(coordinate!, animated: false)
        
        //add pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        mapView.addAnnotation(annotation)
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
extension InformationPostingViewController: MKMapViewDelegate {
    // Create annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinReuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinReuseID)
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
extension InformationPostingViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == mapStringInputTag {
            findLocation()
        } else if textField.tag == mediaUrlInputTag {
            submit()
        }
        return true
    }
}
