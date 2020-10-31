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

    let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func latestNational() -> AnyPublisher<[NumbersDTO], Error> {
        numbers(forAreaKind: .national, date: nil)
    }

    func national(forDate date: Date) -> AnyPublisher<[NumbersDTO], Error> {
        numbers(forAreaKind: .national, date: date)
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
            .appendingPathComponent(["data", areaKind.rawValue].joined(separator: "-"))
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
