//
//  BezelView.swift
//  PocketPlanetARium
//
//  Created by Eddie Char on 10/15/20.
//  Copyright © 2020 Eddie Char. All rights reserved.
//

import UIKit

class MenuContent: UIView {
    
    var stackView: UIStackView!
//    var videoView: UIImageView!
//    var contentLabel: UILabel!
//    var goButton: UIButton?
//    
//    var menuItem: MenuItem

        
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor(named: K.color300) ?? .gray
        layer.cornerRadius = 16
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: K.padding),
                                     stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: K.padding),
                                     stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -K.padding),
                                     stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -K.padding)])
        
        let view1 = UIView()
        view1.backgroundColor = .blue
        stackView.addArrangedSubview(view1)
        let view2 = UIView()
        view2.backgroundColor = .green
        stackView.addArrangedSubview(view2)

//        view1.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([view1.leadingAnchor.constraint(equalTo: stackView!.arrangedSubviews[0].leadingAnchor),
//                                     view1.trailingAnchor.constraint(equalTo: stackView!.arrangedSubviews[0].trailingAnchor),
//                                     view1.topAnchor.constraint(equalTo: stackView!.arrangedSubviews[0].topAnchor),
//                                     view1.bottomAnchor.constraint(equalTo: stackView!.arrangedSubviews[0].bottomAnchor)])

        /*
        videoView = UIImageView(frame: CGRect(x: K.padding, y: K.padding, width: view1.frame.width, height: view1.frame.width))
        videoView!.backgroundColor = .black
        videoView!.image = UIImage(named: "art.scnassets/neptune.jpg")
//        videoView!.layer.shadowRadius = 4
//        videoView!.layer.shadowOpacity = 0.2
//        videoView!.layer.shadowOffset = .zero
//        videoView!.layer.shadowColor = UIColor.white.cgColor
//        view.addSubview(videoView!)

        contentLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bezelView!.frame.width - 2 * K.padding, height: 200))
//        contentLabel!.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        contentLabel!.textAlignment = .justified
        contentLabel!.font = UIFont(name: K.fontFace, size: K.fontSizeMenu )

        contentLabel!.backgroundColor = .orange
//        contentLabel!.sizeToFit()

        contentLabel!.textColor = .white
        contentLabel!.numberOfLines = 0
        contentLabel!.text = menuItem.item.description
//        view.addSubview(contentLabel!)

        view1.addSubview(videoView!)
        view2.addSubview(contentLabel!)

        if menuItem == .item5 {
            let view3 = UIView()
            print(view3.frame.width)
            view3.backgroundColor = .systemPink
            stackView!.addArrangedSubview(view3)
            print(view3.frame.width)

            goButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            goButton!.addTarget(self, action: #selector(loadPlanetARium), for: .touchUpInside)
            goButton!.center = CGPoint(x: view3.frame.width / 2, y: view3.frame.height / 2 + 100)
            goButton!.backgroundColor = .gray
            goButton!.layer.cornerRadius = 10
            goButton!.layer.shadowOffset = .zero
            goButton!.layer.shadowRadius = 3
            goButton!.layer.shadowColor = UIColor.black.cgColor
            goButton!.layer.shadowOpacity = 0.6
            goButton!.titleLabel?.font = UIFont(name: K.fontFace, size: K.fontSizeMenu)
            goButton!.setTitle("Go to PlanetARium", for: .normal)
//            view.addSubview(goButton!)

            view3.addSubview(goButton!)
        }
         */
    }
        
    
    
    
    func setConstraints(in superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: superView.topAnchor, constant: 2 * K.padding),
                                     leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: K.padding),
                                     trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -K.padding),
                                     bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -2 * K.padding)])
    }
}
