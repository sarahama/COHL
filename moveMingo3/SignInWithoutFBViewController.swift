//
//  SignUpViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 1/7/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class SignInWithoutFBViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet var bottomGuide: NSObject!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

        emailText.addTarget(self, action:#selector(self.emailTextFieldDidBeginEditing), for: UIControlEvents.editingDidBegin)
        
        passText.addTarget(self, action:#selector(self.passTextFieldDidBeginEditing), for: UIControlEvents.editingDidBegin)

    }


    func animateTextField(textField: UITextField, up: Bool, distance: Int)
    {
        let movementDistance:CGFloat = CGFloat(distance)
        let movementDuration: Double = 0.3
            
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        textField.frame = textField.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func emailTextFieldDidBeginEditing (sender: UIGestureRecognizer) {
        print("move email")
        self.animateTextField(textField: emailText, up:true, distance: -150)
    }
    
    func passTextFieldDidBeginEditing(sender: UIGestureRecognizer)
    {
        print("move password")
        self.animateTextField(textField: passText, up:true, distance: -180)
    }
        
    func textFieldDidEndEditing(textField: UITextField)
    {
        self.animateTextField(textField: textField, up:false, distance: -150)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpUser(_ sender: UIButton) {
        print("sign up")
    }
    
    
}
