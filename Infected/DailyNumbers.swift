//
//  DailyNumbers.swift
//  Infected
//
//  Created by marko on 9/27/20.
//

import Foundation

struct DailyNumbers: Decodable {

    let date: Date
    let diagnosed: Int
    let hospitalized: Int
    let deceased: Int
    let totalDiagnosed: Int
    let totalHospitalized: Int
    let totalDeceased: Int

}

extension DailyNumbers {

    enum CodingKeys: String, CodingKey {
        case date = "Datum"
        case diagnosed = "totaalAantal"
        case hospitalized = "ziekenhuisopnameAantal"
        case deceased = "overledenAantal"
        case totalDiagnosed = "totaalAantalCumulatief"
        case totalHospitalized = "ziekenhuisopnameAantalCumulatief"
        case totalDeceased = "overledenAantalCumulatief"
    }

}

extension DailyNumbers {

    static var demo: DailyNumbers {
        DailyNumbers(date: Date(),
                     diagnosed: 123,
                     hospitalized: 45,
                     deceased: 6,
                     totalDiagnosed: 78901,
                     totalHospitalized: 2345,
                     totalDeceased: 678)
    }

}
