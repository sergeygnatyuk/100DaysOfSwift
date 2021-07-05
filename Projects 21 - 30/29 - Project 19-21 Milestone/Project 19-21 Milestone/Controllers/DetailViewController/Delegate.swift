//
//  Delegate.swift
//  Project 19-21 Milestone
//
//  Created by Гнатюк Сергей on 30.05.2021.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func detailViewControllerDoneButtonTapped(_ viewController: DetailViewController)
}
