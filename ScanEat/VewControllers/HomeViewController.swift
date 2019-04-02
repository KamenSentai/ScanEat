//
//  HomeViewController.swift
//  ScanEat
//
//  Created by Alain on 02/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class HomeViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var titleButton: UILabel!
    @IBOutlet weak var subtitleButton: UILabel!
    @IBOutlet weak var verticalPlusView: UIView!
    @IBOutlet weak var horizontalPlusView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI
        loginButton.backgroundColor = UIColor(rgb: 0xFFFFFF)
        loginButton.layer.cornerRadius = 25
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        loginButton.layer.shadowRadius = 10
        loginButton.layer.shadowOpacity = 0.25
        loginButton.backgroundColor = UIColor(rgb: 0xFFFFFF)
        registerButton.layer.cornerRadius = 35
        registerButton.layer.shadowColor = UIColor.black.cgColor
        registerButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        registerButton.layer.shadowRadius = 10
        registerButton.layer.shadowOpacity = 0.25
        conditionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleButton.font = UIFont.boldSystemFont(ofSize: 26.0)
        subtitleButton.text = subtitleButton.text!.uppercased()
        verticalPlusView.layer.cornerRadius = 2
        horizontalPlusView.layer.cornerRadius = 2
    }
}
