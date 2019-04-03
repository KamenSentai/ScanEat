//
//  HistoryViewController.swift
//  ScanEat
//
//  Created by Alain on 03/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit
import FirebaseAuth

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Auth.auth().signIn(withEmail: "alain@gmail.com", password: "alain123²") { (res, err) in
//            if err != nil {
//                print(err.debugDescription)
//            } else {
//                print("Logged in with alain@gmail.com")
//            }
//        }
//        
//        if let user = Auth.auth().currentUser {
//            
//        } else {
//            fatalError("Aucun utilisateur connecté")
//        }
        
        // Navigation
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

}
