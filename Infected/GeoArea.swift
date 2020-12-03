//
//  GeoArea.swift
//  Infected
//
//  Created by marko on 12/2/20.
//

import Foundation

enum GeoArea {

    case national
    case provincial
    case securityRegional
    case municipal

}

extension GeoArea {

    var localizedName: String {
        switch self {
        case .national:
            return NSLocalizedString("Netherlands", comment: "")
        case .provincial:
            return NSLocalizedString("Provinces", comment: "")
        case .securityRegional:
            return NSLocalizedString("Security Regions", comment: "")
        case .municipal:
            return NSLocalizedString("Municipalities", comment: "")
        }
    }

}
