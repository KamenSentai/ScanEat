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
    
    var scanner:Scanner?
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.red.cgColor,
            UIColor.green.cgColor
        ]
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scanner = Scanner(withViewController: self, view: self.view, codeOutputHandler: self.handleCode(code:))
        
        if let codeScanner = scanner {
            codeScanner.requestCaptureSessionStartRunning()
        }
        
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    func handleCode(code:String) {
        print(code)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
    
    
    
}
