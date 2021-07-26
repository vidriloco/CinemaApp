//
//  Result.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import Foundation

public extension Result {

    func map<U>(_ transform: (DataType) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let val):
            return transform(val)
        case .fail(let e):
            return .fail(e)
        }
    }

    func transform<U>(_ transformer: (DataType) throws -> Result<U>) -> Result<U> {
        switch self {
        case .success(let val):
            do {
                return try transformer(val)
            } catch {
                return .fail(error)
            }
        case .fail(let e):
            return .fail(e)
        }
    }
}
