//
//  ViewController.swift
//  Project 25-27 Milestone
//
//  Created by Гнатюк Сергей on 13.06.2021.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    // UI
    @IBOutlet var imageView: UIImageView!
    
    // Properties
    let titleVC = "MEME MAKER"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleVC
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
        navigationController?.isToolbarHidden = false
        let addMemeToImage = UIBarButtonItem(title: "Add Meme", style: .plain, target: self, action: #selector(addMemeTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let shareImage = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        toolbarItems = [addMemeToImage, space, shareImage]
    }
    
    // MARK: - @objc methods
    @objc func importImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else { return }
        let viewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
        viewController.popoverPresentationController?.barButtonItem = toolbarItems?.last
        present(viewController, animated: true)
    }
    
    @objc func addMemeTapped() {
        let alertController = UIAlertController(title: "Write and append text for your meme", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "TOP", style: .default) { [weak self, weak alertController] _ in
            guard let text = alertController?.textFields?.first?.text else { return }
            self?.renderImageAndText(text, alignToTop: true)
        })
        alertController.addAction(UIAlertAction(title: "BOTTOM", style: .default) { [weak self, weak alertController] _ in
            guard let text = alertController?.textFields?.first?.text else { return }
            self?.renderImageAndText(text, alignToTop: false)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    // MARK: - Private
    func renderImageAndText(_ text: String, alignToTop: Bool) {
        guard let sourceImage = imageView.image else { return }
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: sourceImage.size.width, height: sourceImage.size.height))
        let image = renderer.image { [unowned sourceImage] ctx in
            sourceImage.draw(at: CGPoint(x: 0, y: 0))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 75, weight: .bold),
                                                         .strokeColor: UIColor.yellow,
                                                         .strokeWidth: -3,
                                                         .foregroundColor: UIColor.red,
                                                         .paragraphStyle: paragraphStyle ]
            let attrString = NSAttributedString(string: text, attributes: attrs)
            if alignToTop == true {
                attrString.draw(with: CGRect(x: 26, y: 26, width: Int(sourceImage.size.height - 52), height: 150), options: .usesLineFragmentOrigin, context: nil)
            } else {
                attrString.draw(with: CGRect(x: 26, y: Int(sourceImage.size.height) - 80, width: Int(sourceImage.size.height - 52), height: 150), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        imageView.image = image
    }
}

