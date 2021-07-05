//
//  ViewController+UIImagePickerControllerDelegate.swift
//  Project 25-27 Milestone
//
//  Created by Гнатюк Сергей on 13.06.2021.
//

import UIKit

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        imageView.image = image
        dismiss(animated: true)
    }
}
