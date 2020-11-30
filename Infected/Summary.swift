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
    let regionCode: String?
    let municupalityName: String?
    let provinceName: String?
    let securityRegionName: String?
    let positiveCases: SummaryNumbers
    let hospitalAdmissions: SummaryNumbers
    let deaths: SummaryNumbers

}

struct SummaryNumbers: Decodable {

    let new: Int?
    let trend: Int?
    let total: Int?

}

extension Summary: Region {

    var id: Int {
        00
    }

    var name: String {
        NSLocalizedString("Netherlands", comment: "")
    }

    var latest: Numbers {
        Numbers(date: updatedAt!, cases: positiveCases.new, hospitalizations: hospitalAdmissions.new, deaths: deaths.new)
    }

    var previous: Numbers {
        Numbers(date: updatedAt!, cases: positiveCases.trend, hospitalizations: hospitalAdmissions.trend, deaths: deaths.trend)
    }

    var total: Numbers {
        Numbers(date: updatedAt!, cases: positiveCases.total, hospitalizations: hospitalAdmissions.total, deaths: deaths.total)
    }

}

#if DEBUG
extension Summary {
    static let demo = Summary(
        updatedAt: Date(),
        numbersDate: Date(),
        regionCode: "Code",
        municupalityName: "Muni",
        provinceName: "Provi",
        securityRegionName: "Sec Reg",
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
        deaths: SummaryNumbers(
            new: Int.random(in: 0...999),
            trend: Int.random(in: -999...999),
            total: Int.random(in: 0...9999999)
        )
    )

}
#endif

