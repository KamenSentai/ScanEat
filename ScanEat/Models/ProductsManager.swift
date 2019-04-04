//
//  ProductManager.swift
//  ScanEat
//
//  Created by Alain on 04/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProductManager: NSObject {
    
    var code: Int = 0
    
    init(code: Int) {
        self.code = code
    }
    
    public func fetchProduct(completionHandler: @escaping (ProductModel) -> ()) {
        let url = "https://fr.openfoodfacts.org/api/v0/produit/\(self.code).json"

        Alamofire.request(url).responseJSON { (response) in
            if let realData = response.data {
                let json = JSON(realData)

                let productJSON = json["product"]
                
                let product: ProductModel = ProductModel(json: productJSON)
                
                completionHandler(product)
            }
        }
    }
    
}
