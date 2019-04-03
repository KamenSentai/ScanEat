//
//  RegisterViewController.swift
//  ScanEat
//
//  Created by Alain on 02/04/2019.
//  Copyright © 2019 iOSHetic. All rights reserved.
//

import UIKit

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}

class RegisterViewController: UIViewController {

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var middleArrowView: UIView!
    @IBOutlet weak var topArrowView: UIView!
    @IBOutlet weak var bottomArrowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation
        let backButton = UIBarButtonItem()
        backButton.title = "Retour"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        // UI
        logoView.layer.cornerRadius = 35
        arrowView.layer.cornerRadius = 25
        arrowView.layer.shadowColor = UIColor.black.cgColor
        arrowView.layer.shadowOffset = CGSize(width: 0, height: 5)
        arrowView.layer.shadowRadius = 10
        arrowView.layer.shadowOpacity = 0.25
        middleArrowView.layer.cornerRadius = 1
        topArrowView.layer.cornerRadius = 1
        topArrowView.layer.anchorPoint = CGPoint(x: 1, y: 0)
        topArrowView.transform = CGAffineTransform(rotationAngle: 2 * .pi / 3)
        bottomArrowView.layer.cornerRadius = 1
        bottomArrowView.layer.anchorPoint = CGPoint(x: 1, y: 0)
        bottomArrowView.transform = CGAffineTransform(rotationAngle: .pi / 3)
    }

    @IBAction func continueAction(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle : nil)
        let selectionStoryboard = storyboard.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
        navigationController?.pushViewController(selectionStoryboard, animated: true)
    }
}
