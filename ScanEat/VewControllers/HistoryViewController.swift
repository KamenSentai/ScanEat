//
//  HistoryViewController.swift
//  ScanEat
//
//  Created by Alain on 03/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import AlamofireImage

class HistoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var products: [[String: Any]] = [[:]]

    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().signIn(withEmail: "alain@gmail.com", password: "Alain123") { (res, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                print("Logged in with alain@gmail.com")
            }
        }
        
//        // Check log
//        if let user = Auth.auth().currentUser {
//
//        } else {
//            fatalError("Aucun utilisateur connecté")
//        }
        
        // Navigation
        navigationController?.isNavigationBarHidden = true
        
        // Collection
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
        
        // Model
        self.products.removeAll()
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser?.uid
        ref.child("users").child(user!).child("products").queryOrderedByKey().observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let code = snapshotValue?["code"] as? Int
            let alert = snapshotValue?["alert"] as? Bool
            
            self.products.append([
                "code": code as Any,
                "alert": alert as Any
            ])
            
            self.productsCollectionView.reloadData()
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productCollectionViewCell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        
        // UI
        var cellHeight = 44.0
        
        if let layout = self.productsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellWidth = self.productsCollectionView.collectionViewLayout.collectionViewContentSize.width / 2 - 15
            cellHeight = Double(cellWidth * 1.25)
            layout.sectionInset = UIEdgeInsets(top: 50, left: 5, bottom: 15, right: 5)
            layout.itemSize = CGSize(width: cellWidth, height: CGFloat(cellHeight))
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 20
        }
        
        productCollectionViewCell.backgroundColor = UIColor.white
        productCollectionViewCell.layer.cornerRadius = CGFloat(15)
        productCollectionViewCell.layer.shadowColor = UIColor.black.cgColor
        productCollectionViewCell.layer.shadowOffset = CGSize(width: 0, height: 5)
        productCollectionViewCell.layer.shadowRadius = 5
        productCollectionViewCell.layer.shadowOpacity = 0.125
        productCollectionViewCell.layer.masksToBounds = false
        
        productCollectionViewCell.backgrounView.layer.cornerRadius = CGFloat(15)
        productCollectionViewCell.backgrounView.layer.masksToBounds = true
        productCollectionViewCell.barVew.backgroundColor = UIColor(rgb: 0x969696)
        productCollectionViewCell.titleLabel.textColor = UIColor(rgb: 0x7F4830)
        productCollectionViewCell.subtitleLabel.textColor = UIColor(rgb: 0x969696)
        productCollectionViewCell.topBarView.backgroundColor = self.products[indexPath.row]["alert"] as! Bool == false ? UIColor(rgb: 0x00DC3E) : UIColor(rgb: 0xF62401)
        
        let products = ProductManager(code: self.products[indexPath.row]["code"] as! Int)
        products.fetchProduct { (productFromJSON) in
            productCollectionViewCell.titleLabel.text = productFromJSON.name
            productCollectionViewCell.subtitleLabel.text = productFromJSON.brand
    
            if let urlImage = URL(string: productFromJSON.image) {
                productCollectionViewCell.imageView.af_setImage(withURL: urlImage)
            }
        }
        
        return productCollectionViewCell
    }

}
