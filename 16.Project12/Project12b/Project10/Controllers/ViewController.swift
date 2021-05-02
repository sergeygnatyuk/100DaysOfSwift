//
//  ViewController.swift
//  Project10
//
//  Created by Гнатюк Сергей on 25.04.2021.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // Properties
    private var people = [Person]()
    private let identifierPerson = "Person"
    private let keyPeople = "people"
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                           target: self,
                                                           action: #selector(newPerson))
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: keyPeople) as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to save people.")
            }
        }
    }
    
    //MARK: - CollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierPerson, for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        let person = people[indexPath.row]
        cell.nameLabel.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        //pr10 task1 add delay 1 sec for view alertcontroller and delete items from collectionview
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let acMain = UIAlertController(title: "Options",
                                           message: "Choose to rename or delete the person",
                                           preferredStyle: .actionSheet)
            let renamePerson = UIAlertAction(title: "Rename",
                                             style: .default) { [weak self] (action) in
                let ac = UIAlertController(title: "Rename Person",
                                           message: nil,
                                           preferredStyle: .alert)
                ac.addTextField()
                ac.addAction(UIAlertAction(title: "OK",
                                           style: .default){ [weak self, weak ac] _ in
                    guard let newName = ac?.textFields?[0].text else { return }
                    person.name = newName
                    self?.save()
                    self?.collectionView.reloadData()
                })
                self?.present(ac, animated: true)
            }
            let deleteAction = UIAlertAction(title: "Delete",
                                             style: .destructive) { [weak self] (action) in
                let ac = UIAlertController(title: "Confirm Delete",
                                           message: "Are you sure you would like to delete?",
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Delete",
                                           style: .destructive) { [weak self] (action) in
                    self?.people.remove(at: indexPath.item)
                    self?.collectionView.reloadData()
                })
                self?.present(ac, animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel,
                                             handler: nil)
            acMain.addAction(renamePerson)
            acMain.addAction(deleteAction)
            acMain.addAction(cancelAction)
            self.present(acMain, animated: true, completion: nil)
        }
    }
    
    //MARK: - @objc methods
    
    @objc private func newPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        //pr10 task2 checking the ability to use the camera
        print(UIImagePickerController.isSourceTypeAvailable(.camera))
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            picker.sourceType = .camera
        }
        picker.delegate = self
        present(picker, animated: true)
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
    
    //MARK: - Public
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

