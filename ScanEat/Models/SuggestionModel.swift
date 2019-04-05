//
//  SuggestionModel.swift
//  ScanEat
//
//  Created by Alain on 05/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit
import SwiftyJSON

class SuggestionModel: NSObject {
    
    var name: String = ""
    var brand: String = ""
    var image: String = ""
    
    init(name: String, brand: String, image: String) {
        self.name = name
        self.brand = brand
        self.image = image
    }
    
    init(json: JSON) {
        self.name = json["product_name"].stringValue
        self.brand = json["brands"].stringValue
        self.image = json["image_url"].stringValue
    }

}
