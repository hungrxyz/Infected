//
//  Number.swift
//  Infected
//
//  Created by marko on 7/21/21.
//

import Foundation

enum Number {
    case integer(Int)
    case decimal(Float)

    var intValue: Int {
        switch self {
        case let .integer(value):
            return value
        case let .decimal(value):
            return Int(value)
        }
    }

    var floatValue: Float {
        switch self {
        case let .integer(value):
            return Float(value)
        case let .decimal(value):
            return value
        }
    }
}
