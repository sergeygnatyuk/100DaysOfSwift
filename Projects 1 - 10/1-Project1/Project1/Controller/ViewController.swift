//
//  ViewController.swift
//  Project1
//
//  Created by Гнатюк Сергей on 29.03.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    //Properties
    public var pictures = [String]()
    public var picturesViewCount = [String: Int]()
    private let photosKey = "viewCount"
    private let cellReuseIdentifier = "Picture"
    private let titleName = "Storm Viewer"
    private let nssl = "nssl"
    private let identifierDetail = "Detail"
    private let fontName = "HiraMinProN-W3"
    private let cellSpacingHeight: CGFloat = 7
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //add icon action in navigationBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(menuButtonTapped))
        //project 12 task 1
        let userDefaults = UserDefaults.standard
        picturesViewCount = userDefaults.object(forKey: photosKey) as? [String: Int] ?? [String: Int]()
        title = titleName
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.rowHeight = 60
        //homework project 9 task 1
        performSelector(inBackground: #selector(backLoadImage), with: nil)
        tableView.reloadData()
    }
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        //project 12 task 1
        cell.detailTextLabel?.text = "Views: \(picturesViewCount[pictures[indexPath.row], default: 0])"
        cell.backgroundColor = UIColor.lightText
        cell.layer.borderColor = UIColor.cyan.cgColor
        cell.layer.borderWidth = 3.0
        cell.layer.cornerRadius = 15
       // change font size in cells
        cell.textLabel?.font = UIFont.init(name: fontName, size: 15)
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
        if let viewController = storyboard?.instantiateViewController(withIdentifier: identifierDetail) as? DetailViewController {
            viewController.selectedImage = pictures[indexPath.row]
            //Homework
            viewController.selectedPictureNumber = indexPath.row + 1
            //project 12 task 1
            picturesViewCount[pictures[indexPath.row], default: 0] += 1
            viewController.totalPictures = pictures.count
            DispatchQueue.global().async { [weak self] in
                self?.saveViewCount()
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(viewController, animated: true)
                    self?.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    
   // Customization cell
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    //MARK: - @objc methods
    
    //method share link
    @objc private func menuButtonTapped() {
        var items: [Any] = ["This app is great, you should try it!"]
        if let url = URL(string: "https://www.hackingwithswift.com/100/16") {
            items.append(url)
        }
        
        let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    //homework project 9 task 1
    @objc private func backLoadImage() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        var items = try! fm.contentsOfDirectory(atPath: path)
        //sorting uitableviewcell
        items.sort()
        for item in items {
            if item.hasPrefix(nssl) {
                self.pictures.append(item)
            }
        }
    }
    
    //MARK: - Private
    //project 12 task 1
    private func saveViewCount() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(picturesViewCount, forKey: photosKey)
    }
}

