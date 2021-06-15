//
//  ViewController.swift
//  Project28
//
//  Created by Гнатюк Сергей on 15.06.2021.
//

import UIKit
import LocalAuthentication

final class ViewController: UIViewController {
    
    // UI
    @IBOutlet var secret: UITextView!
    
    // Properties
    let titleVC = "Nothing to see here"
    let modifiedTitleVC = "Secret stuff!"
    let reasonIdentify = "Identify yourself!"
    let keyMessage = "SecretMessage"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleVC
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    // MARK: - @objc methods
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        secret.scrollIndicatorInsets = secret.contentInset
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    @objc private func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        KeychainWrapper.standard.set(secret.text, forKey: keyMessage)
        secret.resignFirstResponder()
        secret.isHidden = true
        title = titleVC
    }
    
    // MARK: - Private
    private func unlockSecretMessage() {
        secret.isHidden = false
        title = modifiedTitleVC
        secret.text = KeychainWrapper.standard.string(forKey: keyMessage) ?? ""
    }
    
    // MARK: - Actions
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = reasonIdentify
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let alertController = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alertController, animated: true)
                    }
                }
            }
        } else {
            let alertController = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }
}

