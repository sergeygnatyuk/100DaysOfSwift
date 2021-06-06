//
//  ViewController.swift
//  Project25
//
//  Created by Гнатюк Сергей on 06.06.2021.
//

import UIKit

class ViewController: UICollectionViewController {
    // Properties
    var images = [UIImage]()
    let imageViewIdentifier = "imageView"
    let titleNavigationController = "Selfie Share"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleNavigationController
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
    }
        
    // MARK: - CollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageViewIdentifier, for: indexPath)
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        return cell
    }
    
  
}

