//
//  APIEndpoint.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import Foundation

class APIEndpoint {

    private var scheme : String
    private var host: String
    private var path: String
    private var params = [String: String]()

    var url : URL? {

        let url = NSURLComponents().with {
            $0.scheme = scheme
            $0.host = host
            $0.path = path
            $0.queryItems = params.map({ (key, value) -> NSURLQueryItem in
                return NSURLQueryItem(name: key, value: value)
            }) as [URLQueryItem]
            }.url

        return url
    }

    init(scheme: String? = "https", host: String, path: String? = "") {
        self.scheme = scheme!
        self.path = path!
        self.host = host
    }

    func with(path: String) -> Self {
        self.path = path
        return self
    }

    func with(params: [String: String]) -> Self {
        self.params = params
        return self
    }

}
