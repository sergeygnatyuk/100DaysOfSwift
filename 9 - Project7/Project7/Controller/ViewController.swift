//
//  ViewController.swift
//  Project7
//
//  Created by Гнатюк Сергей on 15.04.2021.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //homework add button Credits in navigationController
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(addCredits))
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        
        
        title = "Parsing JSON"
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        DispatchQueue.global(qos: .userInitiated).async { [ weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parse(json: data)
                    self?.filteredPetitions = self!.petitions
                    return
                }
            }
            self?.showError()
        }
        
    }
    
    func showError() {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredPetitions.isEmpty {
            return filteredPetitions.count
        } else {
            return petitions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]  //petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        if !filteredPetitions.isEmpty {
            vc.detailItem = filteredPetitions[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        } else {
            vc.detailItem = petitions[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //homework func call alert
    @objc func addCredits() {
        let ac = UIAlertController.init(title: "Attention", message: "Data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
    
    @objc func filterTapped() {
        let ac = UIAlertController(title: "Filter Petitions", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let search = ac?.textFields?[0].text else { return }
            self?.submit(search)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ searchString: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.filteredPetitions.removeAll(keepingCapacity: true)
            for petition in self.petitions {
                if petition.title.contains(searchString) || petition.body.contains(searchString) {
                    self.filteredPetitions.append(petition)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
