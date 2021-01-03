//
//  GroupedSummaries.swift
//  Infected
//
//  Created by marko on 12/3/20.
//

import Foundation

struct GroupedSummaries {

    let updatedAt: Date?
    let numbersDate: Date?
    let regions: [Summary]

    func sortedSummaries() -> [Summary] {
        regions.sorted(by: { $0.regionName < $1.regionName })
    }

}

extension GroupedSummaries: Decodable {}
