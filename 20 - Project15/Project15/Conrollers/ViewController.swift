//
//  ViewController.swift
//  Project15
//
//  Created by Гнатюк Сергей on 09.05.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // Dependencies
    private var imageView: UIImageView!

    // Properties
    private var currentAnimation = 0
    private let penguinImage = "penguin"
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(image: UIImage(named: penguinImage))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }

    //MARK: - Actions
    
    @IBAction func tapped(_ sender: Any) {
        currentAnimation += 1
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    
}

