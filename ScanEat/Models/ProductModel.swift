//
//  ProductModel.swift
//  ScanEat
//
//  Created by Alain on 04/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductModel: NSObject {
    
    var name: String = ""
    var brand: String = ""
    var image: String = ""
    
    init(name: String, brand: String, image: String) {
        self.name = name
        self.brand = brand
        self.image = image
    }
    
    init(json: JSON) {
        self.name = json["product_name_fr"].stringValue
        self.brand = json["brands"].stringValue
        self.image = json["image_small_url"].stringValue
    }
    
}
