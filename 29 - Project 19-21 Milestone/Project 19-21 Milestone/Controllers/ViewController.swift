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
    var arrayNotes = ["Notes 1", "Notes 2", "Notes 3"]
    var isFavourite = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleNamed
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        //        navigationItem.leftBarButtonItem = self.editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(editNotes))
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(resultsLabel)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": resultsLabel]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": resultsLabel]))
        if arrayNotes != [] {
            resultsLabel.isHidden = true
        } else {
            resultsLabel.isHidden = false
        }
    }
    
    let resultsLabel: UILabel = {
        let label = UILabel()
        label.text = "ADD NEW NOTE"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .cyan
        return label
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNotes.count
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrayNotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let favorite = favoriteAction(at: indexPath)
        favorite.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [done, favorite])
    }
    
    private func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, completion) in
            self.arrayNotes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .systemYellow
        action.image = UIImage(systemName: "checkmark.circle")
        return action
    }
    private func favoriteAction (at indexPath: IndexPath) -> UIContextualAction {
        let object = arrayNotes[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Favorite") { (action, view, completion) in
            //             object.isFavourite = !object.isFavourite
            self.arrayNotes[indexPath.row] = object
            completion(true)
        }
        
        action.image = UIImage(systemName: "heart")
        action.backgroundColor = .black
        return action
    }
    
    @objc func editNotes() {
        let newNotes = String()
        arrayNotes.append(newNotes)
    }
}

