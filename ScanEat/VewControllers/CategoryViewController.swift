//
//  CategoryViewController.swift
//  ScanEat
//
//  Created by Alain on 05/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    var titleCatgory: String = ""

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        titleLabel.text = self.titleCatgory
    }

}
