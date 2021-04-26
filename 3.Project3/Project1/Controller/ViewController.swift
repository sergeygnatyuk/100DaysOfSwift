//
//  ViewController.swift
//  Project1
//
//  Created by Гнатюк Сергей on 29.03.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    let cellReuseIdentifier = "Picture"
    let cellSpacingHeight: CGFloat = 7
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        var items = try! fm.contentsOfDirectory(atPath: path)
        
        //sorting uitableviewcell
        items.sort()
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
            
        }
    }
    
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
        cell.textLabel?.font = UIFont.init(name: "HiraMinProN-W3", size: 20)
        
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

