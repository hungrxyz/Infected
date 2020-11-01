//
//  NumbersProvider.swift
//  Infected
//
//  Created by marko on 10/25/20.
//

import Foundation
import Combine

final class NumbersProvider: ObservableObject {

    private var cancellables = Set<AnyCancellable>()

    @Published var national: NationalNumbers?
    @Published var provincial: [ProvinceNumbers] = []

    let api: CoronaWatchNLAPI

    init(api: CoronaWatchNLAPI = CoronaWatchNLAPI()) {
        self.api = api
    }

    func reload() {
        var nationalLatest: Numbers!
        var nationalTotal: Numbers!

        api.latestNational()
            .filter { $0.isEmpty == false }
            .handleEvents(receiveOutput: { dtos in
                nationalLatest = dtos.nationalDailyNumbers()
                nationalTotal = dtos.nationalTotalNumbers()
            })
            .mappedToPreviousDayDate()
            .flatMap(api.national)
            .map { $0.nationalDailyNumbers }
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                print(completion, " => National")
            } receiveValue: { [weak self] previousLatestNumbers in
                self?.national = NationalNumbers(latest: nationalLatest,
                                                 previous: previousLatestNumbers(),
                                                 total: nationalTotal)
            }
            .store(in: &cancellables)

        var provincialDTOs = [NumbersDTO]()

        api.latestProvincial()
            .filter { $0.isEmpty == false }
            .handleEvents(receiveOutput: { dtos in
                provincialDTOs = dtos
            })
            .mappedToPreviousDayDate()
            .flatMap(api.provincial)
            .map { [weak self] cool in self?.mergeLatestAndPreviousProvincialDTOs(latest: provincialDTOs, previous: cool) ?? [] }
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                print(completion, " => Provincial")
            } receiveValue: { [weak self] numbers in
                self?.provincial = numbers
            }
            .store(in: &cancellables)

    }

}

private extension NumbersProvider {

    func mergeLatestAndPreviousProvincialDTOs(latest: [NumbersDTO], previous: [NumbersDTO]) -> [ProvinceNumbers] {
        var provincialNumbers = [ProvinceNumbers]()

        for provinceCode in Province.allProvinceCodes {
            guard
                let latestNumbers = latest.provinceNumbers(forProvinceCode: provinceCode),
                let previousNumbers = previous.provinceNumbers(forProvinceCode: provinceCode)
            else {
                continue
            }

            let numbers = ProvinceNumbers(
                provinceCode: provinceCode,
                provinceName: latestNumbers.provinceName,
                latest: latestNumbers.daily,
                previous: previousNumbers.daily,
                total: latestNumbers.total
            )

            provincialNumbers.append(numbers)
        }

        return provincialNumbers
    }

}

private extension Publisher where Output == [NumbersDTO] {

    func mappedToPreviousDayDate() -> AnyPublisher<Date, Self.Failure> {
        map(\.[0].date)
            .map { Calendar.current.date(byAdding: .day, value: -1, to: $0)! }
            .eraseToAnyPublisher()
    }

}

private extension Array where Element == NumbersDTO {

    func nationalDailyNumbers() -> Numbers {
        Numbers(
            date: self[0].date,
            cases: first(where: { $0.category == .cases })?.count,
            hospitalizations: first(where: { $0.category == .hospitalizations })?.count,
            deaths: first(where: { $0.category == .deaths })?.count
        )
    }

    func nationalTotalNumbers() -> Numbers {
        Numbers(
            date: self[0].date,
            cases: first(where: { $0.category == .cases })?.totalCount,
            hospitalizations: first(where: { $0.category == .hospitalizations })?.totalCount,
            deaths: first(where: { $0.category == .deaths })?.totalCount
        )
    }

    func provinceNumbers(forProvinceCode code: Int) -> (provinceName: String?, daily: Numbers, total: Numbers)? {
        let entries = filter { $0.provinceCode == code }
        guard entries.isEmpty == false else {
            return nil
        }

        let provinceName = entries.first?.provinceName

        let daily = Numbers(
            date: entries[0].date,
            cases: entries.first(where: { $0.category == .cases })?.count,
            hospitalizations: entries.first(where: { $0.category == .hospitalizations })?.count,
            deaths: entries.first(where: { $0.category == .deaths })?.count
        )

        let total = Numbers(
            date: entries[0].date,
            cases: entries.first(where: { $0.category == .cases })?.totalCount,
            hospitalizations: entries.first(where: { $0.category == .hospitalizations })?.totalCount,
            deaths: entries.first(where: { $0.category == .deaths })?.totalCount
        )

        return (provinceName, daily, total)
    }

}
