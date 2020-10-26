//
//  CoronaWatchNLAPI.swift
//  Infected
//
//  Created by marko on 9/19/20.
//

import Foundation
import Combine
import CodableCSV

final class CoronaWatchNLAPI: ObservableObject {

    private var cancellables = Set<AnyCancellable>()

    @Published var latestNumbers: LatestNumbers?

    let urlSession: URLSession

    init(urlSession: URLSession = .shared,
         latestNumbers: LatestNumbers? = nil) {
        self.urlSession = urlSession
        self.latestNumbers = latestNumbers

        load().sink { _ in } receiveValue: { _ in }.store(in: &cancellables)
    }

    func latestNational() -> AnyPublisher<[NumbersDTO], Error> {
        numbers(forAreaKind: .national, date: nil)
    }

    func national(forDate date: Date) -> AnyPublisher<[NumbersDTO], Error> {
        numbers(forAreaKind: .national, date: date)
    }

    func load() -> AnyPublisher<LatestNumbers, Error> {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let fileNameDateFormatter = DateFormatter()
        fileNameDateFormatter.dateFormat = "yyyyMMdd"

        let decoder = CSVDecoder()
        decoder.headerStrategy = .firstLine
        decoder.dateStrategy = .formatted(dateFormatter)

        var latestEntries: [Entry]!

        let latestURL = URL(string: "https://raw.githubusercontent.com/J535D165/CoronaWatchNL/master/data-geo/data-national/RIVM_NL_national_latest.csv")!

        return urlSession.dataTaskPublisher(for: latestURL)
            .map(\.data)
            .decode(type: [Entry].self, decoder: decoder)
            .handleEvents(receiveOutput: { latestEntries = $0 })
            .map(\.[0].date)
            .map { date -> URL in
                let previousDayDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
                let previousDayFilename = "RIVM_NL_national_\(fileNameDateFormatter.string(from: previousDayDate)).csv"
                let previousDayURL = URL(string: "https://raw.githubusercontent.com/J535D165/CoronaWatchNL/master/data-geo/data-national/\(previousDayFilename)")!

                return previousDayURL
            }
            .mapError { _ in fatalError() }
            .flatMap { url in
                return self.urlSession.dataTaskPublisher(for: url)
            }
            .map(\.data)
            .decode(type: [Entry].self, decoder: decoder)
            .map { previousDayEntries -> LatestNumbers in
                let cases = latestEntries.first(where: { $0.category == .cases })?.count
                let hospitalizations = latestEntries.first(where: { $0.category == .hospitalizations })?.count
                let deaths = latestEntries.first(where: { $0.category == .deaths })?.count
                let previousDayCases = previousDayEntries.first(where: { $0.category == .cases })?.count
                let previousDayHospitalizations = previousDayEntries.first(where: { $0.category == .hospitalizations })?.count
                let previousDayDeaths = previousDayEntries.first(where: { $0.category == .deaths })?.count
                let totalCases = latestEntries.first(where: { $0.category == .cases })?.totalCount
                let totalHospitalizations = latestEntries.first(where: { $0.category == .hospitalizations })?.totalCount
                let totalDeaths = latestEntries.first(where: { $0.category == .deaths })?.totalCount

                return LatestNumbers(
                    date: latestEntries[0].date,
                    cases: cases,
                    hospitalizations: hospitalizations,
                    deaths: deaths,
                    previousDayCases: previousDayCases,
                    previousDayHospitalizations: previousDayHospitalizations,
                    previousDayDeaths: previousDayDeaths,
                    totalCases: totalCases,
                    totalHospitalizations: totalHospitalizations,
                    totalDeaths: totalDeaths
                )
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { self.latestNumbers = $0 })
            .eraseToAnyPublisher()

    }

}

private extension CoronaWatchNLAPI {

    func numbers(forAreaKind areaKind: AreaKind, date: Date?) -> AnyPublisher<[NumbersDTO], Error> {
        let baseURL = URL(string: "https://raw.githubusercontent.com/J535D165/CoronaWatchNL/master/data-geo/")!

        let fileNameDateFormatter = DateFormatter()
        fileNameDateFormatter.dateFormat = "yyyyMMdd"

        let filenameDate = date.flatMap(fileNameDateFormatter.string) ?? "latest"
        let filename = ["RIVM_NL", areaKind.rawValue, filenameDate]
            .joined(separator: "_")
            .appending(".csv")

        let url = baseURL
            .appendingPathComponent(areaKind.rawValue)
            .appendingPathComponent(filename)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let decoder = CSVDecoder()
        decoder.headerStrategy = .firstLine
        decoder.dateStrategy = .formatted(dateFormatter)

        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [NumbersDTO].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

private enum AreaKind: String {

    case national
    case provincial
    case municipal

}

private extension CoronaWatchNLAPI {

    struct Entry: Decodable {
        let date: Date
        let category: Category
        let count: Int
        let totalCount: Int

        enum CodingKeys: String, CodingKey {
            case date = "Datum"
            case category = "Type"
            case count = "Aantal"
            case totalCount = "AantalCumulatief"
        }
    }

    enum Category: String, Decodable {
        case cases = "Totaal"
        case hospitalizations = "Ziekenhuisopname"
        case deaths = "Overleden"
    }

}
