//
//  APIError.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import Foundation

// MARK - Error

enum APIError: Error, ReportableError {
    var detailed: String {
        switch self {
        case .malformedURL:
            return "The provided URL is malformed"
        }
    }

    case malformedURL
}

// MARK - An enum for handling API responses

public enum Result<DataType> {
    case success(DataType)
    case fail(Error)
}

protocol ReportableError {
    var detailed : String { get }
}
