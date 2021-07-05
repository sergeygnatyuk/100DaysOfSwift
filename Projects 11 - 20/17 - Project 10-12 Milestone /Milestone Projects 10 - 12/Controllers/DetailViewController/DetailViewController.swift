//
//  DetailViewController.swift
//  Milestone Projects 10 - 12
//
//  Created by Гнатюк Сергей on 03.05.2021.
//

import UIKit

class DetailViewController: UIViewController {

    //UI
    @IBOutlet var imageDetail: UIImageView!
    
    //Dependencies
    var selectedImage: Picture?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedImage?.imageName
        
        if let imageToLoad = selectedImage?.image {
            let path = getDocumentsDirectory().appendingPathComponent(imageToLoad)
            imageDetail.image = UIImage(contentsOfFile: path.path)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    //MARK: - Private
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
