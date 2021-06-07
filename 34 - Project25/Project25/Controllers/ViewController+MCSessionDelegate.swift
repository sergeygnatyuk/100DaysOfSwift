//
//  ViewController+MCSessionDelegate.swift
//  Project25
//
//  Created by Гнатюк Сергей on 06.06.2021.
//

import UIKit
import MultipeerConnectivity

extension ViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected \(peerID.displayName)")
        case .connecting:
            print("Connecting \(peerID.displayName)")
        case .notConnected:
            // project25 challenge 1
            showAlertDisconnected(displayName: peerID.displayName)
            print("Not Connected \(peerID.displayName)")
        @unknown default:
            print("Unknown state received \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    
}
