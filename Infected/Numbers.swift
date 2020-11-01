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

struct NationalNumbers {

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

protocol Area {

    var name: String { get }
    var latest: Numbers { get }
    var previous: Numbers { get }
    var total: Numbers { get }
    var casesDifferenceToPreviousDay: Int? { get }
    var hospitalizationsDifferenceToPreviousDay: Int? { get }
    var deathsDifferenceToPreviousDay: Int? { get }

}

extension Area {

    var casesDifferenceToPreviousDay: Int? {
        guard
            let cases = latest.cases,
            let previousCases = previous.cases
        else {
            return nil
        }
        return cases - previousCases
    }

    var hospitalizationsDifferenceToPreviousDay: Int? {
        guard
            let hospitalizations = latest.hospitalizations,
            let previousHospitalizations = previous.hospitalizations
        else {
            return nil
        }
        return hospitalizations - previousHospitalizations
    }

    var deathsDifferenceToPreviousDay: Int? {
        guard
            let deaths = latest.deaths,
            let previousDeaths = previous.deaths
        else {
            return nil
        }
        return deaths - previousDeaths
    }

}

extension Numbers {

    static var demo: Numbers {
        Numbers(date: Date(), cases: 1234, hospitalizations: 567, deaths: 89)
    }

    static var random: Numbers {
        Numbers(date: Date(), cases: Int.random(in: 0...999999), hospitalizations: Int.random(in: 0...9999), deaths: Int.random(in: 0...999))
    }

}

extension NationalNumbers: Area {

    var name: String {
        "Netherlands"
    }

    static var demo: NationalNumbers {
        NationalNumbers(latest: .demo, previous: .demo, total: .demo)
    }

    static var random: NationalNumbers {
        NationalNumbers(latest: .random, previous: .random, total: .random)
    }

}

extension ProvinceNumbers: Area {

    var name: String {
        provinceName ?? "Unknown"
    }

}

extension MunicipalityNumbers: Area {

    var name: String {
        [municipalityName ?? "Unknown", provinceName]
            .compactMap { $0 }
            .joined(separator: " | ")
    }

}

