//
//  ViewController.swift
//  milestoneProjectTwo
//
//  Created by Ray Varkki on 2025-09-15.
//

import UIKit

class ViewController: UIViewController {

    var wordPair = [String]()
    var guessesLeft : UILabel!
    var hiddenWordLabel : UILabel!
    var guessButton : UIButton!
    var cluesLabel : UILabel!
    var answer = [Character]()
    var currentGuessedAnswer = [Character]() {
        didSet{
                hiddenWordLabel.text = String(currentGuessedAnswer)
            }
    }
    
    
    
    var remainingGuesses = 0  {
        didSet{
            guessesLeft.text = "Guesses left : \(remainingGuesses)"
        }
    }
    
    override func loadView(){
        view = UIView()
        view.backgroundColor = .white
        
        guessesLeft = UILabel()
        guessesLeft.translatesAutoresizingMaskIntoConstraints = false
        guessesLeft.textAlignment = .right
        guessesLeft.text = "Guesses left : \(remainingGuesses)"
        view.addSubview(guessesLeft)
        
        guessButton = UIButton(type: .system)
        guessButton.translatesAutoresizingMaskIntoConstraints = false
        guessButton.setTitle("Guess Letter", for: .normal)
        guessButton.titleLabel?.textAlignment = .right
        guessButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
        guessButton.addTarget(self, action: #selector(guessLetter), for: .touchUpInside)
        view.addSubview(guessButton)

        hiddenWordLabel = UILabel()
        hiddenWordLabel.translatesAutoresizingMaskIntoConstraints = false
        hiddenWordLabel.text = "????"
        hiddenWordLabel.font = UIFont(name: "Helvetica", size: 36)
        view.addSubview(hiddenWordLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.text = "Clue: "
        view.addSubview(cluesLabel)
        
        NSLayoutConstraint.activate([guessesLeft.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                                     guessesLeft.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                                     
                                     guessButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -5),
                                     guessButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                                     
                                     hiddenWordLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
                                     hiddenWordLabel.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor, constant: 0),
                                     
                                     cluesLabel.bottomAnchor.constraint(equalTo: hiddenWordLabel.topAnchor, constant: -200),
                                     cluesLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor)
                                    ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    
    func loadLevel(){
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            guard let self else {return}
            if let levelUrl = Bundle.main.url(forResource: "hangman_words", withExtension: "txt"){
                if let levelString = try? String(contentsOf: levelUrl, encoding: .utf8){
                    let allOptions = levelString.components(separatedBy: "\n")
                    if let wordPair = allOptions.shuffled().randomElement()?.split(separator: "-"){
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let self else {return}
                            remainingGuesses = 7
                            cluesLabel.text! = "Clue: " + String(wordPair[1])
                            currentGuessedAnswer = []
                            answer = Array(wordPair[0])
                            for _ in answer {
                                currentGuessedAnswer.append("?")
                            }
                        }
                    }
                }
            }
        }

    }

    
    @objc func guessLetter(){
        
        let ac = UIAlertController(title: "Enter Letter", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default){
            
            [weak self, ac] action in
            guard let self else {return}
            guard let answer = ac.textFields?[0].text else {return}
            self.checkLetter(Character(answer))
        }
        ac.addTextField {
            [weak self] field in
            guard let self else {return}
            field.placeholder = "Enter one letter"
            field.addAction(.init(handler: {
                [weak self, weak field, weak alertAction] action in
                guard let self, let field, let alertAction else {return}
                self.setAlertTextField(field, alertAction)
            }), for: .editingChanged)
        }

        alertAction.isEnabled = false
        ac.addAction(alertAction)
        present(ac, animated: true)
    }
    
    @objc func setAlertTextField(_ textField: UITextField, _ alertAction : UIAlertAction){
        
        if let text = textField.text, text.count > 0 {
            textField.text = String(text.prefix(1))
            alertAction.isEnabled = true
        }else{
            alertAction.isEnabled = false
        }
    }
    
    func checkLetter(_ letter : Character){
        var guessedCorrectly = false
        for (i, _) in answer.enumerated() {
            if(answer[i] == letter){
                guessedCorrectly = true
                currentGuessedAnswer[i] = letter
            }
        }
        if(String(currentGuessedAnswer) == String(answer)){
                let ac = UIAlertController(title: "You guessed the word!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Next word", style: .default){
                    [weak self] action in
                    guard let self else {return}
                    loadLevel()
                })
                present(ac, animated: true)
        }
        if (!guessedCorrectly){
                self.remainingGuesses -= 1
                if(remainingGuesses == 0 ){
                    let ac = UIAlertController(title: "You Lose!", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default){
                        [weak self] _ in
                        guard let self else {return}
                        self.loadLevel()
                    })
                    present(ac, animated: true)
                }
        }
    }
}

