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
        self.ingredients = [
            ["selected": false, "type": "Porc"],
            ["selected": false, "type": "Lactose"],
            ["selected": false, "type": "Caféïne"],
            ["selected": false, "type": "Sésame"],
            ["selected": false, "type": "Soja"],
            ["selected": false, "type": "Œuf"]
        ]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ingredientCollectionViewCell = ingredientsCollectionView.dequeueReusableCell(withReuseIdentifier: "IngredientCollectionViewCell", for: indexPath) as! IngredientCollectionViewCell
        
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
        
        ingredientCollectionViewCell.titleLabel.text = self.ingredients[indexPath.row]["type"] as? String
        
        return ingredientCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ingredientCollectionViewCell = ingredientsCollectionView.cellForItem(at: indexPath)! as! IngredientCollectionViewCell
        
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
                var activeIngredients: [String] = []
                
                for ingredient in self.ingredients {
                    if ingredient["selected"] as! Bool == true {
                        activeIngredients.append(ingredient["type"] as! String)
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
