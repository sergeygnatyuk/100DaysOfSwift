//
//  ViewController.swift
//  Project5
//
//  Created by Гнатюк Сергей on 09.04.2021.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    let identifier = "Word"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        //homework method restart game with save all word in tableView
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        startGame()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    if isShort(word: lowerAnswer) {
                    //bonus homework elimination error uppercased
                        usedWords.insert(answer.lowercased(), at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                    } else {
                        showErrorMessage(message: "Word shorter than three letters or are just our start word", title: "Think a little and write again")
                    }
                } else {
                    showErrorMessage(message: "Word not recognized", title: "You can't just make them up, you know")
                }
            } else {
                showErrorMessage(message: "Word already used", title: "Be more original!")
            }
        } else {
            guard let title = title else { return }
            showErrorMessage(message: "Word not possible", title: "You can't spell that word from \(title.lowercased()).")
        }
        
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    // homework checking for the number of letters and matching the init word
    func isShort(word: String) -> Bool {
        if title!.starts(with: word) && word.count < 3 {
            return false
        } else {
        return true
        }
    }
//homework method for refactoring
    func showErrorMessage(message: String, title: String) {
        let errorTitle = title
        let errorMessage = message
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

