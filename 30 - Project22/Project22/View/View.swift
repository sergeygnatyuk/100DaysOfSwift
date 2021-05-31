//
//  View.swift
//  Project22
//
//  Created by Гнатюк Сергей on 01.06.2021.
//

import UIKit

class View: UIView {
    
    var circle: UIView = {
        let circle = UIView()
        circle.clipsToBounds = true
        circle.backgroundColor = .cyan
        circle.isUserInteractionEnabled = true
//        circle.frame = CGRect(x: 0, y: 0, width: 256, height: 256)
//        circle.layer.cornerRadius = 128
        return circle
    }()
    
   
    // MARK: - Constraints
     func setupCircleViewConstraints() {
        circle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circle.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            circle.heightAnchor.constraint(equalTo: circle.widthAnchor, multiplier: 1),
            circle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 45),
            circle.centerXAnchor.constraint(equalTo: centerXAnchor)
            //            photoImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            //            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1),
            //            photoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 45),
            //            photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    // MARK: - Dependencies
    func setupUIElements() {
        addSubview(circle)
        setupCircleViewConstraints()
    }
}
