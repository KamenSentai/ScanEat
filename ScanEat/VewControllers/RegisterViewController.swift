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

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var middleArrowView: UIView!
    @IBOutlet weak var topArrowView: UIView!
    @IBOutlet weak var bottomArrowView: UIView!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextFiels: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmationLabel: UILabel!
    
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
        
        // Text fields
        lastNameTextField.delegate = self
    }
    
    @IBAction func continueAction(_ sender: Any) {
        var completed = true
        
        if lastNameTextField.text == "" {
            completed = false
            lastNameLabel.text = "Nom manquant"
        } else {
            lastNameLabel.text = ""
        }
        
        if firstNameTextField.text == "" {
            completed = false
            firstNameLabel.text = "Prénom manquant"
        } else {
            firstNameLabel.text = ""
        }
        
        if emailTextField.text == "" {
            completed = false
            emailLabel.text = "Email manquant"
        } else {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: emailTextField.text) == false {
                completed = false
                emailLabel.text = "Email invalide"
            } else {
                emailLabel.text = ""
            }
        }
        
        if passwordTextField.text == "" {
            completed = false
            passwordLabel.text = "Mot de passe manquant"
        } else {
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d\\W]{8,}$")
            if passwordTest.evaluate(with: passwordTextField.text) == false {
                completed = false
                passwordLabel.text = "Mot de passe trop faible"
            } else {
                passwordLabel.text = ""
            }
        }
        
        if passwordTextField.text != confirmationTextFiels.text {
            completed = false
            confirmationLabel.text = "Erreur"
        } else {
            confirmationLabel.text = ""
        }
        
        if completed == true {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle : nil)
            let selectionStoryboard = storyboard.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
            selectionStoryboard.data = [
                "lastname": lastNameTextField.text,
                "firstname": firstNameTextField.text,
                "email": emailTextField.text,
                "password": passwordTextField.text
                ] as! [String : String]
            navigationController?.pushViewController(selectionStoryboard, animated: true)
        }
    }
}
