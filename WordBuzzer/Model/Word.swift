//
//  Word.swift
//  WordBuzzer
//
//  Created by Maahi Bhama  on 05/10/19.
//  Copyright © 2019 Mahendra Bhama. All rights reserved.
//

import Foundation

class Word: NSObject {
    
    var textEnglish: String = ""
    var textSpanish: String = ""
    
    init(textEnglish: String, textSpanish: String) {
        self.textEnglish = textEnglish
        self.textSpanish = textSpanish
    }
    
    init(_ json: [String: Any]) {
        self.textEnglish = json["text_eng"] as! String
        self.textSpanish = json["text_spa"] as! String
    }
}
