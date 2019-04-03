//
//  SelectionViewController.swift
//  ScanEat
//
//  Created by Alain on 03/04/2019.
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

class SelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    var items: [[String: Any]] = [[:]]
    var data: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.data)
        
        // Navigation
        let backButton = UIBarButtonItem()
        backButton.title = "Retour"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        // UI
        logoView.layer.cornerRadius = 35
        registerButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        registerButton.layer.cornerRadius = 25
        registerButton.layer.shadowColor = UIColor.black.cgColor
        registerButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        registerButton.layer.shadowRadius = 10
        registerButton.layer.shadowOpacity = 0.25
        
        // Collection
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
        
        // Model
        self.items = [
            ["selected": false, "type": "Porc"],
            ["selected": false, "type": "Lactose"],
            ["selected": false, "type": "Caféïne"],
            ["selected": false, "type": "Sésame"],
            ["selected": false, "type": "Soja"],
            ["selected": false, "type": "Œuf"]
        ]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCollectionViewCell = itemsCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        
        // UI
        var cellHeight = 44.0
        
        if let layout = self.itemsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellWidth = self.itemsCollectionView.collectionViewLayout.collectionViewContentSize.width / 3 - 15
            cellHeight = Double(cellWidth * 1.25)
            layout.sectionInset = UIEdgeInsets(top: 50, left: 5, bottom: 15, right: 5)
            layout.itemSize = CGSize(width: cellWidth, height: CGFloat(cellHeight))
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 20
        }
        
        itemCollectionViewCell.backgroundColor = UIColor.white
        itemCollectionViewCell.layer.cornerRadius = CGFloat(15)
        itemCollectionViewCell.layer.shadowColor = UIColor.black.cgColor
        itemCollectionViewCell.layer.shadowOffset = CGSize(width: 0, height: 5)
        itemCollectionViewCell.layer.shadowRadius = 5
        itemCollectionViewCell.layer.shadowOpacity = 0.125
        itemCollectionViewCell.layer.masksToBounds = false
        
        itemCollectionViewCell.barVew.backgroundColor = UIColor(rgb: 0x969696)
        itemCollectionViewCell.titleLabel.textColor = UIColor(rgb: 0x7F4830)
        
        itemCollectionViewCell.titleLabel.text = self.items[indexPath.row]["type"] as? String
        
        return itemCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemCollectionViewCell = itemsCollectionView.cellForItem(at: indexPath)! as! ItemCollectionViewCell
        
        if self.items[indexPath.row]["selected"] as! Bool == false {
            self.items[indexPath.row]["selected"] = true
            
            itemCollectionViewCell.layer.backgroundColor = UIColor(rgb: 0xFB8D5E).cgColor
           
            itemCollectionViewCell.barVew.backgroundColor = UIColor.white
            itemCollectionViewCell.titleLabel.textColor = UIColor.white
        } else {
            self.items[indexPath.row]["selected"] = false
            
            itemCollectionViewCell.layer.backgroundColor = UIColor.white.cgColor
           
            itemCollectionViewCell.barVew.backgroundColor = UIColor(rgb: 0x969696)
            itemCollectionViewCell.titleLabel.textColor = UIColor(rgb: 0x7F4830)
        }
    }
    
}
