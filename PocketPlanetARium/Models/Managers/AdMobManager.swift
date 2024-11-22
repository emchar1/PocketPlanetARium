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
    
    //App ID's - for reference only; not used throughout codebase
    static let pocketPlanetARiumAppID = "ca-app-pub-9970112736079022~7992031190" //eddie@5playapps.com AdMob account
//    static let pocketPlanetARiumAppID = "ca-app-pub-3047242308312153~9726422919" //emchar1@gmail.com AdMob account
    
//    // FIXME: - Use correct ID when shipping App!
//    static let bannerAdUnitID = "ca-app-pub-3940256099942544/2435281174" //FOR TESTING ONLY!!! COMMENT OUT WHEN SHIPPING!
    static let bannerAdUnitID = "ca-app-pub-9970112736079022/9234968288" //THE REAL APPID. USE WHEN SHIPPING!!! eddie@5playapps.com AdMob account
//    static let bannerAdUnitID = "ca-app-pub-3047242308312153/5473167348" //emchar1@gmail.com AdMob account
    
    //Test Device ID's overrides live bannerAdUnitID - WARNING resets after app delete/re-install!!
    static let iPhoneEddie = "48d4202ba3bbd65d3884e80b608f49fd"
    static let iPhoneMom = "138b0379b6c2c7c354531fb710eed28b"
    static let iPhoneDad = "e8c42f1e27f2566573a17f824cf30607"
    static let iPadMom = "c8feec44cbd61277e0c9782bc2c78a56"
    static let iPadDad = "576bbe2cb0b7907743cc1d311df476c1"

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
