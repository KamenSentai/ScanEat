//
//  SelectionViewController.swift
//  ScanEat
//
//  Created by Alain on 03/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import AlamofireImage

class SelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    
    var ingredients: [[String: Any]] = [[:]]
    var data: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        ingredientsCollectionView.delegate = self
        ingredientsCollectionView.dataSource = self
        ingredientsCollectionView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
        
        // Model
        self.ingredients.removeAll()
        let ref = Database.database().reference()
        ref.child("ingredients").queryOrderedByKey().observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue?["name"] as? String
            let data = snapshotValue?["data"] as? String
            let image = snapshotValue?["image"] as? String
            
            self.ingredients.append([
                "selected": false,
                "name": name as Any,
                "data": data as Any,
                "image": image as Any
            ])
            
            self.ingredientsCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ingredientCollectionViewCell = ingredientsCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        
        // UI
        var cellHeight = 44.0
        
        if let layout = self.ingredientsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellWidth = self.ingredientsCollectionView.collectionViewLayout.collectionViewContentSize.width / 3 - 15
            cellHeight = Double(cellWidth * 1.25)
            layout.sectionInset = UIEdgeInsets(top: 50, left: 5, bottom: 15, right: 5)
            layout.itemSize = CGSize(width: cellWidth, height: CGFloat(cellHeight))
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 20
        }
        
        ingredientCollectionViewCell.backgroundColor = UIColor.white
        ingredientCollectionViewCell.layer.cornerRadius = CGFloat(15)
        ingredientCollectionViewCell.layer.shadowColor = UIColor.black.cgColor
        ingredientCollectionViewCell.layer.shadowOffset = CGSize(width: 0, height: 5)
        ingredientCollectionViewCell.layer.shadowRadius = 5
        ingredientCollectionViewCell.layer.shadowOpacity = 0.125
        ingredientCollectionViewCell.layer.masksToBounds = false
        
        ingredientCollectionViewCell.barVew.backgroundColor = UIColor(rgb: 0x969696)
        ingredientCollectionViewCell.titleLabel.textColor = UIColor(rgb: 0x7F4830)
        
        ingredientCollectionViewCell.titleLabel.text = self.ingredients[indexPath.row]["name"] as? String
        
        if let urlImage = URL(string: self.ingredients[indexPath.row]["image"] as! String) {
            ingredientCollectionViewCell.imageView.af_setImage(withURL: urlImage)
        }
        
        return ingredientCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ingredientCollectionViewCell = ingredientsCollectionView.cellForItem(at: indexPath)! as! CardCollectionViewCell
        
        if self.ingredients[indexPath.row]["selected"] as! Bool == false {
            self.ingredients[indexPath.row]["selected"] = true
            
            ingredientCollectionViewCell.layer.backgroundColor = UIColor(rgb: 0xFB8D5E).cgColor
           
            ingredientCollectionViewCell.barVew.backgroundColor = UIColor.white
            ingredientCollectionViewCell.titleLabel.textColor = UIColor.white
        } else {
            self.ingredients[indexPath.row]["selected"] = false
            
            ingredientCollectionViewCell.layer.backgroundColor = UIColor.white.cgColor
           
            ingredientCollectionViewCell.barVew.backgroundColor = UIColor(rgb: 0x969696)
            ingredientCollectionViewCell.titleLabel.textColor = UIColor(rgb: 0x7F4830)
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: self.data["email"]!, password: self.data["password"]!) { (res, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                var activeIngredients: [[String: String]] = [[:]]
                activeIngredients.removeAll()
                
                for ingredient in self.ingredients {
                    if ingredient["selected"] as! Bool == true {
                        activeIngredients.append([
                            "name": ingredient["name"] as! String,
                            "data": ingredient["data"] as! String,
                            "image": ingredient["image"] as! String
                        ])
                    }
                }
                
                let ref = Database.database().reference()
                let user = Auth.auth().currentUser?.uid
                
                ref.child("users").child(user!).setValue([
                    "lastname": self.data["lastname"]!,
                    "firstname": self.data["firstname"]!,
                    "ingredients": activeIngredients
                ])
                
                let myStoryboard = UIStoryboard(name: "Main", bundle : nil)
                let tabBarController = myStoryboard.instantiateViewController(withIdentifier : "TabBarController")
                self.present(tabBarController, animated: true, completion: nil)
            }
        }
    }
    
}
