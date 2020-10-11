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

    @Published var latestNumbers: LatestNumbers?

    init(latestNumbers: LatestNumbers? = nil) {
        self.latestNumbers = latestNumbers
        load()
    }

    func load(completion: ((LatestNumbers) -> ())? = nil) {

        DispatchQueue.global(qos: .userInitiated).async {
            let group = DispatchGroup()

            var latestEntries: [Entry]!
            var previousDayEntries: [Entry]!

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            let decoder = CSVDecoder()
            decoder.headerStrategy = .firstLine
            decoder.dateStrategy = .formatted(dateFormatter)

            group.enter()

            let latestURL = URL(string: "https://raw.githubusercontent.com/J535D165/CoronaWatchNL/master/data-geo/data-national/RIVM_NL_national_latest.csv")!
            URLSession.shared.dataTask(with: latestURL) { (data, _, _) in

                latestEntries = try! decoder.decode([Entry].self, from: data!)

                group.leave()
            }.resume()

            group.wait()

            group.enter()

            let fileNameDateFormatter = DateFormatter()
            fileNameDateFormatter.dateFormat = "yyyyMMdd"

            let latestDate = latestEntries[0].date
            let previousDayDate = Calendar.current.date(byAdding: .day, value: -1, to: latestDate)!

            let previousDayFilename = "RIVM_NL_national_\(fileNameDateFormatter.string(from: previousDayDate)).csv"

            let previousDayURL = URL(string: "https://raw.githubusercontent.com/J535D165/CoronaWatchNL/master/data-geo/data-national/\(previousDayFilename)")!
            URLSession.shared.dataTask(with: previousDayURL) { (data, _, _) in

                previousDayEntries = try! decoder.decode([Entry].self, from: data!)

                group.leave()
            }.resume()

            group.wait()

            group.enter()

            let latestNumbers = LatestNumbers(
                date: latestDate,
                cases: latestEntries.first(where: { $0.category == .cases })?.count,
                hospitalizations: latestEntries.first(where: { $0.category == .hospitalizations })?.count,
                deaths: latestEntries.first(where: { $0.category == .deaths })?.count,
                previousDayCases: previousDayEntries.first(where: { $0.category == .cases })?.count,
                previousDayHospitalizations: previousDayEntries.first(where: { $0.category == .hospitalizations })?.count,
                previousDayDeaths: previousDayEntries.first(where: { $0.category == .deaths })?.count,
                totalCases: latestEntries.first(where: { $0.category == .cases })?.totalCount,
                totalHospitalizations: latestEntries.first(where: { $0.category == .hospitalizations })?.totalCount,
                totalDeaths: latestEntries.first(where: { $0.category == .deaths })?.totalCount
            )

            group.leave()

            group.notify(queue: .main) {
                self.latestNumbers = latestNumbers

                completion?(latestNumbers)
            }


        }

    }

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

