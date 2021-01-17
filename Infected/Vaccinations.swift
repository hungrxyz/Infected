//
//  Vaccinations.swift
//  Infected
//
//  Created by marko on 1/16/21.
//

import Foundation

struct Vaccinations {

    let new: Int?
    let total: Int?
    let percentageOfPopulation: Float?

}

extension Vaccinations: Decodable {
}

#if DEBUG
extension Vaccinations {
    static let random = Vaccinations(
        new: Int.random(in: 1000...999999),
        total: Int.random(in: 10000...99999999),
        percentageOfPopulation: Float.random(in: 0.0...0.1)
    )
}
#endif
