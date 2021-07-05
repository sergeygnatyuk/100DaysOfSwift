//
//  DetailViewController.swift
//  Project1
//
//  Created by Гнатюк Сергей on 30.03.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    //Properties
    @IBOutlet weak var imageView: UIImageView!
    public var selectedImage: String?
    //Homework
    public var selectedPictureNumber = 0
    public var totalPictures = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(shareTaped))
        title = "Pictures \(selectedPictureNumber) of \(totalPictures)"
        navigationItem.largeTitleDisplayMode = .never
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    //MARK: - @objc methods
    //method share image
    @objc private func shareTaped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        //add name image in UIActivityViewController
        let viewController = UIActivityViewController(activityItems: [image, selectedImage as Any], applicationActivities: [])
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(viewController, animated: true)
    }
}


