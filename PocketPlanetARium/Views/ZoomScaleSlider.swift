//
//  ZoomScaleSlider.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 2/10/24.
//  Copyright © 2024 Eddie Char. All rights reserved.
//

import UIKit

protocol ZoomScaleSliderDelegate: AnyObject {
    func zoomScaleSlider(_ controller: ZoomScaleSlider, didUpdateValue value: Float)
}


class ZoomScaleSlider: UISlider {
    
    // MARK: - Properties
    
    let sliderSize: CGSize = CGSize(width: K.screenSize.width / 2, height: 30)
    private let initialScale: Float
    private let minScale: Float
    private let maxScale: Float
    
    weak var delegate: ZoomScaleSliderDelegate?
    
    
    // MARK: - Initialization
    
    init(initialScale: Float, minScale: Float, maxScale: Float) {
        self.initialScale = initialScale.clamp(min: minScale, max: maxScale)
        self.minScale = minScale
        self.maxScale = maxScale

        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let sliderButton = UIImage(named: "neptuneButton")
        
        alpha = 0
        setThumbImage(sliderButton, for: .normal)
        minimumValue = minScale
        maximumValue = maxScale
        value = initialScale
        
        addTarget(self, action: #selector(didValueChange(_:)), for: .valueChanged)
    }
    
    
    // MARK: - Functions
    
    @objc private func didValueChange(_ sender: UISlider) {
        delegate?.zoomScaleSlider(self, didUpdateValue: self.value)
    }
    
    func updateValue(to value: Float) {
        self.value = value
    }
    

    func showSlider() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) { [unowned self] in
            alpha = 1
        }
    }
    
    func unshowSlider() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [unowned self] in
            alpha = 0
        }
    }
    
}
