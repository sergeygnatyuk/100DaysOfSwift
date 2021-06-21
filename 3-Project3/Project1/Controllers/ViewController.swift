//
//  ViewController.swift
//  Project1
//
//  Created by Гнатюк Сергей on 29.03.2021.
//

import UIKit

final class ViewController: UITableViewController {
    
    // Properties
    var pictures = [String]()
    let cellReuseIdentifier = "Picture"
    let titleName = "Storm Viewer"
    let prefix = "nssl"
    let fontName = "HiraMinProN-W3"
    let cellSpacingHeight: CGFloat = 7
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleName
        navigationController?.navigationBar.prefersLargeTitles = true
        let fm = FileManager.default
        guard let path = Bundle.main.resourcePath else { return }
        guard var items = try? fm.contentsOfDirectory(atPath: path) else { return }
        items.sort()
        for item in items {
            if item.hasPrefix(prefix) {
                pictures.append(item)
            }
        }
    }
    
    // MARK: - TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.backgroundColor = UIColor.lightText
        cell.layer.borderColor = UIColor.cyan.cgColor
        cell.layer.borderWidth = 2.5
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        //change font size in cells
        cell.textLabel?.font = UIFont.init(name: fontName, size: 20)
        return cell
    }
    //Delete cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pictures.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            viewController.selectedImage = pictures[indexPath.row]
            //Homework
            viewController.selectedPictureNumber = indexPath.row + 1
            viewController.totalPictures = pictures.count
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    //Customization cell
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

