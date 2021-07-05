//
//  ViewController.swift
//  Project 28-30 Milestone
//
//  Created by Гнатюк Сергей on 25.06.2021.
//

import UIKit

final class ViewController: UIViewController {
    //Dependencies
    lazy var game = ConcentrationGame(numberOfPairsCards: (buttonCollection.count + 1) / 2)
    
    // Properties
    var emojiCollection = ["👇🏼", "🖖", "🎃", "😺", "🦷", "💋", "🦷", "💋", "👇🏼", "🖖", "🎃", "😺", "👮🏻‍♂️", "🧑🏻‍🍳", "👮🏻‍♂️", "🧑🏻‍🍳"].shuffled()
    var emojiDictionary = [Int: String]()
    var touches = 0 {
        didSet {
            touchesLabel.text = "Touches: \(touches)"
        }
    }
    
    // UI
    @IBOutlet var buttonCollection: [UIButton]!
    @IBOutlet weak var touchesLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private
    private func updateViewFromModel() {
        for index in buttonCollection.indices {
            let button = buttonCollection[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emojiIdentifier(for: card), for: .normal)
                button.backgroundColor = .white
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? .clear : .blue
            }
        }
    }
    
    private func emojiIdentifier(for card: Card) -> String {
        if emojiDictionary[card.identifier] == nil {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiCollection.count)))
            emojiDictionary[card.identifier] = emojiCollection.remove(at: randomIndex)
        }
        return emojiDictionary[card.identifier] ?? "?"
    }
    
    // MARK: - Actions
    @IBAction func buttonAction(_ sender: UIButton) {
        touches += 1
        if let buttonIndex = buttonCollection.firstIndex(of: sender) {
            game.chooseCard(at: buttonIndex)
            updateViewFromModel()
        }
    }
}

