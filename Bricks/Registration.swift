//
//  Registration.swift
//  Bricks
//
//  Created by Dayne Beck on 10/22/17.
//  Copyright © 2017 Dayne Beck. All rights reserved.
//

import SpriteKit
import GameplayKit

class Registration: SKScene {
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        RegistrationState(scene: self)])
    
    
    var nameTextField = UITextField()
    var emailTextField = UITextField()
    var usernameTextField = UITextField()
    var passwordTextField = UITextField()
    var passwordConfirmTextField = UITextField()
    
    func customize(textField:UITextField, placeholder:String , isSecureTextEntry:Bool = false) {
        let paddingView = UIView(frame:CGRect(x:0,y: 0,width: 10,height: 30))
        textField.leftView = paddingView
        textField.keyboardType = UIKeyboardType.default
        textField.leftViewMode = UITextFieldViewMode.always
        textField.returnKeyType = UIReturnKeyType.done
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSForegroundColorAttributeName: UIColor.gray])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 4.0
        textField.textColor = .white
        textField.isSecureTextEntry = isSecureTextEntry
    }
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        gameState.enter(RegistrationState.self)
        
        
        usernameTextField = UITextField(frame: CGRect.init(x: 70, y: view.frame.size.height/4.5, width: view.frame.size.width/1.5, height: 30))
        customize(textField: usernameTextField, placeholder: "Enter your username")
        
        view.addSubview(usernameTextField)
        
        emailTextField = UITextField(frame: CGRect.init(x: 70, y: view.frame.size.height/3.7, width: view.frame.size.width/1.5, height: 30))
        customize(textField: emailTextField, placeholder: "Enter your email")
        
        view.addSubview(emailTextField)
        
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        //print("everytime you type something this is fired..")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}


