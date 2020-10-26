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
