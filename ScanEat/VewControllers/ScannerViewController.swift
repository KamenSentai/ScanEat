//
//  ViewController.swift
//  test_scan
//
//  Created by Athénaïs Dussordet on 01/04/2019.
//  Copyright © 2019 Athenais Dussordet. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import SwiftyJSON

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var dataIngredients: [String] = []
    var dataChecked: [Bool] = []
    var currentProducts: [Int] = []
    
    var scanner: Scanner?
    
    // Text on camera
    let text: UILabel = {
        let lbl = UILabel()
        lbl.text = "Scannez votre produit"
        lbl.frame = CGRect(x: 105, y: 400, width: 200, height: 44)
        lbl.textColor = .white
        return lbl
    }()
    
    let viewR: UIView = {
        let vR = UIView()
        let rect = CGRect(x: 40, y: 200, width: 300, height: 200)
        vR.frame = rect
        vR.layer.borderWidth = 1.0
        vR.layer.borderColor = UIColor.white.cgColor
        vR.layer.cornerRadius = 10
        return vR
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DB
        let user = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        
        ref.child("users").child(user!).child("ingredients").queryOrderedByKey().observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let data = snapshotValue?["data"] as? String
            
            self.dataIngredients.append(data!)
            
            self.dataChecked.removeAll()
            for _ in self.dataIngredients {
                self.dataChecked.append(false)
            }
        }
        
        ref.child("users").child(user!).child("products").queryOrderedByKey().observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let code = snapshotValue?["code"] as? Int
            
            self.currentProducts.append(code!)
        }
        
        // Scanner
        scanner = Scanner(withViewController: self, view: self.view, codeOutputHandler: self.handleCode(code:))
        
        if let codeScanner = scanner {
            codeScanner.requestCaptureSessionStartRunning()
        }
        
        view.addSubview(text)
        view.addSubview(viewR)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func handleCode(code: String) {
        print(code)
        
        var isAlreadyAdded = false
        for currentProduct in self.currentProducts {
            if "\(currentProduct)" == code {
                isAlreadyAdded = true
            }
        }
        
        if isAlreadyAdded == false {
            for url in self.dataIngredients {
                Alamofire.request(url).responseJSON { (response) in
                    if let realData = response.data {
                        let json = JSON(realData)
                        
                        for product in json["products"].arrayValue {
                            if (product["code"].stringValue == code) {
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
    
}
