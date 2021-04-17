//
//  ViewController.swift
//  Project7
//
//  Created by Гнатюк Сергей on 15.04.2021.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filter = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //homework add button Credits in navigationController
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(addCredits))
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        
        title = "Parsing JSON"
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
           urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
            showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filter = petitions
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filter.count      //        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filter[indexPath.row]  //petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filter[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //homework func call alert
    @objc func addCredits() {
    let ac = UIAlertController.init(title: "Attention", message: "Data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)

    }
    
    @objc func filterPetitions() {
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
        filter.removeAll(keepingCapacity: true)
        for petition in petitions {
            if petition.title.contains(searchString) || petition.body.contains(searchString) {
                filter.append(petition)
                tableView.reloadData()
            }
        }
    }
}

