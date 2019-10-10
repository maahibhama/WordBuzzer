//
//  AppConstants.swift
//  WordBuzzer
//
//  Created by Maahi Bhama  on 06/10/19.
//  Copyright © 2019 Mahendra Bhama. All rights reserved.
//

import Foundation

struct AppConstants {
    static let NumberOfWord = "Number of Words"
    static let TwentyWords = "20 Words"
    static let FortyWords = "40 Words"
    static let SixtyWords = "60 Words"
    static let EightyWords = "80 Words"
    
    static let FirstPlayerKey = "1"
    static let SecondPlayerKey = "2"
    static let ThirdPlayerKey = "3"
    static let FourthPlayerKey = "4"
    
    static let GameViewController = "GameViewController"
    static let EndGameViewController = "EndGameViewController"
    static let PopUpViewController = "PopUpViewController"
    
    static let Error = "Error"
    static let SelecteNumberOfWordsMessage = "Please Select Number of Words."
    
    static let OK = "Ok"
    
    static let StartGame = "Start Game"
    static let NextWord = "Next Word"
    
    static func numberOfWord(_ value: Int, total: Int) -> String {
        return "Number of Words:  \(value)/\(total)"
    }
    
    static func scoreLabel(score: Int) -> String {
        return "Score: \(score)"
    }
    
    static let Winner = "Winner"
    
    static func scoreOutOff(score: Int, total: Int) -> String {
        return "Score: \(score)/\(total)"
    }
    
    static let NoWinner = "No Winner"
    
    static let QuitGameMessage = "Are you sure you want to quit?"
    
    static let Yes = "Yes"
    static let No = "No"
    
    static let InstructionViewController = "InstructionViewController"
    static let InstructionTableViewCell = "InstructionTableViewCell"
    
    static let GameInstruction: [String] = [
    "1. First Select Number of Words from available options.",
    "2. Click on Start Game it will navigate you to Game Screen.",
    "3. After Coming on Game Screen, decide to be any one of the four players and tap the respective buzzer when the game starts.",
    "4. Click on Start Game Button.",
    "5. On starting the game an English word will appear in the middle of the screen.",
    "6. A Spanish word will animate down to screen which may or may not be correct translation to a given English word.",
    "7. The user has to tap on the buzzer if he finds the translation to be correct.",
    "8. The user has 3 seconds to make a decision and tap buzzer after that buzzer will get disable.",
    "9. If the user taps for the correct translation and is also the first one to tap on the buzzer he/she will be awarded one point. And then the user has to click on Next Word to start again.",
    "10. Pop will appear to confirm the translated word for picked English word when no user is able to guess the translation.",
    "11. As pop up disappear user can select the Next word to start again.",
    "12. After completion of the game. The winner will be shown on the winner screen with the score.",
    "13. Users can also quit the game. The winner will announce according to the user's score."
    ]
}
