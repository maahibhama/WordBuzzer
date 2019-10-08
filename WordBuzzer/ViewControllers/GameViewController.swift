//
//  ViewController.swift
//  WordBuzzer
//
//  Created by Maahi Bhama  on 04/10/19.
//  Copyright © 2019 Mahendra Bhama. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    
    //MARK:- Interface Builder Outlets
    
    @IBOutlet weak var mainView: UIView!
    
    //First Player
    @IBOutlet weak var firstPlayerButton: UIButton!
    @IBOutlet weak var firstPlayerNameLabel: UILabel!
    @IBOutlet weak var firstPlayerScoreLabel: UILabel!
    @IBOutlet weak var firstPlayerRWImage: UIImageView!
    @IBOutlet weak var firstPlayerPrizeImageView: UIImageView!
    
    //Second Player
    @IBOutlet weak var secondPlayerButton: UIButton!
    @IBOutlet weak var secondPlayerNameLabel: UILabel!
    @IBOutlet weak var secondPlayerScoreLabel: UILabel!
    @IBOutlet weak var secondPlayerRWImage: UIImageView!
    @IBOutlet weak var secondPlayerPrizeImageView: UIImageView!
    
    //Third Player
    @IBOutlet weak var thirdPlayerButton: UIButton!
    @IBOutlet weak var thirdPlayerNameLabel: UILabel!
    @IBOutlet weak var thirdPlayerScoreLabel: UILabel!
    @IBOutlet weak var thirdPlayerRWImage: UIImageView!
    @IBOutlet weak var thirdPlayerPrizeImageView: UIImageView!
    
    //Fourth Player
    @IBOutlet weak var fourthPlayerButton: UIButton!
    @IBOutlet weak var fourthPlayerNameLabel: UILabel!
    @IBOutlet weak var fourthPlayerScoreLabel: UILabel!
    @IBOutlet weak var fourthPlayerRWImage: UIImageView!
    @IBOutlet weak var fourthPlayerPrizeImageView: UIImageView!
    
    //main Label
    @IBOutlet weak var mainWordLabel: UILabel!
    
    @IBOutlet weak var numberOfWordLabel: UILabel!
    
    // randon Word Button
    @IBOutlet weak var randomWordButton: UIButton!
    
    @IBOutlet weak var randomWordConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextWordButton: UIButton!
    
    @IBOutlet weak var endGameButton: UIButton!
    
    
    //MARK:- Variables
    var wordsArray:[Word] = [] 
    
    var numberOfPlayer: Int = 4
    
    //Player Score Model
    var playerArray:[Player] = []
    
    var buttonSelectedTime:[String:Date] = [:]
    
    var taskStartTimer: Timer = Timer()
    
    var winnerPlayer: Player? {
        didSet {
            self.hidePrizePlayer(expectPlayer: self.winnerPlayer)
        }
    }
    
    var isFirstTime: Bool = true {
        didSet{
            let title = self.isFirstTime ? "Start Game" : "Next Word"
            self.nextWordButton.setTitle(title, for: .normal)
            endGameButton.isHidden = self.isFirstTime
            if self.isFirstTime == false {
                self.navigationItem.setHidesBackButton(true, animated:true);
            }
        }
    }
    
    var wordCount: Int = 0 {
        didSet{
            if wordsArray.count >= self.wordCount, self.wordCount >= 0 {
                self.currentWord = wordsArray[self.wordCount - 1]
                self.numberOfWordLabel.text = "Number of Words:  \(self.wordCount)/\(self.wordsArray.count)"
            } else if wordsArray.count < self.wordCount {
                self.endGame()
            }
        }
    }
    
    var currentWord: Word? {
        didSet {
            if let currentWord = self.currentWord {
                mainWordLabel.text = currentWord.textEnglish.uppercased()
                self.setRandomSapanishWords(selectedWord: currentWord)
            }
        }
    }
    
    var randomSpanishWords:[String] = []{
        didSet{
            seenIndex = []
            self.currentRandomWord = chooseRandom()
        }
    }
    
    var allSpanishWords:[String] = []
    
    var invalidPlayerListTillNextWord:[Player] = [] {
        didSet{
            self.updateEliminatePlayerImageView()
            
        }
    }
    
    var currentRandomWord: String = "" {
        didSet {
            self.moveNameOffScreen()
            self.randomWordButton.fadeOut(completion: {
                (finished: Bool) -> Void in
                self.randomWordButton.isHidden = false
            self.randomWordButton.setTitle(self.currentRandomWord, for: .normal)
                self.randomWordButton.fadeIn(1.0) { (_) in
                    
                    self.moveNameOnScreen()
                }
            })
        }
    }
    
    var seenIndex = [Int]()
    
    var isOnGameScreen = true
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInitialUI()
        
        self.setUpPlayer()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isOnGameScreen = false
    }
    
    
    //MARK:- Interface Builder Actions
    @IBAction func firstButtonAction(_ sender: UIButton) {
        firstPlayerButton.isSelected = !sender.isSelected
        if let player = playerArray.first {
        buttonSelectedTime[player.id] = Date()
        }
    }
    
    @IBAction func secondButtonAction(_ sender: UIButton) {
        secondPlayerButton.isSelected = !sender.isSelected
        if playerArray.count > 1 {
            let player = playerArray[1]
            buttonSelectedTime[player.id] = Date()
        }
    }
    
    @IBAction func thirdButtonAction(_ sender: UIButton) {
        thirdPlayerButton.isSelected = !sender.isSelected
        if playerArray.count > 2 {
            let player = playerArray[2]
            buttonSelectedTime[player.id] = Date()
        }
    }

    @IBAction func fourthButtonAction(_ sender: UIButton) {
        fourthPlayerButton.isSelected = !sender.isSelected
        if playerArray.count > 3 {
            let player = playerArray[3]
            buttonSelectedTime[player.id] = Date()
        }
    }
    
    @IBAction func randomWordButtonAction(_ sender: UIButton) {
        self.startTimer()
    }
    
    @IBAction func nextWordButtonAction(_ sender: UIButton) {
        self.nextWord()
    }
    
    @IBAction func endGameButtonAction(_ sender: UIButton) {
        self.endGame()
    }
    
    @objc func timerAction() {
        
        if self.isRightTranslation(){
            self.randomWordButton.setTitleColor(.black, for: .normal)
            self.randomWordButton.backgroundColor = .green
            if self.buttonSelectedTime.count > 0 {
                self.whoClickedFirst()
            }else {
                self.showPopOverView()
                self.disableAllPlayerInteractionTillNextWord()
                self.hideShowAllImageView(isHidden: false)
                self.setAllPlayerWrongAnswer()
            }
        } else if self.buttonSelectedTime.count > 0 && self.invalidPlayerListTillNextWord.count != 4 {
            disableUserInteractionTillNextWord()
            if self.invalidPlayerListTillNextWord.count != 4 {
                self.currentRandomWord = chooseRandom()
                self.buttonSelectedTime = [:]
                self.startTimer()
            }else {
               self.showPopOverView()
            }
        }else {
            self.currentRandomWord = chooseRandom()
            self.buttonSelectedTime = [:]
            self.startTimer()
        }
    }
    
    
    //MARK:- Helper Methods
    func setupInitialUI(){
        randomWordButton.layer.cornerRadius = randomWordButton.frame.height / 2.0
        randomWordButton.isUserInteractionEnabled = false
        nextWordButton.layer.cornerRadius = 4.0
        endGameButton.layer.cornerRadius = 4.0
        if isFirstTime {
            endGameButton.isHidden = isFirstTime
            nextWordButton.setTitle("Start Game", for: .normal)
            disableAllPlayerInteractionTillNextWord()
        } else {
            self.navigationItem.setHidesBackButton(true, animated:true);
        }
        mainWordLabel.text = ""
        randomWordButton.setTitle("", for: .normal)
        randomWordButton.isHidden = true
        self.numberOfWordLabel.text = "Number of Words:  \(self.wordCount)/\(self.wordsArray.count)"
    }
    
    func setUpPlayer() {
        let players:[Player] = [
            Player(id: "1", name: "1st Player", score: 0),
            Player(id: "2", name: "2nd Player", score: 0),
            Player(id: "3", name: "3rd Player", score: 0),
            Player(id: "4", name: "4th Player", score: 0),
        ]
        playerArray.append(contentsOf: players)
        updatePlayerInfo()
        hideShowAllImageView(isHidden: true)
        hidePrizePlayer()
    }
    
    func whoClickedFirst() {
        disableAllPlayerInteractionTillNextWord(withoutAlpha: true)
        let sortedArray = self.buttonSelectedTime.sorted{ $0.value < $1.value }
        
        if let first = sortedArray.first {
            let firstKey = first.key
            
            let filterPlayers = playerArray.filter({ $0.id == firstKey })
            
            if let selectedPlayer = filterPlayers.first {
                selectedPlayer.score = selectedPlayer.score + 1
                winnerPlayer = selectedPlayer
                updatePlayerInfo()
                allPlayerAnswerRightOrWrong()
            }
        }
    }
    
    func startTimer() {
        self.taskStartTimer.invalidate()
        self.taskStartTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: false)
    }
    
    func updatePlayerInfo() {
        for i in 0..<playerArray.count {
            let player = playerArray[i]
            let playerName = player.name
            let playerScore = scoreLabel(score: playerArray[i].score)
            switch i {
            case 0:
                firstPlayerNameLabel.text = playerName
                firstPlayerScoreLabel.text = playerScore
            case 1:
                secondPlayerNameLabel.text = playerName
                secondPlayerScoreLabel.text = playerScore
            case 2:
                thirdPlayerNameLabel.text = playerName
                thirdPlayerScoreLabel.text = playerScore
            case 3:
                fourthPlayerNameLabel.text = playerName
                fourthPlayerScoreLabel.text = playerScore
            default:
                print("hello")
            }
        }
        hideShowAllImageView(isHidden: false)
    }
    
    func scoreLabel(score: Int) -> String {
        return "Score: \(score)"
    }
    
    func removePlayerData() {
        self.buttonSelectedTime = [:]
        firstPlayerButton.isSelected = false
        secondPlayerButton.isSelected = false
        thirdPlayerButton.isSelected = false
        fourthPlayerButton.isSelected = false
    }
    
    func hideShowAllImageView(isHidden: Bool) {
        firstPlayerRWImage.isHidden = isHidden
        secondPlayerRWImage.isHidden = isHidden
        thirdPlayerRWImage.isHidden = isHidden
        fourthPlayerRWImage.isHidden = isHidden
    }
    
    func allPlayerAnswerRightOrWrong() {
        self.setAllPlayerWrongAnswer()
        self.hideShowAllImageView(isHidden: false)
        for (key, _) in self.buttonSelectedTime {
            switch key {
            case "1":
                playerImageSet(imageView: firstPlayerRWImage, isAnswerRight: true)
            case "2":
                playerImageSet(imageView: secondPlayerRWImage, isAnswerRight: true)
            case "3":
                playerImageSet(imageView: thirdPlayerRWImage, isAnswerRight: true)
            case "4":
                playerImageSet(imageView: fourthPlayerRWImage, isAnswerRight: true)
            default:
                print("")
            }
        }
    }
    
    func updateEliminatePlayerImageView() {
        for player in self.invalidPlayerListTillNextWord {
            switch player.id {
            case "1":
                playerImageSet(imageView: firstPlayerRWImage, isAnswerRight: false)
                firstPlayerRWImage.isHidden = false
            case "2":
                playerImageSet(imageView: secondPlayerRWImage, isAnswerRight: false)
                secondPlayerRWImage.isHidden = false
            case "3":
                playerImageSet(imageView: thirdPlayerRWImage, isAnswerRight: false)
                thirdPlayerRWImage.isHidden = false
            case "4":
                playerImageSet(imageView: fourthPlayerRWImage, isAnswerRight: false)
                fourthPlayerRWImage.isHidden = false
            default:
                print("")
            }
        }
    }
    
    func setAllPlayerWrongAnswer() {
        playerImageSet(imageView: firstPlayerRWImage, isAnswerRight: false)
        playerImageSet(imageView: secondPlayerRWImage, isAnswerRight: false)
        playerImageSet(imageView: thirdPlayerRWImage, isAnswerRight: false)
        playerImageSet(imageView: fourthPlayerRWImage, isAnswerRight: false)
    }
    
    func playerImageSet(imageView: UIImageView, isAnswerRight: Bool) {
        if isAnswerRight {
            imageView.image = #imageLiteral(resourceName: "checkRound")
            imageView.tintColor = .green
        } else {
            imageView.image = #imageLiteral(resourceName: "cancelRound")
            imageView.tintColor = .red
        }
    }
    
    func hidePrizePlayer(expectPlayer: Player? = nil) {
        self.firstPlayerPrizeImageView.isHidden = true
        self.secondPlayerPrizeImageView.isHidden = true
        self.thirdPlayerPrizeImageView.isHidden = true
        self.fourthPlayerPrizeImageView.isHidden = true
        
        guard let player = expectPlayer else {
            return
        }
        
        switch player.id {
        case "1":
            self.firstPlayerPrizeImageView.isHidden = false
        case "2":
            self.secondPlayerPrizeImageView.isHidden = false
        case "3":
            self.thirdPlayerPrizeImageView.isHidden = false
        case "4":
            self.fourthPlayerPrizeImageView.isHidden = false
        default:
            print("wrong Item")
        }
    }
    
    func setRandomSapanishWords(_ limit:Int = 5, selectedWord: Word) {
        var randomWord:[String] = []
        randomWord.append(selectedWord.textSpanish)
        for _ in 0..<limit-1 {
            if let newWord = self.allSpanishWords.randomElement() {
                randomWord.append(newWord)
            }
        }
        
        self.randomSpanishWords = randomWord
    }
    
    func isRightTranslation() -> Bool {
        if let currentWord = currentWord, currentWord.textSpanish == currentRandomWord {
            return true
        }
        
        return false
    }
    
    func enableUserInteractionAllPlayer() {
        playerButtonEnable(button: firstPlayerButton, isEnable: true)
        
        playerButtonEnable(button: secondPlayerButton, isEnable: true)
        
        playerButtonEnable(button: thirdPlayerButton, isEnable: true)
        
        playerButtonEnable(button: fourthPlayerButton, isEnable: true)
    }
    
    func disableAllPlayerInteractionTillNextWord(withoutAlpha: Bool = false) {
        playerButtonEnable(button: firstPlayerButton, isEnable: false, withoutAlpha: withoutAlpha)

        playerButtonEnable(button: secondPlayerButton, isEnable: false, withoutAlpha: withoutAlpha)
        
        playerButtonEnable(button: thirdPlayerButton, isEnable: false, withoutAlpha: withoutAlpha)
        
        playerButtonEnable(button: fourthPlayerButton, isEnable: false, withoutAlpha: withoutAlpha)
    }
    
    func disableUserInteractionTillNextWord() {
        var disbalePlayer:[Player] = invalidPlayerListTillNextWord
        for (key, _) in self.buttonSelectedTime {
            switch key {
            case "1":
                playerButtonEnable(button: firstPlayerButton, isEnable: false)
                disbalePlayer.append(playerArray[0])
            case "2":
                playerButtonEnable(button: secondPlayerButton, isEnable: false)
                disbalePlayer.append(playerArray[1])
            case "3":
                playerButtonEnable(button: thirdPlayerButton, isEnable: false)
                disbalePlayer.append(playerArray[2])
            case "4":
                playerButtonEnable(button: fourthPlayerButton, isEnable: false)
                disbalePlayer.append(playerArray[3])
            default:
                print("Invalid")
            }
        }
        self.invalidPlayerListTillNextWord = disbalePlayer
    }
    
    func playerButtonEnable(button: UIButton, isEnable: Bool, withoutAlpha: Bool = false) {
        button.isUserInteractionEnabled = isEnable
        button.alpha = isEnable || withoutAlpha ? 1.0 : 0.3
    }
    
    func endGame() {
        let endGameViewController: EndGameViewController = self.storyboard?.instantiateViewController(withIdentifier: "EndGameViewController") as! EndGameViewController
        let sortedArray = playerArray.sorted{ $0.score > $1.score }
        if let first = sortedArray.first, first.score > 0 {
            endGameViewController.winnerPlayer = first
        }
        endGameViewController.numberOfWords = wordsArray.count
        self.navigationController?.pushViewController(endGameViewController, animated: true)
    }
    
    //MARK: - Random Element
    
    func chooseRandom() -> String {

        if seenIndex.count == randomSpanishWords.count { return "" } //we don't want to process if we have all items accounted for (Can handle this somewhere else)

        let index = Int(arc4random_uniform(UInt32(randomSpanishWords.count))) //get the random index

        //check if this index is already seen by us
        if seenIndex.contains(index) {
            return chooseRandom() //repeat
        }

        //if not we get the element out and add that index to seen
        let requiredItem = randomSpanishWords[index]
        seenIndex.append(index)
        return requiredItem
    }
    
    func moveNameOffScreen() {
        self.disableAllPlayerInteractionTillNextWord()
        self.randomWordConstraint.constant = -50
        self.view.layoutIfNeeded()
    }
    
    func moveNameOnScreen() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1.0) {
            self.enableThoseWhoAreNotDisableTillNextWord()
            self.randomWordConstraint.constant = 150
            self.view.layoutIfNeeded()
        }
    }
    
    func enableThoseWhoAreNotDisableTillNextWord(){
        var enablePlayers = playerArray
        let disablePlayer = invalidPlayerListTillNextWord
        enablePlayers = Array(Set(enablePlayers).subtracting(disablePlayer))
        for player in enablePlayers {
            switch player.id {
            case "1":
                playerButtonEnable(button: firstPlayerButton, isEnable: true)
            case "2":
                playerButtonEnable(button: secondPlayerButton, isEnable: true)
            case "3":
                playerButtonEnable(button: thirdPlayerButton, isEnable: true)
            case "4":
                playerButtonEnable(button: fourthPlayerButton, isEnable: true)
            default:
                print("Invalid")
            }
        }
    }
    
    func nextWord() {
        self.randomWordButton.backgroundColor = .black
        self.randomWordButton.setTitleColor(.white, for: .normal)
        self.isFirstTime = false
        self.removePlayerData()
        self.hideShowAllImageView(isHidden: true)
        self.winnerPlayer = nil
        self.wordCount += 1
        self.invalidPlayerListTillNextWord = []
        //self.enableUserInteractionAllPlayer()
        self.startTimer()
    }
    
    //
    func showPopOverView() {
        guard isOnGameScreen else {
            return
        }
        let popOverVC: PopUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        popOverVC.currentWordsNumber = wordCount
        popOverVC.numberOfWords = self.wordsArray.count
        popOverVC.word = currentWord
        popOverVC.onClickNextButton = {  
            self.nextWord()
        }
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController?.present(popOverVC, animated: true)
            
    }
}

