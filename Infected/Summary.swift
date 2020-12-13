//
//  Summary.swift
//  Infected
//
//  Created by marko on 11/30/20.
//

import Foundation

struct Summary: Decodable {

    let updatedAt: Date?
    let numbersDate: Date?
    let regionCode: String
    let municupalityName: String?
    let provinceName: String?
    let securityRegionName: String?
    let positiveCases: SummaryNumbers
    let hospitalAdmissions: SummaryNumbers
    let hospitalOccupancy: Occupancy?
    let intensiveCareOccupancy: Occupancy?
    let deaths: SummaryNumbers

}

struct SummaryNumbers: Decodable {

    let new: Int?
    let trend: Int?
    let total: Int?

}

struct Occupancy: Decodable {

    let newAdmissions: Int?
    let newAdmissionsTrend: Int?
    let currentlyOccupied: Int?
    let currentlyOccupiedTrend: Int?

}

extension Summary {

    var regionName: String {
        if regionCode == "NL00" {
            return NSLocalizedString("Netherlands", comment: "")
        }
        switch String(regionCode.prefix(2)) {
        case "GM":
            return municupalityName ?? NSLocalizedString("Unlocated", comment: "")
        case "PV":
            return provinceName ?? NSLocalizedString("Unlocated", comment: "")
        case "VR":
            return securityRegionName ?? NSLocalizedString("Unlocated", comment: "")
        default:
            return NSLocalizedString("Unlocated", comment: "")
        }
    }

}

extension Summary: Identifiable {

    var id: String {
        regionCode
    }

}

#if DEBUG
extension Summary {
    static let demo = Summary(
        updatedAt: Date(),
        numbersDate: Date(),
        regionCode: "GM1234",
        municupalityName: "Municupality",
        provinceName: "Province",
        securityRegionName: "Security Region",
        positiveCases: SummaryNumbers(
            new: 3764,
            trend: 320,
            total: 329402
        ),
        hospitalAdmissions: SummaryNumbers(
            new: 85,
            trend: 0,
            total: 42304
        ),
        hospitalOccupancy: Occupancy(
            newAdmissions: 287,
            newAdmissionsTrend: 23,
            currentlyOccupied: 1842,
            currentlyOccupiedTrend: -38
        ),
        intensiveCareOccupancy: .demo,
        deaths: SummaryNumbers(
            new: 48,
            trend: -16,
            total: 8932
        )
    )
    static let random = Summary(
        updatedAt: Date(),
        numbersDate: Date(),
        regionCode: UUID().uuidString,
        municupalityName: UUID().uuidString,
        provinceName: UUID().uuidString,
        securityRegionName: UUID().uuidString,
        positiveCases: SummaryNumbers(
            new: Int.random(in: 0...99999),
            trend: Int.random(in: -99999...99999),
            total: Int.random(in: 0...999999999)
        ),
        hospitalAdmissions: SummaryNumbers(
            new: Int.random(in: 0...9999),
            trend: Int.random(in: -9999...9999),
            total: Int.random(in: 0...99999999)
        ),
        hospitalOccupancy: .random,
        intensiveCareOccupancy: .random,
        deaths: SummaryNumbers(
            new: Int.random(in: 0...999),
            trend: Int.random(in: -999...999),
            total: Int.random(in: 0...9999999)
        )
    )

}

extension SummaryNumbers {
    static let demo = SummaryNumbers(
        new: 3764,
        trend: 320,
        total: 329402
    )
    static let random = SummaryNumbers(
        new: Int.random(in: 0...99999),
        trend: Int.random(in: -99999...99999),
        total: Int.random(in: 0...999999999)
    )
}

extension Occupancy {
    static let demo = Occupancy(
        newAdmissions: 182,
        newAdmissionsTrend: 29,
        currentlyOccupied: 1489,
        currentlyOccupiedTrend: -48
    )
    static let random = Occupancy(
        newAdmissions: Int.random(in: 0...9999),
        newAdmissionsTrend: Int.random(in: 0...99999),
        currentlyOccupied: Int.random(in: 0...999999),
        currentlyOccupiedTrend: Int.random(in: 0...999)
    )
}
#endif

