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
    
    @IBOutlet weak var progressBar: LinearProgressView!
    
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
    
    var allSpanishWords:[String] = []
    
    //Player Score Model
    private var playerArray:[Player] = []
    
    private var selectedPlayersWithTime:[String:Date] = [:]
    
    private var taskStartTimer: Timer = Timer()
    
    private var winnerPlayer: Player? {
        didSet {
            self.hidePrizePlayer(expectPlayer: self.winnerPlayer)
        }
    }
    
    private var isFirstTime: Bool = true {
        didSet{
            let title = self.isFirstTime ? AppConstants.StartGame : AppConstants.NextWord
            self.nextWordButton.setTitle(title, for: .normal)
            endGameButton.isHidden = self.isFirstTime
            if self.isFirstTime == false {
                self.navigationItem.setHidesBackButton(true, animated:true);
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
        }
    }
    
    private var wordCount: Int = 0 {
        didSet{
            if wordsArray.count >= self.wordCount, self.wordCount >= 0 {
                self.currentWord = wordsArray[self.wordCount - 1]
                self.numberOfWordLabel.text = AppConstants.numberOfWord(self.wordCount, total: self.wordsArray.count)
            } else if wordsArray.count < self.wordCount {
                self.endGame()
            }
        }
    }
    
    private var currentWord: Word? {
        didSet {
            if let currentWord = self.currentWord {
                mainWordLabel.text = currentWord.textEnglish.uppercased()
                self.setRandomSapanishWords(selectedWord: currentWord)
            }
        }
    }
    
    private var randomSpanishWords:[String] = []{
        didSet{
            seenIndex = []
            self.currentRandomWord = chooseRandom()
        }
    }
    
    private var invalidPlayerListTillNextWord:[Player] = [] {
        didSet{
            self.updateEliminatePlayerImageView()
            
        }
    }
    
    private var currentRandomWord: String = "" {
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
    
    private var seenIndex = [Int]()
    
    private var isOnGameScreen = true
    
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
   @objc func infoButtonAction(_ sender: UIBarButtonItem) {
         let instructionVC: InstructionViewController = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.InstructionViewController) as! InstructionViewController
        self.navigationController?.pushViewController(instructionVC, animated: true)
    }
    
    @IBAction func firstButtonAction(_ sender: UIButton) {
        firstPlayerButton.isSelected = !sender.isSelected
        if let player = playerArray.first {
            selectedPlayersWithTime[player.id] = Date()
        }
    }
    
    @IBAction func secondButtonAction(_ sender: UIButton) {
        secondPlayerButton.isSelected = !sender.isSelected
        if playerArray.count > 1 {
            let player = playerArray[1]
            selectedPlayersWithTime[player.id] = Date()
        }
    }
    
    @IBAction func thirdButtonAction(_ sender: UIButton) {
        thirdPlayerButton.isSelected = !sender.isSelected
        if playerArray.count > 2 {
            let player = playerArray[2]
            selectedPlayersWithTime[player.id] = Date()
        }
    }
    
    @IBAction func fourthButtonAction(_ sender: UIButton) {
        fourthPlayerButton.isSelected = !sender.isSelected
        if playerArray.count > 3 {
            let player = playerArray[3]
            selectedPlayersWithTime[player.id] = Date()
        }
    }
    
    @IBAction func randomWordButtonAction(_ sender: UIButton) {
        self.startTimer()
    }
    
    @IBAction func nextWordButtonAction(_ sender: UIButton) {
        self.nextWord()
    }
    
    @IBAction func endGameButtonAction(_ sender: UIButton) {
        self.taskStartTimer.invalidate()
        let alert = UIAlertController(title: AppConstants.QuitGameMessage, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: AppConstants.Yes, style: .default) { (_) in
            self.endGame()
        }
        alert.addAction(action)
        
        let cancelAction = UIAlertAction(title: AppConstants.No, style: .cancel) { (_) in
            self.nextWord()
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK:- Timer Function Actions
    private func startTimer() {
        self.taskStartTimer.invalidate()
        self.taskStartTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: false)
    }
    
    @objc func timerAction() {
        if self.isRightTranslation(){
            self.randomWordButton.setTitleColor(.black, for: .normal)
            self.randomWordButton.backgroundColor = .green
            if self.selectedPlayersWithTime.count > 0 {
                self.whoClickedFirst()
            }else {
                self.showPopOverView()
                self.disableAllPlayerInteractionTillNextWord()
                self.hideShowAllImageView(isHidden: false)
                self.setAllPlayerWrongAnswer()
            }
        } else if self.selectedPlayersWithTime.count > 0 && self.invalidPlayerListTillNextWord.count != 4 {
            disableUserInteractionTillNextWord()
            if self.invalidPlayerListTillNextWord.count != 4 {
                self.currentRandomWord = chooseRandom()
                self.selectedPlayersWithTime = [:]
                self.startTimer()
            }else {
                self.showPopOverView()
            }
        }else {
            self.currentRandomWord = chooseRandom()
            self.selectedPlayersWithTime = [:]
            self.startTimer()
        }
    }
    
    
    //MARK:- Helper UI Methods
    private func setupInitialUI(){
        
        let infoButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "info"), style: .plain, target: self, action: #selector(infoButtonAction))
        infoButton.tintColor = #colorLiteral(red: 0.3681181669, green: 0.1824730039, blue: 0.903453052, alpha: 1)
        navigationItem.rightBarButtonItem = infoButton
        
        randomWordButton.layer.cornerRadius = randomWordButton.frame.height / 2.0
        randomWordButton.isUserInteractionEnabled = false
        nextWordButton.layer.cornerRadius = 4.0
        endGameButton.layer.cornerRadius = 4.0
        if isFirstTime {
            endGameButton.isHidden = isFirstTime
            nextWordButton.setTitle(AppConstants.StartGame, for: .normal)
            disableAllPlayerInteractionTillNextWord()
        } else {
            self.navigationItem.setHidesBackButton(true, animated:true);
        }
        mainWordLabel.text = ""
        randomWordButton.setTitle("", for: .normal)
        randomWordButton.isHidden = true
        self.numberOfWordLabel.text = AppConstants.numberOfWord(self.wordCount, total: self.wordsArray.count)
        progressBar.animationDuration = 3.0
    }
    
    private func nextWord() {
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
    
    private func updatePlayerInfo() {
        for i in 0..<playerArray.count {
            let player = playerArray[i]
            let playerName = player.name
            let playerScore = AppConstants.scoreLabel(score: playerArray[i].score)
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
                print("")
            }
        }
        hideShowAllImageView(isHidden: false)
    }
    
    
    //MARK:- Player Wrong/Right/Prize Image View Methods
    private func hideShowAllImageView(isHidden: Bool) {
        firstPlayerRWImage.isHidden = isHidden
        secondPlayerRWImage.isHidden = isHidden
        thirdPlayerRWImage.isHidden = isHidden
        fourthPlayerRWImage.isHidden = isHidden
    }
    
    private func allPlayerAnswerRightOrWrong() {
        self.setAllPlayerWrongAnswer()
        self.hideShowAllImageView(isHidden: false)
        for (key, _) in self.selectedPlayersWithTime {
            switch key {
            case AppConstants.FirstPlayerKey:
                playerImageSet(imageView: firstPlayerRWImage, isAnswerRight: true)
            case AppConstants.SecondPlayerKey:
                playerImageSet(imageView: secondPlayerRWImage, isAnswerRight: true)
            case AppConstants.ThirdPlayerKey:
                playerImageSet(imageView: thirdPlayerRWImage, isAnswerRight: true)
            case AppConstants.FourthPlayerKey:
                playerImageSet(imageView: fourthPlayerRWImage, isAnswerRight: true)
            default:
                print("")
            }
        }
    }
    private func updateEliminatePlayerImageView() {
        for player in self.invalidPlayerListTillNextWord {
            switch player.id {
            case AppConstants.FirstPlayerKey:
                playerImageSet(imageView: firstPlayerRWImage, isAnswerRight: false)
                firstPlayerRWImage.isHidden = false
            case AppConstants.SecondPlayerKey:
                playerImageSet(imageView: secondPlayerRWImage, isAnswerRight: false)
                secondPlayerRWImage.isHidden = false
            case AppConstants.ThirdPlayerKey:
                playerImageSet(imageView: thirdPlayerRWImage, isAnswerRight: false)
                thirdPlayerRWImage.isHidden = false
            case AppConstants.FourthPlayerKey:
                playerImageSet(imageView: fourthPlayerRWImage, isAnswerRight: false)
                fourthPlayerRWImage.isHidden = false
            default:
                print("")
            }
        }
    }
    
    private func setAllPlayerWrongAnswer() {
        playerImageSet(imageView: firstPlayerRWImage, isAnswerRight: false)
        playerImageSet(imageView: secondPlayerRWImage, isAnswerRight: false)
        playerImageSet(imageView: thirdPlayerRWImage, isAnswerRight: false)
        playerImageSet(imageView: fourthPlayerRWImage, isAnswerRight: false)
    }
    
    private func hidePrizePlayer(expectPlayer: Player? = nil) {
        self.firstPlayerPrizeImageView.isHidden = true
        self.secondPlayerPrizeImageView.isHidden = true
        self.thirdPlayerPrizeImageView.isHidden = true
        self.fourthPlayerPrizeImageView.isHidden = true
        
        guard let player = expectPlayer else {
            return
        }
        
        switch player.id {
        case AppConstants.FirstPlayerKey:
            self.firstPlayerPrizeImageView.isHidden = false
        case AppConstants.SecondPlayerKey:
            self.secondPlayerPrizeImageView.isHidden = false
        case AppConstants.ThirdPlayerKey:
            self.thirdPlayerPrizeImageView.isHidden = false
        case AppConstants.FourthPlayerKey:
            self.fourthPlayerPrizeImageView.isHidden = false
        default:
            print("wrong Item")
        }
    }
    
    
    //MARK:- Buzzer Button Interaction Methods
    private func enableUserInteractionAllPlayer() {
        playerButtonEnable(button: firstPlayerButton, isEnable: true)
        
        playerButtonEnable(button: secondPlayerButton, isEnable: true)
        
        playerButtonEnable(button: thirdPlayerButton, isEnable: true)
        
        playerButtonEnable(button: fourthPlayerButton, isEnable: true)
    }
    
    private func disableAllPlayerInteractionTillNextWord(withoutAlpha: Bool = false) {
        playerButtonEnable(button: firstPlayerButton, isEnable: false, withoutAlpha: withoutAlpha)
        
        playerButtonEnable(button: secondPlayerButton, isEnable: false, withoutAlpha: withoutAlpha)
        
        playerButtonEnable(button: thirdPlayerButton, isEnable: false, withoutAlpha: withoutAlpha)
        
        playerButtonEnable(button: fourthPlayerButton, isEnable: false, withoutAlpha: withoutAlpha)
    }
    
    private func disableUserInteractionTillNextWord() {
        var disbalePlayer:[Player] = invalidPlayerListTillNextWord
        for (key, _) in self.selectedPlayersWithTime {
            switch key {
            case AppConstants.FirstPlayerKey:
                playerButtonEnable(button: firstPlayerButton, isEnable: false)
                disbalePlayer.append(playerArray[0])
            case AppConstants.SecondPlayerKey:
                playerButtonEnable(button: secondPlayerButton, isEnable: false)
                disbalePlayer.append(playerArray[1])
            case AppConstants.ThirdPlayerKey:
                playerButtonEnable(button: thirdPlayerButton, isEnable: false)
                disbalePlayer.append(playerArray[2])
            case AppConstants.FourthPlayerKey:
                playerButtonEnable(button: fourthPlayerButton, isEnable: false)
                disbalePlayer.append(playerArray[3])
            default:
                print("Invalid")
            }
        }
        self.invalidPlayerListTillNextWord = disbalePlayer
    }
    
    private func enableThoseWhoAreNotDisableTillNextWord(){
           var enablePlayers = playerArray
           let disablePlayer = invalidPlayerListTillNextWord
           enablePlayers = Array(Set(enablePlayers).subtracting(disablePlayer))
           for player in enablePlayers {
               switch player.id {
               case AppConstants.FirstPlayerKey:
                   playerButtonEnable(button: firstPlayerButton, isEnable: true)
               case AppConstants.SecondPlayerKey:
                   playerButtonEnable(button: secondPlayerButton, isEnable: true)
               case AppConstants.ThirdPlayerKey:
                   playerButtonEnable(button: thirdPlayerButton, isEnable: true)
               case AppConstants.FourthPlayerKey:
                   playerButtonEnable(button: fourthPlayerButton, isEnable: true)
               default:
                   print("")
               }
           }
       }
    
    
    //MARK:- Random Word Animation Methods
    private func moveNameOffScreen() {
        self.disableAllPlayerInteractionTillNextWord()
        self.randomWordConstraint.constant = -80
        self.view.layoutIfNeeded()
        progressBar.setProgress(0, animated: false)
    }
    
    private func moveNameOnScreen() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1.0) {
            self.enableThoseWhoAreNotDisableTillNextWord()
            self.randomWordConstraint.constant = 150
            self.view.layoutIfNeeded()
        }
        progressBar.setProgress(1, animated: true)
    }
    
    
    //MARK:- Player Methods
    private func setUpPlayer() {
        let players:[Player] = [
            Player(id: AppConstants.FirstPlayerKey, name: "1st Player", score: 0),
            Player(id: AppConstants.SecondPlayerKey, name: "2nd Player", score: 0),
            Player(id: AppConstants.ThirdPlayerKey, name: "3rd Player", score: 0),
            Player(id: AppConstants.FourthPlayerKey, name: "4th Player", score: 0),
        ]
        playerArray.append(contentsOf: players)
        updatePlayerInfo()
        hideShowAllImageView(isHidden: true)
        hidePrizePlayer()
    }
    
    private func removePlayerData() {
        self.selectedPlayersWithTime = [:]
        firstPlayerButton.isSelected = false
        secondPlayerButton.isSelected = false
        thirdPlayerButton.isSelected = false
        fourthPlayerButton.isSelected = false
    }
    
    private func whoClickedFirst() {
        disableAllPlayerInteractionTillNextWord(withoutAlpha: true)
        let sortedArray = self.selectedPlayersWithTime.sorted{ $0.value < $1.value }
        
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
    
    
    //MARK:- Helper Methods
    private func playerImageSet(imageView: UIImageView, isAnswerRight: Bool) {
        if isAnswerRight {
            imageView.image = #imageLiteral(resourceName: "checkRound")
            imageView.tintColor = .green
        } else {
            imageView.image = #imageLiteral(resourceName: "cancelRound")
            imageView.tintColor = .red
        }
    }
    
    private func playerButtonEnable(button: UIButton, isEnable: Bool, withoutAlpha: Bool = false) {
        button.isUserInteractionEnabled = isEnable
        button.alpha = isEnable || withoutAlpha ? 1.0 : 0.3
    }
    
    
    //MARK:- Words Methods
    private func setRandomSapanishWords(_ limit:Int = 5, selectedWord: Word) {
        var randomWord:[String] = []
        randomWord.append(selectedWord.textSpanish)
        for _ in 0..<limit-1 {
            if let newWord = self.allSpanishWords.randomElement() {
                randomWord.append(newWord)
            }
        }
        self.randomSpanishWords = randomWord
    }
    
    private func isRightTranslation() -> Bool {
        if let currentWord = currentWord, currentWord.textSpanish == currentRandomWord {
            return true
        }
        return false
    }
    
    
    //MARK: - End Game
    private func endGame() {
        let endGameViewController: EndGameViewController = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.EndGameViewController) as! EndGameViewController
        let sortedArray = playerArray.sorted{ $0.score > $1.score }
        if let first = sortedArray.first, first.score > 0 {
            endGameViewController.winnerPlayer = first
        }
        endGameViewController.numberOfWords = wordsArray.count
        self.navigationController?.pushViewController(endGameViewController, animated: true)
    }
    
    
    //MARK: - Random Element
    private func chooseRandom() -> String {
        if seenIndex.count == randomSpanishWords.count { return "" }
        let index = Int(arc4random_uniform(UInt32(randomSpanishWords.count)))
        if seenIndex.contains(index) {
            return chooseRandom()
        }
        let requiredItem = randomSpanishWords[index]
        seenIndex.append(index)
        return requiredItem
    }
    
    
    //MARK:- PopUp View
    private func showPopOverView() {
        guard isOnGameScreen else {
            return
        }
        let popOverVC: PopUpViewController = self.storyboard?.instantiateViewController(withIdentifier: AppConstants.PopUpViewController) as! PopUpViewController
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

