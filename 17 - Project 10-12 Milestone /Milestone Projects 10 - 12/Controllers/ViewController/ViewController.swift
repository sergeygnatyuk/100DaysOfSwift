//
//  ViewController.swift
//  Milestone Projects 10 - 12
//
//  Created by Гнатюк Сергей on 02.05.2021.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Dependencies
    var people = [Picture]()
   
    //Properties
    private let identifierCell = "Cell"
    private let keyPeople = "keyPeople"
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(newPerson))
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: keyPeople) as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                people = try jsonDecoder.decode([Picture].self, from: savedPeople)
            } catch {
                print("Failed to save people.")
            }
        }
    }
    
    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell) as? PictureCell else {
            fatalError("Unable to dequeue PictureCell")
        }
        let person = people[indexPath.row]
        cell.nameCell.text = person.imageName
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageCell.image = UIImage(contentsOfFile: path.path)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let acMain = UIAlertController(title: "Options",
                                           message: "Choose to Rename or View Image",
                                           preferredStyle: .actionSheet)
            let renamePerson = UIAlertAction(title: "Rename Image",
                                             style: .default) { [weak self] (action) in
                let ac = UIAlertController(title: "Rename Image",
                                           message: nil,
                                           preferredStyle: .alert)
                ac.addTextField()
                ac.addAction(UIAlertAction(title: "OK",
                                           style: .default){ [weak self, weak ac] _ in
                    guard let newName = ac?.textFields?[0].text else { return }
                    person.imageName = newName
                    self?.save()
                    self?.tableView.reloadData()
                })
                self?.present(ac, animated: true)
            }
            let viewImage = UIAlertAction(title: "View Image",
                                          style: .default) { [weak self] _ in
                if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                    vc.selectedImage = self?.people[indexPath.row]
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel,
                                             handler: nil)
            acMain.addAction(renamePerson)
            acMain.addAction(viewImage)
            acMain.addAction(cancelAction)
            self.present(acMain, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            people.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            save()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: - Private
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func save() {
        let jsonEncoder = JSONEncoder()
        if let saveData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: keyPeople)
        } else {
            print("Failed to save people")
        }
    }
    
    //MARK: - @objc methods
    
    @objc func newPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        print(UIImagePickerController.isSourceTypeAvailable(.camera))
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            picker.sourceType = .camera
        }
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //MARK: - Public
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let person = Picture(imageName: "Unknown", image: imageName)
        people.append(person)
        save()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

