//
//  WhatsNewOperator.swift
//  Infected
//
//  Created by marko on 8/8/21.
//

import Foundation

struct WhatsNewOperator {

    private static let lastShownBuildNumberKey = "whatsNewLastShownBuildNumberKey"

    static func shouldShowWhatsNew() -> Bool {
        let userDefaults = UserDefaults.standard

        let buildNumberString = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        guard let currentBuildNumber = buildNumberString.flatMap(Int.init) else {
            fatalError("Expected to find a bundle version in the info dictionary")
        }

        guard let lastBuildNumber = userDefaults.object(forKey: lastShownBuildNumberKey) as? Int else {
            // No last build number. Must be fresh install.
            // 1. Setting current build number as last build number,
            userDefaults.setValue(currentBuildNumber, forKey: lastShownBuildNumberKey)

            // 2. indicating to show what's new.
            return true
        }

        guard currentBuildNumber > lastBuildNumber else {
            // Nothing new to show
            return false
        }

        // What's new was not shown yet for this version.
        userDefaults.setValue(currentBuildNumber, forKey: lastShownBuildNumberKey)

        return true
    }

}
