//
//  Api.swift
//  WordBuzzer
//
//  Created by Maahi Bhama  on 07/10/19.
//  Copyright © 2019 Mahendra Bhama. All rights reserved.
//

import Foundation

class API {
    
    class func getWordsFromJson(_ completionHandler: (_ result: [Word], _ error: Error?) -> Void) {
        if let path = Bundle.main.path(forResource: "words", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [[String: Any]] {
                    let words = jsonResult.map({ Word($0) })
                    completionHandler(words, nil)
                }
            } catch {
                // handle error
                completionHandler([], error)
            }
        }
    }
}
