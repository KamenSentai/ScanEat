//
//  ViewController.swift
//  test_scan
//
//  Created by Athénaïs Dussordet on 01/04/2019.
//  Copyright © 2019 Athenais Dussordet. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
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
    
    func handleCode(code:String) {
        print(code)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
    
}
