//
//  Constants.swift
//  On The Map
//
//  Created by aekachai tungrattanavalee on 19/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import Foundation

struct WebMethod {
    static let get = "GET";
    static let post = "POST";
    static let delete = "DELETE";
    static let put = "PUT"
}

struct RequestKey {
    static let accept = "Accept";
    static let contentType = "Content-Type";
    static let xxsrfToken = "X-XSRF-TOKEN";
}

struct RequestValue {
    static let jsonType = "application/json";
}

struct Cookie {
    static let xsrfToken = "XSRF-TOKEN";
}

struct DisplayError {
    static let unexpected = "An unexpected error occurred."
    static let network = "Could not connect to the Internet."
    static let credentials = "Incorrect email or password."
}
