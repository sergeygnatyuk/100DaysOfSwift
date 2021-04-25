//
//  ViewController.swift
//  Project 7 - 9 Milestone
//
//  Created by Гнатюк Сергей on 23.04.2021.
//

import UIKit

class ViewController: UIViewController {
 
    let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    let wordsToSolve = ["SWIFT", "BRAVE", "PASSION", "MOTIVATION"]
    
    var answerLabel: UILabel!

    var letterButtons = [UIButton]()
    
    var life = 7
    
    var wordToGuess = ""
    
    
    var hiddenWord = "" {
        didSet {
            answerLabel.text = "\(hiddenWord)"
        }
    }
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .cyan
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(scoreInGame))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadGame))
        
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 30)
        answerLabel.text = randomWord()
        view.addSubview(answerLabel)
        
        let letterButtonsView = UIView()
        letterButtonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(letterButtonsView)
        letterButtonsView.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
        
            answerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 35),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
            letterButtonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            letterButtonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0),
            letterButtonsView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1),
            letterButtonsView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.4),
  
        
        ])
        let width = 73
        let height = 55

        for row in 0..<5 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 34)
                letterButton.setTitle("A", for: .normal)

                let frame = CGRect(x: width * col, y: height * row, width: width, height: height)
                letterButton.frame = frame

                letterButtons.append(letterButton)
                letterButtonsView.addSubview(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGame()
       
    }
    
    func nameTheButtons() {
        
        for btn in letterButtons {
            btn.isHidden = false
        }
        for button in 0..<letterButtons.count {
            letterButtons[button].setTitle(alphabet[button], for: .normal)
        }
        
    }
    
    func randomWord() -> String {
        
        wordToGuess = wordsToSolve.randomElement()!

        hiddenWord = wordToGuess

        hiddenWord.removeAll(keepingCapacity: true)
        
        for _ in 0..<wordToGuess.count {
            hiddenWord.append("?")
        }
        
        return hiddenWord
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
 
        let title = Character(buttonTitle)

        for letter in wordToGuess {

            if letter == title {
        
                guard let index = wordToGuess.firstIndex(of: title) else { return }

                guard let lastIndex = wordToGuess.lastIndex(of: title) else { return }

                hiddenWord.remove(at: index)
    
                hiddenWord.insert(title, at: index)
       
                hiddenWord.remove(at: lastIndex)
                hiddenWord.insert(title, at: lastIndex)
            
                answerLabel.text = hiddenWord

                sender.isHidden = true
                
            }
            
            if !hiddenWord.contains("?") {
                let alert = UIAlertController(title: "You win!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Play New Game", style: .default, handler: { [weak self] action in
                    self?.loadGame()
                }))
                present(alert, animated: true)
            }
        }
        
        if !wordToGuess.contains(buttonTitle) {

            life -= 1

            sender.isHidden = true

            if life <= 0 {
                
                let alert = UIAlertController(title: "Game Over", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again!", style: .cancel, handler: { [weak self ] action in
                    self?.loadGame()
                }))
                present(alert, animated: true)
 
            }
            
        }
    }
    
    @objc func loadGame() {
        
        life = 7
        nameTheButtons()
        answerLabel.text = randomWord()
    }
    
    @objc func scoreInGame() {
        let title = "Your lives"
        let message = "\(life)"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .cancel))
        present(alertController, animated: true)
        }
    
   

    
    
}
