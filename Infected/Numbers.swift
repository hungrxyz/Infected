//
//  Numbers.swift
//  Infected
//
//  Created by marko on 10/25/20.
//

import Foundation

struct Numbers {

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

struct ProvincialNumbers {

    let provinceCode: Int
    let provinceName: String
    let latest: Numbers
    let previous: Numbers
    let total: Numbers

}

struct MunicipalNumbers {

    let municipalCode: Int
    let municipalityName: String
    let provinceCode: Int
    let provinceName: String
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
        Numbers(date: Date(), cases: 123456, hospitalizations: 78, deaths: 9)
    }

}

extension NationalNumbers: Area {

    var name: String {
        "Netherlands"
    }

    static var demo: NationalNumbers {
        NationalNumbers(latest: .demo, previous: .demo, total: .demo)
    }

}

extension ProvincialNumbers: Area {

    var name: String {
        provinceName
    }

}

extension MunicipalNumbers: Area {

    var name: String {
        [municipalityName, provinceName].joined(separator: ", ")
    }

}

