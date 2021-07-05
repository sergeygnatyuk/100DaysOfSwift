//
//  UITableViewController.swift
//  Project4
//
//  Created by Гнатюк Сергей on 08.04.2021.
//

import UIKit

class TableViewController: UITableViewController {
    
    var websites = ["apple.com", "hackingwithswift.com", "github.com", "instagram.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "websiteName", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let webViewController = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController {
                    webViewController.websiteToLoad = websites[indexPath.row]
                    navigationController?.pushViewController(webViewController, animated: true)
            }
    }
}
