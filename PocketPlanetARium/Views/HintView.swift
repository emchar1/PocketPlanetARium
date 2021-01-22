//
//  HintsView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 11/28/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

enum IconAnimationType {
    case device, settings, planetTap, pinchZoom
}

class HintView: UIView {
    var superView: UIView!
    var hintViewSize: CGSize
    var messageViewSize: CGSize {
        return CGSize(width: hintViewSize.width, height: hintViewSize.height / 2)
    }
    var messageView = UIView()
    var messageLabel = UILabel()
    var imageView = UIImageView()
    var imageView2: UIImageView?
    
    var anchorToBottomRight: Bool = true
    var topAnchorConstraint: NSLayoutConstraint?
    var leadingAnchorConstraint: NSLayoutConstraint?
    var bottomAnchorConstraint: NSLayoutConstraint?
    var trailingAnchorConstraint: NSLayoutConstraint?
    var topAnchorConstant: CGFloat {
        CGFloat.random(in: 80...(superView.frame.height / 2))
    }
    var leadingAnchorConstant: CGFloat {
        CGFloat.random(in: 40...(superView.frame.width - max(hintViewSize.width, hintViewSize.height) - 40))
    }
    
    
    /**
     Initialize the hint with a size of 0.
     - parameter superView: the parent view that will display the HintsView
     */
    init(in superView: UIView, ofSize size: CGSize, anchorToBottomRight: Bool) {
        self.superView = superView
        self.hintViewSize = size
        self.anchorToBottomRight = anchorToBottomRight
        
        super.init(frame: .zero)
        superView.addSubview(self)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationDidChange(_:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
        //does this make sense to activate the constraints in the init?
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: hintViewSize.width),
                                     heightAnchor.constraint(equalToConstant: hintViewSize.height)])
        
        if anchorToBottomRight {
            bottomAnchorConstraint = superView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: K.padding)
            trailingAnchorConstraint = superView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 2 * K.padding + SettingsView.buttonSize)

            bottomAnchorConstraint!.isActive = true
            trailingAnchorConstraint!.isActive = true
        }
        else {
            topAnchorConstraint = topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor,
                                                       constant: topAnchorConstant)
            leadingAnchorConstraint = leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor,
                                                               constant: leadingAnchorConstant)

            topAnchorConstraint!.isActive = true
            leadingAnchorConstraint!.isActive = true
        }


    }
    
    required init?(coder: NSCoder) {
        fatalError("Unable to initialize HintsView object.")
    }
    

    /**
     Hint for the settings sprocket.
     - parameters:
        - size: size of the view
        - duration: duration time that the hint shows on screen
        - delay: delay time before showing the hint
     */
    func showHint(text: String,
                  image: String? = nil,
                  forDuration duration: TimeInterval,
                  withDelay delay: TimeInterval = 0,
                  iconAnimationType: IconAnimationType) {
        

            
        let messageColor = UIColor(rgb: 0x3498db)
        let messagePadding: CGFloat = 8
        messageView = UIView(frame: CGRect(x: messageViewSize.width / 2,
                                           y: messageViewSize.height / 2,
                                           width: 0,
                                           height: 0))
        messageView.layer.cornerRadius = 10
        messageView.backgroundColor = messageColor
        addSubview(messageView)

        messageLabel = UILabel(frame: .zero)
        messageLabel.text = text
        messageLabel.font = UIFont(name: "Futura", size: 16.0)
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageView.addSubview(messageLabel)
        
        
        if image != nil {
            let isPinch = image == "hintPinch"
            let imageSize: CGFloat = 50
            let imageSuperView = UIView(frame: CGRect(x: 0,
                                                      y: hintViewSize.height / 2,
                                                      width: hintViewSize.width,
                                                      height: hintViewSize.height / 2))
            addSubview(imageSuperView)
            
            guard let actualImage = UIImage(named: image!) else {
                fatalError("Unable to find image file: \(image!)")
            }
            
            imageView = UIImageView(frame: CGRect(x: hintViewSize.width - 2 * imageSize,
                                                  y: hintViewSize.height / 4 - imageSize / 2,
                                                  width: isPinch ? imageSize / 2 : imageSize,
                                                  height: isPinch ? imageSize / 2 : imageSize))
            
            imageView.image = actualImage.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = messageColor
            imageView.alpha = 0.0
            imageSuperView.addSubview(imageView)
            
            if isPinch {
                imageView2 = UIImageView(frame: CGRect(x: hintViewSize.width - 1 * imageSize,
                                                       y: hintViewSize.height / 4 + imageSize / 2,
                                                       width: imageSize / 2,
                                                       height: imageSize / 2))
                imageView2!.image = UIImage(named: "hintPinch2")!.withRenderingMode(.alwaysTemplate)
                imageView2!.tintColor = messageColor
                imageView2!.alpha = 0.0
                imageSuperView.addSubview(imageView2!)
            }
            
            //Animate the arrow
            animateIcon(ofType: iconAnimationType, withDelay: delay, frameSize: hintViewSize, imageSize: imageSize)
        }
        
        
        //Animate the message label. First, the expansion...
        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: { [unowned self] in
            
            messageView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: messageViewSize.width,
                                       height: messageViewSize.height)
            
            messageLabel.frame = CGRect(x: messagePadding,
                                        y: messagePadding,
                                        width: messageViewSize.width - 2 * messagePadding,
                                        height: messageViewSize.height - 2 * messagePadding)
            
            imageView.alpha = 1.0
            imageView2?.alpha = 1.0
            
        }, completion: { [unowned self] _ in
            hideHint(with: duration)
        })
        
    }
    
    /**
     Helper function to hide the hint.
     - parameter delay: delay before hiding the hint
     */
    private func hideHint(with delay: TimeInterval = 0) {
        //...Next the bigger quick expansion...
        UIView.animate(withDuration: 0.25, delay: delay, options: .curveEaseIn, animations: { [unowned self] in
            let overshoot: CGFloat = 16

            messageView.frame = CGRect(x: -overshoot / 2,
                                       y: -overshoot / 2,
                                       width: messageViewSize.width + overshoot,
                                       height: messageViewSize.height + overshoot)
            
        }, completion: { [unowned self] _ in
            imageView.removeFromSuperview()
            imageView2?.removeFromSuperview()
            
            //...Lastly, the contraction...
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseOut, animations: { [unowned self] in
                messageView.frame = CGRect(x: messageViewSize.width / 2,
                                           y: messageViewSize.height / 2,
                                           width: 0,
                                           height: 0)

                messageLabel.frame = .zero
            }, completion: { [unowned self] _ in
                
                //...And remove from view!
                messageView.removeFromSuperview()
            })
        })
    }
    
    /**
     Animates the imageView icon.
     - parameters:
        - type: the IconAnimationType
        - delay: the time delay before animating
        - size: size of the superView
        - imageSize: size of the imageView
     */
    private func animateIcon(ofType type: IconAnimationType, withDelay delay: TimeInterval, frameSize size: CGSize, imageSize: CGFloat) {
        switch type {
        case .device:
            UIView.animate(withDuration: 1.0, delay: delay, options: [.repeat, .curveLinear, .autoreverse], animations: { [unowned self] in
                imageView.frame.origin.x = size.width - 2.5 * imageSize
            }, completion: nil)
        case .settings:
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: [.repeat, .curveEaseIn, .autoreverse], animations: { [unowned self] in
                imageView.frame.origin.x = size.width - imageSize
            }, completion: nil)
        case .planetTap:
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: [.repeat, .curveEaseIn, .autoreverse], animations: { [unowned self] in
                imageView.frame.size.width *= 0.8
                imageView.frame.size.height *= 0.8
            }, completion: nil)
        case .pinchZoom:
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: [.repeat, .curveEaseIn, .autoreverse], animations: { [unowned self] in
                imageView.frame.origin = CGPoint(x: size.width - 1.75 * imageSize,
                                                 y: size.height / 4 - imageSize / 4)
                imageView2?.frame.origin = CGPoint(x: size.width - 1.25 * imageSize,
                                                   y: size.height / 4 + imageSize / 4)
            }, completion: nil)
        }
    }
    
    
    // MARK: - Device Orientation Changes
    
    /**
     Handles resizing of the view dimensions upon device orientation changes. Don't really need this I guess...?
     */
    @objc private func orientationDidChange(_ notification: NSNotification) {
        //Only need to reposition if settings are expanded and device orientation is portrait or landscape only.
        guard UIDevice.current.orientation.isValidInterfaceOrientation, !anchorToBottomRight else {
            return
        }
        
        topAnchorConstraint!.isActive = false
        leadingAnchorConstraint!.isActive = false

        if UIDevice.current.orientation.isLandscape {
            topAnchorConstraint = topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor,
                                                       constant: leadingAnchorConstant)
            leadingAnchorConstraint = leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor,
                                                               constant: topAnchorConstant)
        }
        else {
            topAnchorConstraint = topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor,
                                                       constant: topAnchorConstant)
            leadingAnchorConstraint = leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor,
                                                               constant: leadingAnchorConstant)
        }
        
        topAnchorConstraint!.isActive = true
        leadingAnchorConstraint!.isActive = true
    }
    
    
}
