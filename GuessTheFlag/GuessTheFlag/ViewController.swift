//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Ray Varkki on 2025-08-27.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var playerScore = 0
    var correctAnswer = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        countries.append("estonia")
        countries.append("france")
        countries.append("germany")
        countries.append("ireland")
        countries.append("italy")
        countries.append("monaco")
        countries.append("nigeria")
        countries.append("poland")
        countries.append("russia")
        countries.append("spain")
        countries.append("uk")
        countries.append("us")
        
        askQuestion()
    }

    func askQuestion(action : UIAlertAction! = nil) {
        
        if(questionsAsked == 10){
            playerScore = 0
            questionsAsked = 0
        }
        countries.shuffle();
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button1.layer.borderWidth = 1
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button2.layer.borderWidth = 1
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        button3.layer.borderWidth = 1
        
        title = "Score: \(playerScore) Flag to guess : \(countries[correctAnswer].uppercased())"
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        questionsAsked += 1
        var title : String
        if(sender.tag == correctAnswer){
            title = "Correct";
            playerScore += 1
        }else{
            title = "Wrong. You chose \(countries[sender.tag])"
            playerScore -= 1
        }
        let ac = UIAlertController(title: title, message: "Your score is \(playerScore)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        let finalAlert = UIAlertController(title: "Game over", message: "Your final score is \(playerScore)", preferredStyle: .alert)
        if(questionsAsked == 10){
            finalAlert.addAction(UIAlertAction(title: "Start over", style: .default, handler: askQuestion))
            present(finalAlert, animated: true)
        }else{
            present(ac, animated: true)
        }
    }
}

