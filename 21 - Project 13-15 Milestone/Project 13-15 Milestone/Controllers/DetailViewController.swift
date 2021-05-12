//
//  DetailViewController.swift
//  Project 13-15 Milestone
//
//  Created by Гнатюк Сергей on 11.05.2021.
//

import UIKit

final class DetailViewController: UITableViewController {

    // Dependencies
    var country: Country!
    let sectionTitles: [String]
    let formatter = NumberFormatter()
    
    // Properties
    let flag = "Flag", general = "General", languages = "Languages", currencies = "Currencies"
    
    required init?(coder aDecoder: NSCoder) {
        sectionTitles = [flag, general, languages, currencies]
        formatter.numberStyle = .decimal
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        guard country != nil else {
            print("Parameters not set")
            navigationController?.popViewController(animated: true)
            return
    }
        navigationItem.largeTitleDisplayMode = .never
        title = country.name
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFacts))
    }

    // MARK: - TableViewDataSource

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionTitles[indexPath.section] {
        case flag:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
            if let cell = cell as? FlagCell {
                let image = UIImage(named: getFlagFileName(code: country.alpha2Code, type: .HD))
                cell.flagImageView.image = image
            }
            return cell
            
        case general:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = buildName()
            case 1:
                cell.textLabel?.text = buildDemonym()
            case 2:
                cell.textLabel?.text = buildCapital()
            case 3:
                cell.textLabel?.text = buildPopulation()
            case 4:
                cell.textLabel?.text = buildArea()
            default:
                return cell
            }
            return cell
            
        case languages:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = buildLanguage(for: country.languages[indexPath.row])
            return cell
            
        case currencies:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = buildCurrency(for: country.currencies[indexPath.row])
            return cell

        default:
            break
        }
        return UITableViewCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionTitles[section] {
        case flag:
            return 1
        case general:
            return 5
        case languages:
            return country.languages.count
        case currencies:
            return country.currencies.count
        default:
            return 0
        }
    }
    
    // MARK: - @objc methods
    
    @objc private func shareFacts() {
        var shareable = [Any]()

        if let flag = UIImage(named: getFlagFileName(code: country.alpha2Code, type: .HD))?.jpegData(compressionQuality: 0.8) {
            shareable.append(flag)
        }
        
        shareable.append(getSharedText())
        
        let vc = UIActivityViewController(activityItems: shareable, applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    // MARK: - Private
    
    private func getSharedText() -> String {
        var text = """
        General
            \(buildName())
            \(buildDemonym())
            \(buildCapital())
            \(buildPopulation())
            \(buildArea())
        Languages
        """
        for language in country.languages {
            text.append(contentsOf: "\n    \(buildLanguage(for: language))")
        }
        text.append(contentsOf: "\nCurrencies")
        for currency in country.currencies {
            text.append(contentsOf: "\n    \(buildCurrency(for: currency))")
        }

        return text
    }
    
    private func buildName() -> String {
        return "Name: \(country.name) (\(country.nativeName))"
    }
    
    private func buildDemonym() -> String {
        return "Demonym: \(country.demonym)"
    }
    
    private func buildCapital() -> String {
        return "Capital: \(country.capital)"
    }
    
    private func buildPopulation() -> String {
        if let population = formatter.string(for: country.population) {
            return "Population: \(population)"
        }
        return "Population: unknown"
    }
    
    private func buildArea() -> String {
        if let area = formatter.string(for: country.area) {
            return "Area: \(area) km²"
        }
        return "Area: unknown"
    }
    
    private func buildLanguage(for language: Language) -> String {
        return "\(language.name) (\(language.nativeName))"
    }
    
    private func buildCurrency(for currency: Currency) -> String {
        let name = currency.name ?? "Unknown name"
        let code = currency.code ?? "Unknown code"
        let symbol = currency.symbol ?? "Unknown symbol"
        return "\(name) (\(code), \(symbol))"
    }
    
}
