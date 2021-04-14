//
//  ViewController.swift
//  Projects 4-6 Milestone
//
//  Created by Гнатюк Сергей on 14.04.2021.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList = [String]()
    let identifier = "Word"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        let addElement = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addElementInList))
        
       let clean = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(cleanList))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(shareTaped))
        
        navigationItem.leftBarButtonItems = [addElement, clean]
    }
    
    @objc func cleanList() {
        
        let ac = UIAlertController.init(title: "Are you sure you want to clean the entire list?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Clean", style: .default, handler: {
            [weak self] action in
            self?.shoppingList.removeAll()
            self?.tableView.reloadData()
            
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func addElementInList() {
        let ac = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    func submit(_ answer: String) {
        shoppingList.insert(answer.lowercased(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func shareTaped() {
        let list = shoppingList.joined(separator: "\n")
        
        let avc = UIActivityViewController(activityItems: [list], applicationActivities: nil)
        present(avc, animated: true)
        
        }
    
    
}
