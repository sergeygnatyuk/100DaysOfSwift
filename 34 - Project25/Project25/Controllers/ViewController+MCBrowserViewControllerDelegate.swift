//
//  ViewController+MCBrowserViewControllerDelegate.swift
//  Project25
//
//  Created by Гнатюк Сергей on 06.06.2021.
//

import UIKit
import MultipeerConnectivity

extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
}
