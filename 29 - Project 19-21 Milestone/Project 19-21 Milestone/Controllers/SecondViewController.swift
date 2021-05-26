//
//  SecondViewController.swift
//  Project 19-21 Milestone
//
//  Created by Гнатюк Сергей on 26.05.2021.
//

import UIKit

class SecondViewController: UIViewController {
    
    // Dependencies
    let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        textView.font = .systemFont(ofSize: 20)
       // textView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveNotes))
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.frame = view.bounds
    }

    @objc func saveNotes() {
        
    }
}
