//
//  UserDefaults+Infected.swift
//  Infected
//
//  Created by marko on 12/6/20.
//

import Foundation

extension UserDefaults {

    static let infected: UserDefaults = {
        guard let appGroupIdentifier = Bundle.main.infoDictionary?["AppGroupIdentifier"] as? String else {
            fatalError("App Group Identifier missing in Info.plist.")
        }
        guard let defaults = UserDefaults(suiteName: appGroupIdentifier) else {
            fatalError("User Defaults not accessible with provided app group identifier.")
        }
        return defaults
    }()

}
