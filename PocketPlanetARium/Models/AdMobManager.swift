//
//  AdMobManager.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 4/18/24.
//  Copyright © 2024 Eddie Char. All rights reserved.
//

import GoogleMobileAds

class AdMobManager: NSObject {
    
    // MARK: - Properties
    
//    // FIXME: - Use correct ID when shipping App!
//    static let bannerAdUnitID = "ca-app-pub-3940256099942544/2435281174" //FOR TESTING ONLY!!! COMMENT OUT WHEN SHIPPING!
    static let bannerAdUnitID = "ca-app-pub-3047242308312153/5473167348" //THE REAL APPID. USE WHEN SHIPPING!!!

    static let shared = AdMobManager()
    private var bannerView: GADBannerView?
    
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
    }
    

    // MARK: - Functions
    
    func addBannerView(to viewController: UIViewController) {
        let viewWidth = viewController.view.frame.inset(by: viewController.view.safeAreaInsets).width
        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        
        bannerView = GADBannerView(adSize: adaptiveSize)
        bannerView!.adUnitID = AdMobManager.bannerAdUnitID
        bannerView!.load(GADRequest())
        bannerView!.rootViewController = viewController
        bannerView!.translatesAutoresizingMaskIntoConstraints = false
        bannerView!.delegate = self
        
        viewController.view.addSubview(bannerView!)
        
        NSLayoutConstraint.activate([
            bannerView!.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            viewController.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bannerView!.bottomAnchor)
        ])
    }
}


// MARK: - GADBannerViewDelegate

extension AdMobManager : GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
        
        bannerView.alpha = 0
        
        UIView.animate(withDuration: 2) {
            bannerView.alpha = 1
        }
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
