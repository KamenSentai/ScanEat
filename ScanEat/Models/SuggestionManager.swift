//
//  SuggestionManager.swift
//  ScanEat
//
//  Created by Alain on 05/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SuggestionManager: NSObject {
    
    var dataUrl: String = ""
    var limitCount: Int = 25
    
    init(dataUrl: String, limitCount: Int) {
        self.dataUrl = dataUrl
        self.limitCount = limitCount
    }
    
    public func fetchSuggestions(completionHandler: @escaping ([SuggestionModel]) -> ()) {
        let url = self.dataUrl
        
        Alamofire.request(url).responseJSON { (response) in
            if let realData = response.data {
                let json = JSON(realData)
                
                var suggestions: [SuggestionModel] = [SuggestionModel]()
                var count: Int = 0
                
                for suggestionJSON in json["products"].arrayValue {
                    if count < self.limitCount {
                        let suggestion = SuggestionModel(json: suggestionJSON)
                        
                        suggestions.append(suggestion)
                        count = count + 1
                    }
                }
                
                completionHandler(suggestions)
            }
        }
    }

}
