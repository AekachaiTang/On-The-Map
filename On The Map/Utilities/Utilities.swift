//
//  Utilities.swift
//  On The Map
//
//  Created by aekachai tungrattanavalee on 19/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    static func getCookie(withKey key: String) -> HTTPCookie? {
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == key {
                return cookie
            }
        }
        return nil
    }
    
    static func showErrorAlert(_ controller: UIViewController, _ message: String?) {
        guard message != nil else {
            print("showErrorAlert(): No message to display.")
            return
        }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func openURL(_ urlString: String) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
