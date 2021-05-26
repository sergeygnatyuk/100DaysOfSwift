//
//  ViewController.swift
//  Project 19-21 Milestone
//
//  Created by Гнатюк Сергей on 26.05.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Dependencies
    let tableView = UITableView()
    
    //Properties
    let cellIdentifier = "cell"
    let systemNameIconCellImage = "pencil.tip.crop.circle"
    let titleNamed = "Notes"
    let arrayNotes = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleNamed
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(editNotes))
        navigationItem.largeTitleDisplayMode = .never
        
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5//arrayNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)"
        cell.imageView?.image = UIImage(systemName: systemNameIconCellImage)
        cell.imageView?.tintColor = .cyan
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let secondViewController = SecondViewController()
        navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @objc func editNotes() { }
}

