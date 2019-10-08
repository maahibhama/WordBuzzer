//
//  EndGameViewController.swift
//  WordBuzzer
//
//  Created by Maahi Bhama  on 07/10/19.
//  Copyright © 2019 Mahendra Bhama. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    //MARK:- Interface Builder Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var winnerNameLabel: UILabel!
    @IBOutlet weak var winnerScoreLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    
    @IBOutlet weak var startNewGameButton: UIButton!
    
    
    //MARK:- Variables
    var winnerPlayer: Player? 
    var numberOfWords: Int = 0
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    
    //MARK:- Interface Builder Actions
    @IBAction func startNewGameButtonAction(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK:- Helper
    func setUpUI() {
        self.navigationItem.setHidesBackButton(true, animated:true)
        if let player = winnerPlayer {
            winnerNameLabel.text = player.name
            winnerScoreLabel.text = "Score: \(player.score)/\(numberOfWords)"
            winnerLabel.text = "Winner"
            imageView.image = #imageLiteral(resourceName: "winnerLogo")
        }else {
            imageView.image = #imageLiteral(resourceName: "sadLogo")
            winnerNameLabel.isHidden = true
            winnerScoreLabel.isHidden = true
            winnerLabel.text = "No Winner"
        }
    }
    
}
