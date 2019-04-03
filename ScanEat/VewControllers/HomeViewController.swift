//
//  HomeViewController.swift
//  ScanEat
//
//  Created by Alain on 02/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var plusView: UIView!
    @IBOutlet weak var verticalPlusView: UIView!
    @IBOutlet weak var horizontalPlusView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI
        loginButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        loginButton.layer.cornerRadius = 25
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        loginButton.layer.shadowRadius = 10
        loginButton.layer.shadowOpacity = 0.25
        plusView.layer.cornerRadius = 35
        plusView.layer.shadowColor = UIColor.black.cgColor
        plusView.layer.shadowOffset = CGSize(width: 0, height: 5)
        plusView.layer.shadowRadius = 10
        plusView.layer.shadowOpacity = 0.25
        verticalPlusView.layer.cornerRadius = 1
        horizontalPlusView.layer.cornerRadius = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle : nil)
        let registerStoryboard = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        navigationController?.pushViewController(registerStoryboard, animated: true)
    }
    
}
