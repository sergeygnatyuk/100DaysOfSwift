//
//  ViewController.swift
//  Project25
//
//  Created by Гнатюк Сергей on 06.06.2021.
//

import UIKit
import MultipeerConnectivity

final class ViewController: UICollectionViewController {
    // Properties
    var images = [UIImage]()
    let imageViewIdentifier = "imageView"
    let titleNavigationController = "Selfie Share"
    let serviceType = "hws-project25"
    let tagPriority = 1000
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleNavigationController
        let connectingButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let connectPeers = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showConnectPeersAlert))
        navigationItem.leftBarButtonItems = [connectingButton, connectPeers]
        let importPictureButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let sendMessageButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showSendMessageAlert))
        navigationItem.rightBarButtonItems = [importPictureButton, sendMessageButton]
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    // MARK: - CollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageViewIdentifier, for: indexPath)
        if let imageView = cell.viewWithTag(tagPriority) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        return cell
    }
    
    // MARK: - @objc methods
    @objc func showConnectionPrompt() {
        let alertController = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        alertController.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    // project25 challenge 1
    @objc func showSendMessageAlert() {
        let alertController = UIAlertController(title: "Massege", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak self, weak alertController] _ in
            if let text = alertController?.textFields?[0].text {
                self?.sendMessage(text)
            }
        }))
        present(alertController, animated: true)
    }
    // project25 challenge 3
    @objc func showConnectPeersAlert() {
        guard let connectedPeers = mcSession?.connectedPeers else { return }
        var message = ""
        if connectedPeers.isEmpty {
            message = "Currently there are no peers connected"
        }
        let alertController = UIAlertController(title: "Names of all devices", message: message, preferredStyle: .alert)
        for peerID in connectedPeers {
            alertController.addAction(UIAlertAction(title: "\(peerID)", style: .default))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    // MARK: - Private
    private func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    private func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: serviceType, session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    // project25 challenge 2
    private func sendMessage(_ text: String) {
        let data = Data(text.utf8)
        sendData(data)
    }
    // project25 challenge 2
    private func sendData(_ data: Data) {
        guard let mcSession = mcSession else { return }
        if mcSession.connectedPeers.count > 0 {
            do {
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                let alertController = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                present(alertController, animated: true)
        }
    }
}

// MARK: - Public
// project25 challenge 1
public func showAlertDisconnected(displayName: String) {
    let alertController = UIAlertController(title: "ALERT", message: "\(peerID.displayName) disconnected", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    present(alertController, animated: true)
}
}

