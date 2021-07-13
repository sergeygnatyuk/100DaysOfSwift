//
//  ViewController.swift
//  Project2
//
//  Created by Гнатюк Сергей on 01.04.2021.
//

import UIKit

final class ViewController: UIViewController {
    
    // UI
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    // Properties
    private var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco",
                             "nigeria", "poland", "russia", "spain", "uk", "us"]
    private var score = 0
    // project 12 challenge 2
    private var highestScore = -1
    private var highestScoreKey = "HighestScore"
    private var correctAnswer = 0
    private var currentQuestion = 0
    // challenge 2
    private let maxQuestion = 5
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        // project 3 challenge 3
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(scoreTapped))
        
        // project 12 challenge 2
        let userDefaults = UserDefaults.standard
        highestScore = userDefaults.object(forKey: highestScoreKey) as? Int ?? -1
        askQuestion()
    }
    
    //MARK: - Private
    
    
    private func askQuestion(action: UIAlertAction! = nil) {
        currentQuestion += 1
        // challenge 2
        if currentQuestion > maxQuestion {
            showResult()
            return
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        // challenge 1
        updateTitle()
    }
    // challenge 2
    private func showResult() {
        var message = "Questions asked: \(maxQuestion)\nFinal score: \(score)"
        // project 12 challenge 2
        var mustSaveHighestScore = false
        if score > highestScore {
            message += "\n\nNEW HIGH SCORE!\nPrevious high score: \(highestScore)"
            highestScore = score
            mustSaveHighestScore = true
        }
        let ac = UIAlertController(title: "End of the game", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Restart game", style: .default, handler: askQuestion))
        
        score = 0
        correctAnswer = 0
        currentQuestion = 0
        present(ac, animated: true)
        // project 12 challenge 2
        if mustSaveHighestScore {
            performSelector(inBackground: #selector(saveHighestScore), with: nil)
        }
    }
    // challenge 1
    private func updateTitle() {
        title = "\(countries[correctAnswer].uppercased())? - Score [\(score)] - \(currentQuestion)/\(maxQuestion)"
    }
    
    //MARK: - @objc methods
    // project 12 challenge 2
    @objc func saveHighestScore() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(highestScore, forKey: highestScoreKey)
    }
    // project 3 challenge 3
    @objc func scoreTapped() {
        let ac = UIAlertController(title: "Score", message: String(score), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    //MARK: - Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        //project 15 challenge 3
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 2, y: 2)
            sender.transform = .identity
        })
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            message = "Score: \(score)"
        } else {
            title = "Wrong"
            score -= 1
            // challenge 3
            message = """
                You picked: \(countries[sender.tag].uppercased())
                Flag of \(countries[correctAnswer].uppercased()) was: #\(correctAnswer + 1)
                Score: \(score)
                """
        }
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        // update title before presenting the alert to have a matching score in the titlebar
        updateTitle()
        present(ac, animated: true)
    }
    
    // MARK: - Public
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            switch response.actionIdentifier {
            case "Launch":
                print("Launch \(customData)")
            default:
                break
            }
        }
        completionHandler()
    }
    // project21 challenge 1
    private func showAlertController(message: String) {
        let alertController = UIAlertController(title: "ActionIdentifier Message", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertController, animated: true)
    }
}


