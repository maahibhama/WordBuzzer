//
//  PopUpViewController.swift
//  WordBuzzer
//
//  Created by Maahi Bhama  on 08/10/19.
//  Copyright © 2019 Mahendra Bhama. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var questionWordLabel: UILabel!
    
    @IBOutlet weak var answerWordLabel: UILabel!
    
    @IBOutlet weak var numberOfWordLabel: UILabel!
    
    @IBOutlet weak var nextWordButton: UIButton!
    
    
    //MARK:- Variables
    var word: Word?
    
    var currentWordsNumber: Int = 0
    var numberOfWords: Int = 0
    
    var onClickNextButton:(() -> Void)?
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 10.0
        popUpView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        popUpView.layer.shadowColor = UIColor.black.cgColor
        
        if let word = word {
            self.questionWordLabel.text = word.textEnglish
            self.answerWordLabel.text = word.textSpanish
        }
        self.numberOfWordLabel.text = AppConstants.numberOfWord(self.currentWordsNumber, total: self.numberOfWords)
    }
    
    
    //MARK:- Interface Builder Actions
    @IBAction func nextWordButtonAction(_ sender: UIButton) {
        if let onClickNextButton = onClickNextButton {
            onClickNextButton()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
