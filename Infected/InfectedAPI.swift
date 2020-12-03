//
//  InfectedAPI.swift
//  Infected
//
//  Created by marko on 11/30/20.
//

import Foundation
import Combine

final class InfectedAPI {

    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func national() -> AnyPublisher<Summary, Error> {
        let url = URL(string: "https://github.com/hungrxyz/infected-data/raw/main/data/latest/national.json")!

        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { error -> Error in return error }
            .decode(type: Summary.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }

    func provincialGroupedSummaries() -> AnyPublisher<GroupedSummaries, Error> {
        let url = URL(string: "https://github.com/hungrxyz/infected-data/raw/main/data/latest/provinces.json")!

        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { error -> Error in return error }
            .decode(type: GroupedSummaries.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }

    func securityRegionsGroupedSummaries() -> AnyPublisher<GroupedSummaries, Error> {
        let url = URL(string: "https://github.com/hungrxyz/infected-data/raw/main/data/latest/security_regions.json")!

        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { error -> Error in return error }
            .decode(type: GroupedSummaries.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }

    func municipalGroupedSummaries() -> AnyPublisher<GroupedSummaries, Error> {
        let url = URL(string: "https://github.com/hungrxyz/infected-data/raw/main/data/latest/municipalities.json")!

        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { error -> Error in return error }
            .decode(type: GroupedSummaries.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }

}
