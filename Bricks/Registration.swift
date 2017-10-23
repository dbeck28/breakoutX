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
    var signUpBtn:SKShapeNode!
    
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
        
        
        nameTextField = UITextField(frame: CGRect.init(x: 70, y: view.frame.size.height - 600 , width: view.frame.size.width/1.5, height: 30))
        customize(textField: nameTextField, placeholder: "Enter your name")
        
        view.addSubview(nameTextField)
        
        emailTextField = UITextField(frame: CGRect.init(x: 70, y: view.frame.size.height - 550, width: view.frame.size.width/1.5, height: 30))
        customize(textField: emailTextField, placeholder: "Enter your email")
        
        view.addSubview(emailTextField)
        
        usernameTextField = UITextField(frame: CGRect.init(x: 70, y: view.frame.size.height - 500, width: view.frame.size.width/1.5, height: 30))
        customize(textField: usernameTextField, placeholder: "Enter your username")
        
        view.addSubview(usernameTextField)
        
        passwordTextField = UITextField(frame: CGRect.init(x: 70, y: view.frame.size.height - 450, width: view.frame.size.width/1.5, height: 30))
        customize(textField: passwordTextField, placeholder: "Enter your password")
        
        view.addSubview(passwordTextField)
        
        passwordConfirmTextField = UITextField(frame: CGRect.init(x: 70, y: view.frame.size.height - 400, width: view.frame.size.width/1.5, height: 30))
        customize(textField: passwordConfirmTextField, placeholder: "Confirm your password")
        
        view.addSubview(passwordConfirmTextField)
        
//        let myBlue = SKColor(colorLiteralRed: 59/255, green: 89/255, blue: 153/255, alpha: 1)
//        signUpBtn = SKShapeNode(frame: CGRect.init(x: 70, y: view.frame.size.height - 400, width: view.frame.size.width/1.5, height: 30))
//        addChild(signUpBtn)
//        signUpButton.zPosition = 1
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "SubmitBtn" { //when node clicked, perform duty
                let transition = SKTransition.reveal(with: .down, duration: 1.0)
                // Add logic to convert to JSON and Post to Rails API
                nameTextField.removeFromSuperview()
                emailTextField.removeFromSuperview()
                usernameTextField.removeFromSuperview()
                passwordTextField.removeFromSuperview()
                passwordConfirmTextField.removeFromSuperview()
                
                let nextScene = MainMenuScene(fileNamed: "MainMenuScene")
                if let scene = MainMenuScene(fileNamed:"MainMenuScene") {
                    // Configure the view.
                    let skView = self.view! //as! SKView
                    skView.showsFPS = true
                    skView.showsNodeCount = true
                    
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .aspectFit
                    
                    skView.presentScene(scene)
                }
                scene?.view?.presentScene(nextScene!, transition: transition)
            }
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        //print("everytime you type something this is fired..")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}


