//
//  CoronaWatchNLAPI.swift
//  Infected
//
//  Created by marko on 9/19/20.
//

import Foundation
import Combine

struct DailyNumbers: Decodable {

    let date: Date
    let diagnosed: Int
    let hospitalized: Int
    let deceased: Int
    let totalDiagnosed: Int
    let totalHospitalized: Int
    let totalDeceased: Int

}

extension DailyNumbers {

    enum CodingKeys: String, CodingKey {
        case date = "Datum"
        case diagnosed = "totaalAantal"
        case hospitalized = "ziekenhuisopnameAantal"
        case deceased = "overledenAantal"
        case totalDiagnosed = "totaalAantalCumulatief"
        case totalHospitalized = "ziekenhuisopnameAantalCumulatief"
        case totalDeceased = "overledenAantalCumulatief"
    }

}

final class CoronaWatchNLAPI: ObservableObject {

    @Published var latest: DailyNumbers?

    init() {
        load()
    }

    func load(completion: ((DailyNumbers) -> ())? = nil) {
        let url = URL(string: "https://raw.githubusercontent.com/J535D165/CoronaWatchNL/master/data-json/data-national/RIVM_NL_national_latest.json")!
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { (data, response, error) in

            struct Wrap: Decodable {
                let data: [DailyNumbers]
            }

            let decoder = JSONDecoder()


            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            let wrap = try! decoder.decode(Wrap.self, from: data!)

            DispatchQueue.main.async {
                self.latest = wrap.data.first

                completion?(wrap.data[0])
            }
            
        }.resume()
    }

}
