//
//  Player.swift
//  WordBuzzer
//
//  Created by Maahi Bhama  on 05/10/19.
//  Copyright © 2019 Mahendra Bhama. All rights reserved.
//

import Foundation

class Player: NSObject {
    
    var id: String = ""
    var name: String = ""
    var score: Int = 0
    
    
    init(id: String, name: String, score: Int) {
        self.id = id
        self.name = name
        self.score = score
    }
}
