//
//  NumberRepresentation.swift
//  Infected
//
//  Created by marko on 10/31/20.
//

import Foundation

enum NumberRepresentation {

    case cases
    case hospitalizations
    case deaths

}

extension NumberRepresentation {

    var displayName: String {
        switch self {
        case .cases:
            return "Cases"
        case .hospitalizations:
            return "Hospitalizations"
        case .deaths:
            return "Deaths"
        }
    }

    var symbolName: String {
        switch self {
        case .cases:
            return "folder.fill.badge.plus"
        case .hospitalizations:
            return "cross.case.fill"
        case .deaths:
            return "heart.broken.fill"
        }
    }

}
