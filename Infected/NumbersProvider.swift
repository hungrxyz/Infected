//
//  NumbersProvider.swift
//  Infected
//
//  Created by marko on 10/25/20.
//

import Combine

final class NumbersProvider {

    private var cancellables = Set<AnyCancellable>()

    @Published var national: NationalNumbers?

    let api: CoronaWatchNLAPI

    init(api: CoronaWatchNLAPI = CoronaWatchNLAPI()) {
        self.api = api
    }

    func reload() {
        var latestNumbers: Numbers!
        var totalNumbers: Numbers!

        api.latestNational()
            .handleEvents(receiveOutput: { dtos in
                latestNumbers = dtos.dailyNumbers
                totalNumbers = dtos.totalNumbers
            })
            .map(\.[0].date)


    }

}

private extension Array where Element == NumbersDTO {

    var dailyNumbers: Numbers {
        Numbers(
            date: self[0].date,
            cases: first(where: { $0.category == .cases })?.count,
            hospitalizations: first(where: { $0.category == .hospitalizations })?.count,
            deaths: first(where: { $0.category == .deaths })?.count
        )
    }

    var totalNumbers: Numbers {
        Numbers(
            date: self[0].date,
            cases: first(where: { $0.category == .cases })?.totalCount,
            hospitalizations: first(where: { $0.category == .hospitalizations })?.totalCount,
            deaths: first(where: { $0.category == .deaths })?.totalCount
        )
    }

}
