//
//  PhotoViewController.swift
//  Lesson 11
//
//  Created by Гнатюк Сергей on 13.03.2021.
//

import UIKit

class PhotoViewController: UIViewController {

    var image: UIImage?
    
    @IBOutlet weak var photoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.image = image

    }
    

    @IBAction func shareAction(_ sender: UIButton) {
        
        let shareController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                print("Great")
            }
            
        }
        
        present(shareController, animated: true, completion: nil)
        
        
    }
    

}
