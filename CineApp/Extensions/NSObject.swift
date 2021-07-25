//
//  NSObject.swift
//  CineApp
//
//  Created by Alejandro Cruz on 25/07/2021.
//

import Foundation

public protocol Chainable {}
extension Chainable {
    @discardableResult public func with(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
    @discardableResult public func mutatingWith(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var value = self
        try block(&value)
        return value
    }
}

extension NSObject: Chainable {}
