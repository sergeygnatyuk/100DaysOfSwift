//
//  ViewController + DetailViewController.swift
//  Project 19-21 Milestone
//
//  Created by Гнатюк Сергей on 30.05.2021.
//

import UIKit

@available(iOS 13.0, *)
extension ViewController: DetailViewControllerDelegate {
    
    func detailViewControllerDoneButtonTapped(_ viewController: DetailViewController) {
       let note = viewController.note
       if note.detail.isEmpty {
           if let index = notes.firstIndex(where: { $0.uuid == note.uuid }) {
               notes.remove(at: index)
           }
           updateToolBarLabel()
           return
       }
       updateToolBarLabel()
       saveNotes()
   }
}
