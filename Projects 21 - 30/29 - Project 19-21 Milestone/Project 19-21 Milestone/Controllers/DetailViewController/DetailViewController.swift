//
//  DetailViewController.swift
//  Project 19-21 Milestone
//
//  Created by Гнатюк Сергей on 30.05.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var note: Note = Note()
    weak var delegate: DetailViewControllerDelegate?
    
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePressed))
        
        navigationController?.isToolbarHidden = false
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashPressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composePressed))
        
        delete.tintColor = UIColor().colorFromHex("#E8A200")
        compose.tintColor = UIColor().colorFromHex("#E8A200")
        toolbarItems = [delete, space, compose]
        
        view.backgroundColor = UIColor().colorFromHex("#EBEBEB")
        textView.delegate = self
        textView.backgroundColor = UIColor().colorFromHex("#EBEBEB")
        textView.text = note.detail
        textView.tintColor = UIColor().colorFromHex("#EBEBEB")
        textView.contentInset = UIEdgeInsets(top: 0, left: 17, bottom: view.safeAreaInsets.bottom, right: 15)
        
        if note.detail.isEmpty {
            textView.becomeFirstResponder()
        }
       

    }

    @objc func sharePressed() {
        
    }
    
    @objc func trashPressed() {
        
    }
    
    @objc func composePressed() {
        
    }
    
    @objc func donePressed() {
        note.detail = textView.text
        delegate?.detailViewControllerDoneButtonTapped(self)
        navigationController?.popViewController(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePressed))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        navigationItem.rightBarButtonItems = [share, done]
    }
}
