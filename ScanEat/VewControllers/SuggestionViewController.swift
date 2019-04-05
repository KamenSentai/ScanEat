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

class SuggestionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var categories: [[String: String]] = [[:]]

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation
        navigationController?.isNavigationBarHidden = true
        
        // Collection
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
        
        // Model
        self.categories.removeAll()
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser?.uid
        
        ref.child("users").child(user!).child("ingredients").queryOrderedByKey().observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue?["name"] as? String
            let data = snapshotValue?["data"] as? String
            let image = snapshotValue?["image"] as? String
            
            self.categories.append([
                "name": name!,
                "data": data!,
                "image": image!
                ])
            
            self.categoriesCollectionView.reloadData()
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
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCollectionViewCell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        
        // UI
        var cellHeight = 44.0
        
        if let layout = self.categoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellWidth = self.categoriesCollectionView.collectionViewLayout.collectionViewContentSize.width / 2 - 15
            cellHeight = Double(cellWidth * 1.25)
            layout.sectionInset = UIEdgeInsets(top: 50, left: 5, bottom: 15, right: 5)
            layout.itemSize = CGSize(width: cellWidth, height: CGFloat(cellHeight))
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 20
        }
        
        categoryCollectionViewCell.backgroundColor = UIColor.white
        categoryCollectionViewCell.layer.cornerRadius = CGFloat(15)
        categoryCollectionViewCell.layer.shadowColor = UIColor.black.cgColor
        categoryCollectionViewCell.layer.shadowOffset = CGSize(width: 0, height: 5)
        categoryCollectionViewCell.layer.shadowRadius = 5
        categoryCollectionViewCell.layer.shadowOpacity = 0.125
        categoryCollectionViewCell.layer.masksToBounds = false
        
        categoryCollectionViewCell.barVew.backgroundColor = UIColor(rgb: 0x969696)
        categoryCollectionViewCell.titleLabel.textColor = UIColor(rgb: 0x7F4830)
        categoryCollectionViewCell.titleLabel.text = self.categories[indexPath.row]["name"]
        
        if let urlImage = URL(string: self.categories[indexPath.row]["image"]!) {
            categoryCollectionViewCell.imageView.af_setImage(withURL: urlImage)
        }
        
        return categoryCollectionViewCell
    }

}
