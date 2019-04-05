//
//  CategoryViewController.swift
//  ScanEat
//
//  Created by Alain on 05/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var titleCatgory: String = ""
    var dataCategory: String = ""
    var products: [[String: String]] = [[:]]

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation
        let backButton = UIBarButtonItem()
        backButton.title = "Retour"
        navigationController?.isNavigationBarHidden = false
        
        // Collection view
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
        
        // UI
        titleLabel.text = self.titleCatgory
        
        // Model
        self.products.removeAll()
        let suggestionManager = SuggestionManager(dataUrl: self.dataCategory, limitCount: 25)
        suggestionManager.fetchSuggestions { (suggestionsFromJSON) in
            for suggestionFromJSON in suggestionsFromJSON {
                self.products.append([
                    "name": suggestionFromJSON.name,
                    "brand": suggestionFromJSON.brand,
                    "image": suggestionFromJSON.image
                ])
            }
            self.productsCollectionView.reloadData()
        }
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
        
        productCollectionViewCell.titleLabel.text = self.products[indexPath.row]["name"]
        productCollectionViewCell.subtitleLabel.text = self.products[indexPath.row]["brand"]
        
        if let urlImage = URL(string: self.products[indexPath.row]["image"]!) {
            productCollectionViewCell.imageView.af_setImage(withURL: urlImage)
        }
        
        return productCollectionViewCell
    }

}
