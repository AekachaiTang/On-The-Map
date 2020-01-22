//
//  StudentsTabBarController.swift
//  On The Map
//
//  Created by aekachai tungrattanavalee on 19/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import UIKit

class StudentsTabBarController: UITabBarController {

    let informationPostingSegue = "InformationPostingSegue"
    let overwriteAlertQuestion = "You have already posted a location. Would you like to overwrite it?"
    
    var updateMapView: (() -> ())?
    var updateTableView: (() -> ())?
    
    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var addPinButton: UIBarButtonItem!
    
    @IBAction func logout(_ sender: Any) {
        ParseClient.shared.needsRefresh = true
        
     
        
        UdacityClient.shared.logout(completion: {(successful, displayError) in
            DispatchQueue.main.async {
            
                if (successful) {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    Utilities.showErrorAlert(self, displayError)
                }
            }
        })
    }
    
    @IBAction func addPin(_ sender: Any) {
        if ParseClient.shared.loggedInStudentRecordID == nil {
            
            
            ParseClient.shared.getLoggedInStudentRecord() { (successful, displayError) in
                DispatchQueue.main.async {
            
                    
                    if (successful) {
                        if ParseClient.shared.loggedInStudentRecordID == nil {
                            self.segueToInformationPostingView()
                        } else {
                            self.showOverwriteAlert()
                        }
                    } else {
                        Utilities.showErrorAlert(self, displayError)
                    }
                }
            }
        } else {
            showOverwriteAlert()
        }
    }
    
    @IBAction func refresh() {
        //do not allow the user to refresh during load
        refreshButton.isEnabled = false
     
        
        ParseClient.shared.getStudentRecords { (successful, error) in
            DispatchQueue.main.async {
                self.refreshButton.isEnabled = true
         
                
                if successful {
                    if self.updateMapView == nil {
                        print("Completion handler for updating map view is not set!")
                    } else {
                        self.updateMapView?()
                    }
                    
                    if self.updateTableView == nil {
                        print("Completion handler for updating table view is not set!")
                    } else {
                        self.updateTableView?()
                    }
                } else {
                    Utilities.showErrorAlert(self, error)
                }
            }
        }
    }
    
    private func showOverwriteAlert() {
        let alertController = UIAlertController(title: "Warning", message: overwriteAlertQuestion, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Overwrite", style: .default) { action in
            self.segueToInformationPostingView()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func segueToInformationPostingView() {
        performSegue(withIdentifier: informationPostingSegue, sender: nil)
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (ParseClient.shared.needsRefresh) {
            refresh()
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
