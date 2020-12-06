//
//  WatchlistKeeper.swift
//  Infected
//
//  Created by marko on 12/5/20.
//

import Foundation

final class WatchlistKeeper {

    private static let listDefaultsKey = "watchlistRegionCodes"

    private var regionCodes: [String] {
        set {
            defaults.set(newValue, forKey: Self.listDefaultsKey)
        }
        get {
            if let codes = defaults.value(forKey: Self.listDefaultsKey) as? [String] {
                return codes
            } else {
                // By default National is the only region to watch.
                return ["NL00"]
            }
        }
    }

    private let defaults: UserDefaults
    init(defaults: UserDefaults = .infected) {
        self.defaults = defaults
    }

    func list() -> [String] {
        regionCodes
    }

    func add(regionCode: String) {
        var codes = regionCodes

        // Don't want to store duplicates.
        guard codes.contains(regionCode) == false else {
            return
        }

        codes.append(regionCode)
        regionCodes = codes
    }

    @discardableResult
    func replaceList(newRegionsCodes codes: [String]) -> [String] {
        regionCodes = codes
        return regionCodes
    }

    @discardableResult
    func remove(regionCode: String) -> [String] {
        var codes = regionCodes
        codes.removeAll { $0 == regionCode }

        regionCodes = codes
        return regionCodes
    }

    func isRegionOnWatchlist(regionCode: String) -> Bool {
        regionCodes.contains(regionCode)
    }

}
