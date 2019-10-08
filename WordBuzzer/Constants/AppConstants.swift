//
//  AppConstants.swift
//  WordBuzzer
//
//  Created by Maahi Bhama  on 06/10/19.
//  Copyright © 2019 Mahendra Bhama. All rights reserved.
//

import Foundation

struct AppConstants {
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
}
