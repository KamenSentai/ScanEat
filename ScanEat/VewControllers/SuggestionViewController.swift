//
//  SuggestionViewController.swift
//  ScanEat
//
//  Created by Alain on 03/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import AlamofireImage

class SuggestionViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation
        navigationController?.isNavigationBarHidden = true
        
        // Model
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser?.uid
        
        // UI
        photoImageView.layer.cornerRadius = 22
        photoImageView.layer.masksToBounds = true
        
        ref.child("users").child(user!).observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let image = snapshotValue?["image"] as? String

            if image != nil && image != "" {
                if let urlImage = URL(string: image!) {
                    self.photoImageView.af_setImage(withURL: urlImage)
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

}
