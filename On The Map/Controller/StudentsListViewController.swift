//
//  StudentsListViewController.swift
//  On The Map
//
//  Created by aekachai tungrattanavalee on 19/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import UIKit

class StudentsListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    let cellIdentifier = "cell"
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (tabBarController! as! StudentsTabBarController).updateTableView = displayStudentRecords
    }
    func displayStudentRecords() {
        studentTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentRecordCache.instance.getAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard let record = StudentRecordCache.instance.get(fromIndex: indexPath.row) else {
            print ("Record was not found.")
            return cell
        }
        
        cell.textLabel?.text = "\(record.firstName) \(record.lastName)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let record = StudentRecordCache.instance.get(fromIndex: indexPath.row) else {
            print ("Record was not found.")
            return
        }
        
        Utilities.openURL(record.mediaURL)
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
