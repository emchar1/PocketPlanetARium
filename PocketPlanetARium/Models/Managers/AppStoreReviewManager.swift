//
//  AppStoreReviewManager.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 1/21/21.
//  Copyright © 2021 Eddie Char. All rights reserved.
//

import StoreKit

enum AppStoreReviewManager {
    //Declare a constant value to specify the number of times that user must perform a review-worthy action.
    static let minimumReviewWorthyActionCount = 3
    
    static func requestReviewIfAppropriate() {
        let defaults = UserDefaults.standard
        let bundle = Bundle.main
        
        //Read the current number of actions that the user has performed since the last requested review from the User Defaults.
        var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)
        actionCount += 1
        
        //Set the incremented count back into the user defaults for the next time that you trigger the function.
        defaults.set(actionCount, forKey: .reviewWorthyActionCount)
        
        //Check if the action count has now exceeded the minimum threshold to trigger a review. If it hasn’t, the function will now return.
        guard actionCount >= minimumReviewWorthyActionCount else {
            return
        }
        
        //Read the current bundle version and the last bundle version used during the last prompt (if any).
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)
        
        //Check if this is the first request for this version of the app before continuing.
        guard lastVersion == nil || lastVersion != currentVersion else {
            return
        }
        
        //Ask StoreKit to request a review.
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
        
        //Reset the action count and store the current version in User Defaults so that you don’t request again on this version of the app.
        defaults.set(0, forKey: .reviewWorthyActionCount)
        defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
    }
}

