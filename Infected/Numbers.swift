//
//  Numbers.swift
//  Infected
//
//  Created by marko on 10/25/20.
//

import Foundation

struct Numbers: Hashable {

    let date: Date
    let cases: Int?
    let hospitalizations: Int?
    let deaths: Int?

}

struct NationalNumbers: Hashable, Identifiable {

    static let id = -9999

    var id: Int {
        Self.id
    }

    let latest: Numbers
    let previous: Numbers
    let total: Numbers

}

struct ProvinceNumbers: Hashable, Identifiable {

    var id: Int {
        provinceCode
    }

    let provinceCode: Int
    let provinceName: String?
    let latest: Numbers
    let previous: Numbers
    let total: Numbers

}

struct MunicipalityNumbers: Hashable, Identifiable {

    var id: Int {
        municipalityCode
    }

    let municipalityCode: Int
    let municipalityName: String?
    let provinceCode: Int
    let provinceName: String?
    let latest: Numbers
    let previous: Numbers
    let total: Numbers

}

extension Numbers {

    static var demo: Numbers {
        Numbers(date: Date(), cases: 1234, hospitalizations: 567, deaths: 89)
    }

    static var random: Numbers {
        Numbers(date: Date(), cases: Int.random(in: 0...999999), hospitalizations: Int.random(in: 0...9999), deaths: Int.random(in: 0...999))
    }

}

extension NationalNumbers: Region {

    var name: String {
        NSLocalizedString("Netherlands", comment: "")
    }

    static var demo: NationalNumbers {
        NationalNumbers(latest: .demo, previous: .demo, total: .demo)
    }

    static var random: NationalNumbers {
        NationalNumbers(latest: .random, previous: .random, total: .random)
    }

}

extension ProvinceNumbers: Region {

    var name: String {
        provinceName ?? "Unknown"
    }

}

extension MunicipalityNumbers: Region {

    var name: String {
        [municipalityName ?? "Unknown", provinceName]
            .compactMap { $0 }
            .joined(separator: " | ")
    }

}

