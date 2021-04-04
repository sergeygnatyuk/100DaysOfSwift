//
//  ViewController.swift
//  Project2
//
//  Created by Гнатюк Сергей on 01.04.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var countries = [String]()
    var score = 0
    var positiveAnswers = 0
    var negativeAnswers = 0
    var correctAnswer = 0
    var allAsks = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia","france","germany","ireland","italy",
                      "monaco","nigeria","poland","russia","spain","uk","us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
    }
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        allAsks += 1
        title = countries[correctAnswer].uppercased()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title: String
        if sender.tag == correctAnswer {
            title = "Correct"
            positiveAnswers += 1
            score += 1
            scoreLabel.text =  "Your score is \(score)"
        } else {
            title = "Wrong, is flag \(countries[sender.tag].uppercased())"
            negativeAnswers += 1
            score -= 1
            scoreLabel.text =  "Your score is \(score)"
        }
        if allAsks == 5 {
            title = "You give \(allAsks) answers, positive answers \(positiveAnswers), negative answers \(negativeAnswers)"
            scoreLabel.text =  "Score"
            allAsks = 0
            positiveAnswers = 0
            negativeAnswers = 0
            score = 0
        }
        
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: askQuestion))
        present(alertController, animated: true)
        
    }
}

