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
        numbers(forRegions: .national, date: nil)
    }

    func national(forDate date: Date) -> AnyPublisher<[NumbersDTO], Error> {
        numbers(forRegions: .national, date: date)
    }

    func latestProvincial() -> AnyPublisher<[NumbersDTO], Error> {
        numbers(forRegions: .provincial, date: nil)
    }

    func provincial(forDate date: Date) -> AnyPublisher<[NumbersDTO], Error> {
        numbers(forRegions: .provincial, date: date)
    }

    func latestMunicipal() -> AnyPublisher<[NumbersDTO], Error> {
        numbers(forRegions: .municipal, date: nil)
    }

    func municipal(forDate date: Date) -> AnyPublisher<[NumbersDTO], Error> {
        numbers(forRegions: .municipal, date: date)
    }

}

private extension CoronaWatchNLAPI {

    func numbers(forRegions regions: Regions, date: Date?) -> AnyPublisher<[NumbersDTO], Error> {
        let baseURL = URL(string: "https://raw.githubusercontent.com/J535D165/CoronaWatchNL/master/data-geo/")!

        let fileNameDateFormatter = DateFormatter()
        fileNameDateFormatter.dateFormat = "yyyyMMdd"

        let filenameDate = date.flatMap(fileNameDateFormatter.string) ?? "latest"
        let filename = ["RIVM_NL", regions.rawValue, filenameDate]
            .joined(separator: "_")
            .appending(".csv")

        let url = baseURL
            .appendingPathComponent(["data", regions.rawValue].joined(separator: "-"))
            .appendingPathComponent(filename)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let decoder = CSVDecoder()
        decoder.headerStrategy = .firstLine
        decoder.dateStrategy = .formatted(dateFormatter)

        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [NumbersDTO].self, decoder: decoder)
            .eraseToAnyPublisher()
    }

}

private enum Regions: String {

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
        let municipalityCode: Int?
        let municipalityName: String?
        let provinceCode: Int?
        let provinceName: String?

        enum CodingKeys: String, CodingKey {
            case date = "Datum"
            case category = "Type"
            case count = "Aantal"
            case totalCount = "AantalCumulatief"
            case municipalityCode = "Gemeentecode"
            case municipalityName = "Gemeentenaam"
            case provinceCode = "Provinciecode"
            case provinceName = "Provincienaam"
        }
    }

    enum Category: String, Decodable {
        case cases = "Totaal"
        case hospitalizations = "Ziekenhuisopname"
        case deaths = "Overleden"
    }

}
