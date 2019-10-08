//
//  StartGameViewController.swift
//  WordBuzzer
//
//  Created by Maahi Bhama  on 07/10/19.
//  Copyright © 2019 Mahendra Bhama. All rights reserved.
//

import UIKit

class StartGameViewController: UIViewController {
    
    
    //MARK:- Interface Builder Actions
    
    // Number of Words
    @IBOutlet weak var twentyPlayerButton: UIButton!
    
    @IBOutlet weak var fourtyPlayersButton: UIButton!
    
    @IBOutlet weak var sixtyPlayersButton: UIButton!
    
    @IBOutlet weak var eightyPlayersButton: UIButton!
    
    // Game Start
    @IBOutlet weak var gameStartButton: UIButton!
    
    
    //MARK:- Variables
    
    var selectedNumberOfWordsButton: UIButton? {
        didSet {
            self.selectedNumberOfWordsButton?.setImage(#imageLiteral(resourceName: "checkRound"), for: .normal)
        }
    }
    
    var selectedNumberOfWords: Int = 0
    
    var wordsArray:[Word] = []

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
        self.fetchWordData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.resetUI()
    }
    
    
    //MARK:- Interface Builder Actions
    
    // Number of Words Action
    @IBAction func twentyPlayerButtonAction(_ sender: UIButton) {
        selectedNumberOfWords = 20
        selectNumberOfWordsSenderButton(sender: sender)
    }
    
    @IBAction func fourtyPlayersButtonAction(_ sender: UIButton) {
        selectedNumberOfWords = 40
        selectNumberOfWordsSenderButton(sender: sender)
    }
    
    @IBAction func sixtyPlayersButtonAction(_ sender: UIButton) {
        selectedNumberOfWords = 60
        selectNumberOfWordsSenderButton(sender: sender)
    }
    
    @IBAction func eightyPlayersButtonAction(_ sender: UIButton) {
        selectedNumberOfWords = 80
        selectNumberOfWordsSenderButton(sender: sender)
    }
    
    // Game Start Action
    @IBAction func gameStartButtonAction(_ sender:UIButton) {
        
        if selectedNumberOfWordsButton != nil {
            
            let gameViewController: GameViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            gameViewController.wordsArray = selectedRandomWordsFromWordArray(limit:selectedNumberOfWords)
            gameViewController.allSpanishWords = self.wordsArray.map({ $0.textSpanish })
            self.navigationController?.pushViewController(gameViewController, animated: true)
            
        } else {
           let alert = UIAlertController(title: "Error", message: "Please Select Number of Words.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK:- UI Helper Methods
    func setupUI() {
        
        setUpbuttonSelected(sender: twentyPlayerButton)
        setUpbuttonSelected(sender: fourtyPlayersButton)
        setUpbuttonSelected(sender: sixtyPlayersButton)
        setUpbuttonSelected(sender: eightyPlayersButton)
        
        gameStartButton.layer.cornerRadius = 4.0
    }
    
    func setUpbuttonSelected(sender: UIButton) {
        sender.layer.cornerRadius = 4.0
        sender.setImage(nil, for: .normal)
    }
    
    
    func selectNumberOfWordsSenderButton(sender: UIButton) {
        if let selectedWordsNumber = selectedNumberOfWordsButton {
            selectedWordsNumber.setImage(nil, for: .normal)
        }
        selectedNumberOfWordsButton = sender
    }
    
    func selectedRandomWordsFromWordArray(limit: Int) -> [Word] {
        var randomWordArray:[Word] = []
        for _ in 0..<limit {
            if let randomWord = wordsArray.randomElement() {
                randomWordArray.append(randomWord)
            }
        }
        return randomWordArray
    }
    
    func resetUI() {
        
        if let selectedNumberOfWordsButton = selectedNumberOfWordsButton {
            selectedNumberOfWordsButton.setImage(nil, for: .normal)
            self.selectedNumberOfWordsButton = nil
            self.selectedNumberOfWords = 0
        }
    }
    
    //MARK:- API Helpers
    func fetchWordData() {
        API.getWordsFromJson { (words, error) in
            guard error == nil else {
                
                return
            }
            
            self.wordsArray = words
        }
    }

}
