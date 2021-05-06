//
//  ViewController.swift
//  Project13
//
//  Created by Гнатюк Сергей on 04.05.2021.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UI
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensitySlider: UISlider!
    //project 13 challenge 2
    @IBOutlet var changeFilterButton: UIButton!
    //project 13 challenge 3
    @IBOutlet var radiusSlider: UISlider!
    
    // Properties
    private let titleIdentifier = "Instafilter"
    private let filterName = "CISepiaTone"
    
    // Dependencies
    private var currentImage: UIImage!
    private var context: CIContext!
    private var currentFilter: CIFilter!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleIdentifier
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: filterName)
        //project 13 challenge 2
        changeFilterButton.setTitle("Selected (\(filterName)) filter", for: .normal)
    }
    
    //MARK: - Public
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        //project 13 challenge 3
        radiusProcessing()
    }
    
    //MARK: - Private
    
    private func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    //project 13 challenge 3
    private func radiusProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radiusSlider.value * 400, forKey: kCIInputRadiusKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    private func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        currentFilter = CIFilter(name: actionTitle)
        
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        //project 13 challenge 2
        changeFilterButton.setTitle("Selected (\(actionTitle)) filter", for: .normal)
        
        applyProcessing()
        //project 13 challenge 3
        radiusProcessing()
    }
    
    //MARK: - Actions
    
    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender as? UIView
            popoverController.sourceRect = (sender as AnyObject).bounds
        }
        present(ac, animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        guard imageView.image != nil else {
            //project 13 challenge 1
            let ac = UIAlertController(title: "Save Error", message: "You didn't select a photo to process", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try Again", style: .default))
            present(ac, animated: true, completion: nil)
            return
        }
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self,
                                       #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    //project 13 challenge 3
    @IBAction func radiusChanged(_ sender: Any) {
        radiusProcessing()
    }
    
    
    //MARK: - @objc methods
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

