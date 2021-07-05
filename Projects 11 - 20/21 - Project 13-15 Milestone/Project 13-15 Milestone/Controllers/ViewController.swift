//
//  ViewController.swift
//  Project 13-15 Milestone
//
//  Created by Гнатюк Сергей on 11.05.2021.
//

import UIKit
import WebKit

final class ViewController: UITableViewController {
    
    // Dependencies
    var countries = [Country]()
    
    // Properties
    let countryCellIdentifier = "Country"
    let detailViewControllerIdentifier = "DetailViewController"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Country Facts"
        performSelector(inBackground: #selector(loadData), with: nil)
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: countryCellIdentifier, for: indexPath)
        guard let cell = reusableCell as? CountryCell else {
            return reusableCell
        }
        let country = countries[indexPath.row]
        
        cell.flagImageView?.image = UIImage(named: getFlagFileName(code: country.alpha2Code, type: .SD))
        cell.flagImageView?.layer.borderColor = UIColor.black.cgColor
        cell.flagImageView?.layer.borderWidth = 0.1
        cell.flagImageView?.layer.cornerRadius = 5
        cell.nameLabel.text = country.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(identifier: detailViewControllerIdentifier) as? DetailViewController {
            viewController.country = countries[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - @objc methods
    
    @objc func loadData() {
        let urlString = "https://restcountries.eu/rest/v2/all?fields=name;alpha2Code;capital;population;demonym;area;nativeName;currencies;languages;flag"
        if let url = URL(string: urlString) {
            do {
                let data = try Data(contentsOf: url)
                let jsonCountries = try JSONDecoder().decode([Country].self, from: data)
                countries = jsonCountries
            } catch let error {
                print("Data or JSONDecoder error: \(error)")
            }
        }
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
}

