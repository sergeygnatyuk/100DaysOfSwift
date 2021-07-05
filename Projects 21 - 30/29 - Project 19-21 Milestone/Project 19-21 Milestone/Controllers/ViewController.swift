//
//  ViewController.swift
//  Project 19-21 Milestone
//
//  Created by Гнатюк Сергей on 30.05.2021.
//

import UIKit

@available(iOS 13.0, *)
class ViewController: UITableViewController {
    // UI
    var notes = [Note]()
    
    lazy var toolBarLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = "No Notes"
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPressed))
        
        navigationController?.isToolbarHidden = false
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let create = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
        let label = UIBarButtonItem(customView: toolBarLabel)
        
        create.tintColor = UIColor().colorFromHex("#E8A200")
        
        
        toolbarItems = [space, label, space, create]
        navigationController?.toolbar.barTintColor = UIColor().colorFromHex("#EBEBEB")
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        self.loadNotes()
        tableView.backgroundColor = UIColor().colorFromHex("#EBEBEB")
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NoteCell {
            let detail = notes[indexPath.row].detail
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/M/yy"
            let dateStr = formatter.string(from: notes[indexPath.row].date)
            
            var sentences = detail.components(separatedBy: "\n")
            cell.titleLabel?.text = sentences.removeFirst()
            cell.dateLabel?.text = dateStr
            cell.detailLabel?.text = sentences.joined(separator: "\n")
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadDetailView(notes[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.reloadData()
            updateToolBarLabel()
        }
    }
    
    // MARK: - Public
    public func loadDetailView(_ note: Note) {
        if let viewController = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController {
            viewController.note = note
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public func updateToolBarLabel() {
        toolBarLabel.text = "\(notes.count) Notes"
    }
    
    public func saveNotes() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: "notes")
        }
    }
    
    public func loadNotes() {
        guard let data = UserDefaults.standard.object(forKey: "notes") as? Data else {
            print("Can't find notes")
            return
        }
        do {
            notes = try JSONDecoder().decode([Note].self, from: data)
            updateToolBarLabel()
        } catch {
            print("fail to decode")
        }
    }
    
    // MARK: - @objc methods
    @objc private func editPressed() {
    }
    
    @objc private func createNote() {
        let note = Note()
        notes.insert(note, at: 0)
        loadDetailView(note)
    }
}

