//
//  ViewController.swift
//  Project5
//
//  Created by Гнатюк Сергей on 09.04.2021.
//

import UIKit

import UIKit

class ViewController: UITableViewController {
    
    //Properties
    var allWords = [String]()
    // project 12 challenge 3
    var gameState = GameState(currentWord: "", usedWords: [String]())
    let gameStateKey = "GameState"
    private let cellIdentifier = "Word"
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startNewGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        performSelector(inBackground: #selector(loadGameState), with: nil)
    }
    
    //MARK: - @objc methods
    
    // project 12 challenge 3
    // run on background thread
    @objc private func loadGameState() {
        let userDefaults = UserDefaults.standard
        if let loadedState = userDefaults.object(forKey: gameStateKey) as? Data {
            let decoder = JSONDecoder()
            if let decodedState = try? decoder.decode(GameState.self, from: loadedState) {
                gameState = decodedState
            }
        }
        // no word found in gameState: start a new game
        if gameState.currentWord.isEmpty {
            performSelector(onMainThread: #selector(startNewGame), with: nil, waitUntilDone: false)
        }
        // otherwise, load data into view
        else {
            performSelector(onMainThread: #selector(loadGameStateView), with: nil, waitUntilDone: false)
        }
    }
    // project 12 challenge 3
    // run on background thread
    @objc private func saveGameState() {
        let encoder = JSONEncoder()
        if let encodedState = try? encoder.encode(gameState) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedState, forKey: gameStateKey)
        }
    }
    // project 12 challenge 3
    // run on main thread
    @objc private func loadGameStateView() {
        title = gameState.currentWord
        tableView.reloadData()
    }
    // run on main thread
    @objc private func startNewGame() {
        gameState.currentWord = allWords.randomElement() ?? "silkworm"
        gameState.usedWords.removeAll(keepingCapacity: true)
        
        // project 12 challenge 3
        DispatchQueue.global().async { [weak self] in
            self?.saveGameState()
            
            DispatchQueue.main.async {
                self?.loadGameStateView()
            }
        }
    }
    
    @objc private func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {
                return
            }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameState.usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = gameState.usedWords[indexPath.row]
        return cell
    }
    
    private func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        // rule out errors first, makes for more readable code
        if !isPossible(word: lowerAnswer) {
            guard let title = title else {
                return
            }
            showErrorMessage(title: "Word not possible", message: "You can't spell that word form \(title.lowercased()).")
            return
        }
        
        if !isOriginal(word: lowerAnswer) {
            showErrorMessage(title: "Word already used", message: "Be more original!")
            return
        }
        if !isReal(word: lowerAnswer) {
            showErrorMessage(title: "Word not recognized", message: """
                        Rules are: word must exist, \
                        must be 3 letters at least, \
                        must be different than original word
                        """)
            return
        }
        // valid word
        gameState.usedWords.insert(lowerAnswer, at: 0)
        // project 12 challenge 3
        DispatchQueue.global().async { [weak self] in
            self?.saveGameState()
            
            DispatchQueue.main.async {
                // could have just called tableView.reloadData() but then the insertion wouldn't have been animated
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    //MARK: - Private
    
    private func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {
            return false
        }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            }
            else {
                return false
            }
        }
        return true
    }
    
    private func isOriginal(word: String) -> Bool {
        return !gameState.usedWords.contains(word)
    }
    
    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        if word.count < 3 {
            return false
        }
        if word == title {
            return false
        }
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
}
