//
//  WebViewController.swift
//  Project16
//
//  Created by Гнатюк Сергей on 13.05.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    // UI
    @IBOutlet var webView: WKWebView!
    
    // Properties
    var website: String!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard website != nil else {
            print("Website not set")
            navigationController?.popViewController(animated: true)
            return
        }
        if let url = URL(string: website) {
            webView.load(URLRequest(url: url))
        }
    }
}
