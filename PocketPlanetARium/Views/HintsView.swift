//
//  HintsView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 11/28/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

enum IconAnimationType {
    case settings, planetTap, pinchZoom
}

class HintsView: UIView {
    var superView: UIView!
    var messageViewSize: CGSize = .zero
    var messageView = UIView()
    var messageLabel = UILabel()
    var imageView = UIImageView()
    var imageView2: UIImageView?

    
    /**
     Initialize the hint with a size of 0.
     - parameter superView: the parent view that will display the HintsView
     */
    init(in superView: UIView) {
        self.superView = superView
        super.init(frame: .zero)
        superView.addSubview(self)
        
//        backgroundColor = .blue
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
                  ofSize size: CGSize,
                  anchorToBottomRight: Bool = true,
                  forDuration duration: TimeInterval,
                  withDelay delay: TimeInterval = 0,
                  iconAnimationType: IconAnimationType) {
        
        translatesAutoresizingMaskIntoConstraints = false

        if anchorToBottomRight {
            NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: size.width),
                                         heightAnchor.constraint(equalToConstant: size.height),
                                         superView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 2 * K.padding + SettingsView.buttonSize),
                                         superView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: K.padding)])
        }
        else {
            let topAnchorConstant = CGFloat.random(in: 80...(superView.frame.height / 2))
            let leadingAnchorConstant = CGFloat.random(in: 40...(superView.frame.width - size.width - 40))
            
            NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: size.width),
                                         heightAnchor.constraint(equalToConstant: size.height),
                                         topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: topAnchorConstant),
                                         leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor, constant: leadingAnchorConstant)])

            print("top: \(topAnchorConstant), leading: \(leadingAnchorConstant)")
        }
            
        let messageColor = UIColor(rgb: 0x3498db)
        let messagePadding: CGFloat = 8
        messageViewSize = CGSize(width: size.width, height: size.height / 2)
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
                                                      y: size.height / 2,
                                                      width: size.width,
                                                      height: size.height / 2))
//            imageSuperView.backgroundColor = .orange
            addSubview(imageSuperView)
            
            guard var actualImage = UIImage(named: image!) else {
                fatalError("Unable to find image file: \(image!)")
            }
            
            if isPinch {
                actualImage = actualImage.rotate(radians: 3 * .pi / 4)
            }
            
            imageView = UIImageView(frame: CGRect(x: size.width - (isPinch ? 2.5 : 2) * imageSize,
                                                  y: size.height / 4 - imageSize / 2,
                                                  width: imageSize,
                                                  height: imageSize))
            
            imageView.image = actualImage.withRenderingMode(.alwaysTemplate)
//            imageView.backgroundColor = .systemPink
            imageView.tintColor = messageColor
            imageView.alpha = 0.0
            imageSuperView.addSubview(imageView)
            
            if isPinch {
                actualImage = actualImage.rotate(radians: .pi)

                imageView2 = UIImageView(frame: CGRect(x: size.width - imageSize,
                                                       y: size.height / 4 + imageSize / 2,
                                                       width: imageSize,
                                                       height: imageSize))
                imageView2!.image = actualImage.withRenderingMode(.alwaysTemplate)
                imageView2!.tintColor = messageColor
                imageView2!.alpha = 0.0
                imageSuperView.addSubview(imageView2!)
            }
            
            //Animate the arrow
            animateIcon(ofType: iconAnimationType, withDelay: delay, frameSize: size, imageSize: imageSize)
        }
        
        
        //Animate the message label. First, the expansion...
        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: { [self] in
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
            
        }, completion: { [self] _ in
            hideHint(with: duration)
        })
        
    }
    
    private func hideHint(with delay: TimeInterval = 0) {
        //...Next the bigger quick expansion...
        UIView.animate(withDuration: 0.25, delay: delay, options: .curveEaseIn, animations: { [self] in
            let overshoot: CGFloat = 16

            messageView.frame = CGRect(x: -overshoot / 2,
                                       y: -overshoot / 2,
                                       width: messageViewSize.width + overshoot,
                                       height: messageViewSize.height + overshoot)
            
        }, completion: { [self] _ in
            imageView.removeFromSuperview()
            imageView2?.removeFromSuperview()
            
            //...Lastly, the contraction...
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseOut, animations: { [self] in
                messageView.frame = CGRect(x: messageViewSize.width / 2,
                                           y: messageViewSize.height / 2,
                                           width: 0,
                                           height: 0)

                messageLabel.frame = .zero
            }, completion: { [self] _ in
                
                //...And remove from view!
                messageView.removeFromSuperview()
            })
        })
    }
    
    private func animateIcon(ofType type: IconAnimationType, withDelay delay: TimeInterval, frameSize size: CGSize, imageSize: CGFloat) {
        switch type {
        case .settings:
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: [.repeat, .curveEaseIn, .autoreverse], animations: { [self] in
                imageView.frame.origin.x = size.width - imageSize
            }, completion: nil)
        case .planetTap:
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: [.repeat, .curveEaseIn, .autoreverse], animations: { [self] in
                imageView.frame.size.width *= 0.8
                imageView.frame.size.height *= 0.8
            }, completion: nil)
        case .pinchZoom:
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: [.repeat, .curveEaseIn, .autoreverse], animations: { [self] in
                imageView.frame.origin = CGPoint(x: size.width - 2.25 * imageSize,
                                                 y: size.height / 4 - imageSize / 4)
                imageView2?.frame.origin = CGPoint(x: size.width - 1.275 * imageSize,
                                                   y: size.height / 4 + imageSize / 4)
            }, completion: nil)
        }
    }
}
