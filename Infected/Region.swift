//
//  Region.swift
//  Infected
//
//  Created by marko on 11/4/20.
//

import Foundation

protocol Region {

    var id: Int { get }
    var name: String { get }
    var latest: Numbers { get }
    var previous: Numbers { get }
    var total: Numbers { get }
    var casesDifferenceToPreviousDay: Int? { get }
    var hospitalizationsDifferenceToPreviousDay: Int? { get }
    var deathsDifferenceToPreviousDay: Int? { get }

}

extension Region {

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
