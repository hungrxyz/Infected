//
//  CoronaWatchNLAPI.swift
//  Infected
//
//  Created by marko on 9/19/20.
//

import Foundation
import Combine

final class CoronaWatchNLAPI: ObservableObject {

    @Published var latest: [DailyNumbers]

    init(latest: [DailyNumbers] = []) {
        self.latest = latest
        load()
    }

    func load(completion: (([DailyNumbers]) -> ())? = nil) {
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
                self.latest = wrap.data

                completion?(wrap.data)
            }
            
        }.resume()
    }

}
