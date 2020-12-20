//
//  StoreReviewHandler.swift
//  Infected
//
//  Created by marko on 12/20/20.
//

import Foundation
import StoreKit

struct StoreReviewHandler {

    private static let openedAppCountKey = "openedAppCountKey"
    private static let lastVersionPromptedForReviewKey = "lastVersionPromptedForReviewKey"

    static func requestIfNeeded() {
        var count = UserDefaults.standard.integer(forKey: openedAppCountKey)
        count += 1
        UserDefaults.standard.set(count, forKey: openedAppCountKey)

        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String else {
            fatalError("Expected to find a bundle version in the info dictionary")
        }

        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: lastVersionPromptedForReviewKey)

        // Has the process been completed several times and the user has not already been prompted for this version?
        if count >= 4 && currentVersion != lastVersionPromptedForReview {
            let twoSecondsFromNow = DispatchTime.now() + 2.0
            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                SKStoreReviewController.requestReview(in: UIApplication.shared.connectedScenes.first as! UIWindowScene)
                UserDefaults.standard.set(currentVersion, forKey: lastVersionPromptedForReviewKey)
            }
        }
    }

}
