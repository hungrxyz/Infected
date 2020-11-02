//
//  NumbersProvider.swift
//  Infected
//
//  Created by marko on 10/25/20.
//

import Foundation
import Combine
import WidgetKit

final class NumbersProvider: ObservableObject {

    private var cancellables = Set<AnyCancellable>()

    @Published var national: NationalNumbers?
    @Published var provincial: [ProvinceNumbers] = []
    @Published var municipal: [MunicipalityNumbers] = []

    let api: CoronaWatchNLAPI
    let widgetCenter: WidgetCenter

    init(api: CoronaWatchNLAPI = CoronaWatchNLAPI(),
         widgetCenter: WidgetCenter = .shared) {
        self.api = api
        self.widgetCenter = widgetCenter
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
                print(completion, "=> National")
            } receiveValue: { [weak self] previousLatestNumbers in
                self?.national = NationalNumbers(latest: nationalLatest,
                                                 previous: previousLatestNumbers(),
                                                 total: nationalTotal)

                self?.widgetCenter.reloadAllTimelines()
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
            .map { [weak self] previous in self?.mergeLatestAndPreviousProvincialDTOs(latest: provincialDTOs, previous: previous) ?? [] }
            .map { $0.sorted { $0.provinceName ?? "zzz" < $1.provinceName ?? "zzz" } }
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                print(completion, "=> Provincial")
            } receiveValue: { [weak self] numbers in
                self?.provincial = numbers
            }
            .store(in: &cancellables)

        var municipalDTOs = [NumbersDTO]()

        api.latestMunicipal()
            .filter { $0.isEmpty == false }
            .handleEvents(receiveOutput: { dtos in
                municipalDTOs = dtos
            })
            .mappedToPreviousDayDate()
            .flatMap(api.municipal)
            .map { [weak self] previous in self?.mergeLatestAndPreviousMunicipalDTOs(latest: municipalDTOs, previous: previous) ?? [] }
            .map { $0.sorted { $0.municipalityName ?? "zzz" < $1.municipalityName ?? "zzz" } }
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                print(completion, "=> Municipal")
            } receiveValue: { [weak self] numbers in
                self?.municipal = numbers
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

    func mergeLatestAndPreviousMunicipalDTOs(latest: [NumbersDTO], previous: [NumbersDTO]) -> [MunicipalityNumbers] {
        var municipalNumbers = [MunicipalityNumbers]()

        for municipalityCode in Municipality.allMunicipalityCodes {
            guard
                let latestNumbers = latest.municipalityNumbers(forMunicipalityCode: municipalityCode),
                let previousNumbers = previous.municipalityNumbers(forMunicipalityCode: municipalityCode)
            else {
                continue
            }

            let numbers = MunicipalityNumbers(
                municipalityCode: municipalityCode,
                municipalityName: latestNumbers.municipalityName,
                provinceCode: -999, // not important at the moment
                provinceName: latestNumbers.provinceName,
                latest: latestNumbers.daily,
                previous: previousNumbers.daily,
                total: latestNumbers.total
            )

            municipalNumbers.append(numbers)
        }

        return municipalNumbers
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

    func municipalityNumbers(forMunicipalityCode code: Int) -> (municipalityName: String?, provinceName: String?, daily: Numbers, total: Numbers)? {
        let entries = filter { $0.municipalityCode == code }
        guard entries.isEmpty == false else {
            return nil
        }

        let municipalityName = entries.first?.municipalityName
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

        return (municipalityName, provinceName, daily, total)
    }

}
