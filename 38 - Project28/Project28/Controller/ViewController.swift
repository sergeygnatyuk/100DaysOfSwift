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
    // project 28 challenge 1
    var done: UIBarButtonItem?
    
    // Properties
    let titleVC = "Nothing to see here"
    let modifiedTitleVC = "Secret stuff!"
    let reasonIdentify = "Identify yourself!"
    let SecretMessageIdentify = "SecretMessage"
    // project 28 challenge 2
    let passwordKey = "NewPassword"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleVC
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        // project 28 challenge 1
        done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSecretMessage))
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
        KeychainWrapper.standard.set(secret.text, forKey: SecretMessageIdentify)
        secret.resignFirstResponder()
        secret.isHidden = true
        title = titleVC
        // project 28 challenge 1
        navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Private
    private func unlockSecretMessage() {
        secret.isHidden = false
        title = modifiedTitleVC
        secret.text = KeychainWrapper.standard.string(forKey: SecretMessageIdentify) ?? ""
        // project 28 challenge 1
        navigationItem.rightBarButtonItem = done
        
    }
    // project 28 challenge 2
    private func enterByPassword(_ alertAction: UIAlertAction) {
        if let password = KeychainWrapper.standard.string(forKey: passwordKey) {
            let alertController = UIAlertController(title: "Enter password", message: nil, preferredStyle: .alert)
            alertController.addTextField()
            alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alertController, weak self] _ in
                if alertController?.textFields?[0].text == password {
                    self?.unlockSecretMessage()
                }
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Enter new password", message: nil, preferredStyle: .alert)
            alertController.addTextField()
            alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alertController] _ in
                if let password = alertController?.textFields?[0].text {
                    KeychainWrapper.standard.set(password, forKey: self.passwordKey)
                }
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alertController, animated: true)
        }
        if true {
            KeychainWrapper.standard.set("password", forKey: passwordKey)
        }
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
                        // project 28 challenge 2
                        let alertController = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Use password", style: .default, handler: self?.enterByPassword))
                        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        self?.present(alertController, animated: true)
                    }
                }
            }
        } else {
//            let alertController = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Use password", style: .default, handler: enterByPassword))
//            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//            present(alertController, animated: true)
        }
    }
}

