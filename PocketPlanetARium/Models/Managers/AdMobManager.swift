//
//  AdMobManager.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 4/18/24.
//  Copyright © 2024 Eddie Char. All rights reserved.
//

import GoogleMobileAds
import AppTrackingTransparency

class AdMobManager: NSObject {
    
    // MARK: - Properties
    
//    // FIXME: - Use correct ID when shipping App!
//    static let bannerAdUnitID = "ca-app-pub-3940256099942544/2435281174" //FOR TESTING ONLY!!! COMMENT OUT WHEN SHIPPING!
    static let bannerAdUnitID = "ca-app-pub-9970112736079022/9234968288" //THE REAL APPID. USE WHEN SHIPPING!!!
    
    //Test Device ID's
//    static let iPhoneEddie = "3e6fb037c3803580c0f3fa7d30fce576" //Eddie's iPhone 14 Pro
//    static let iPhoneEddie = "8efe992acf0ecea7399f5ab50a5901e7" //Eddie's phone as of 4/25/24 (why did it change??)
    static let iPhoneEddie = "f54e34ece3899dee7681b0d2d9e070bd" //Eddie's phone as of 6/19/24 (it changed again?!?!)

    static let shared = AdMobManager()
    private(set) var bannerView: GADBannerView?
    
    
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
    
    @available(iOS 14, *)
    func requestIDFAPermission() {
        guard checkForIDFAPermission() == .notDetermined else { return print("   AdMobManager.requestIDFAPermission() status: !(.notDetermined), exiting...") }
        
        ATTrackingManager.requestTrackingAuthorization { _ in
            print("   AdMobManager.requestIDFAPermission() status: .notDetermined, requesting access...")
        }
    }
    
    @available(iOS 14, *)
    @discardableResult func checkForIDFAPermission() -> ATTrackingManager.AuthorizationStatus {
        let status = ATTrackingManager.trackingAuthorizationStatus
        
        switch status {
        case .authorized:
            print("AdMobManager.checkForIDFAPermission() status: .authorized")
        case .denied:
            print("AdMobManager.checkForIDFAPermission() status: .denied")
        case .restricted:
            print("AdMobManager.checkForIDFAPermission() status: .restricted")
        case .notDetermined:
            print("AdMobManager.checkForIDFAPermission() status: .notDetermined")
        @unknown default:
            print("AdMobManager.checkForIDFAPermission() status: @unknown")
        }
        
        return status
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
        print("Error: \(error)")
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
