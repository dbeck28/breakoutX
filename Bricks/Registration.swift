//
//  Registration.swift
//  Bricks
//
//  Created by Dayne Beck on 10/22/17.
//  Copyright © 2017 Dayne Beck. All rights reserved.
//

import SpriteKit
import GameplayKit
import Alamofire
import SwiftyJSON

let LoginPageBtnName = "LoginPageBtn"
let SubmitBtnName = "SubmitBtn"
let SkipRegistrationBtnName = "SkipRegistrationBtn"
let LoginSubmitBtnName = "LoginSubmitBtn"

let LoginPageBtnCategory   : UInt32 = 0x1 << 0
let SubmitBtnCategory : UInt32 = 0x1 << 1
let SkipRegistrationBtnCategory  : UInt32 = 0x1 << 2
let LoginSubmitBtnCategory : UInt32 = 0x1 << 3



class Registration: SKScene {
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        RegistrationState(scene: self)])
    
    
    var nameTextField = UITextField()
    var emailTextField = UITextField()
    var usernameTextField = UITextField()
    var passwordTextField = UITextField()
    var passwordConfirmTextField = UITextField()
    
    
    func go_to_main_menu() {
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
        let LoginSubmitBtn = childNode(withName: LoginSubmitBtnName) as! SKSpriteNode
        LoginSubmitBtn.isHidden = true
        
        
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
        customize(textField: passwordTextField, placeholder: "Enter your password", isSecureTextEntry: true)
        
        view.addSubview(passwordTextField)
        
        passwordConfirmTextField = UITextField(frame: CGRect.init(x: 70, y: view.frame.size.height - 400, width: view.frame.size.width/1.5, height: 30))
        customize(textField: passwordConfirmTextField, placeholder: "Confirm your password", isSecureTextEntry: true)
        
        view.addSubview(passwordConfirmTextField)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view?.endEditing(true) //to make that keyboard disappear when u tap outside of textfield
        super.touchesBegan(touches, with: event)
        var password_confirmed = true
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "SubmitBtn" {
                
                
                if passwordTextField.text != passwordConfirmTextField.text {
                    password_confirmed = false
                } else {
                let headers = [
                    "Authorization":"Token token=4212c4baf755266c1657743cecd71eed",
                    ]
                let user_params: [String : AnyObject] = [
                    "name" : nameTextField.text as AnyObject,
                    "username" : usernameTextField.text as AnyObject,
                    "email" : emailTextField.text as AnyObject,
                    "password_digest" : passwordTextField.text as AnyObject,
                    "password_confirmation" : passwordConfirmTextField.text as AnyObject
                ]
                
                // The request to post a new member to the database
                Alamofire.request("http://localhost:3000/users/", method: .post, parameters: user_params, encoding: JSONEncoding.default, headers: headers)
                    .validate(statusCode: 200..<600) // checks to see if it's valid JSON
                    .responseJSON() { response in
                        if (response.result.error == nil) {
                            debugPrint(response)
                            let current_user = JSON(response)
                            print(current_user)
                            debugPrint("HTTP Response Body: \(response.data)")
                        } else {
                            debugPrint("HTTP Request failed: \(response.result.error)")
                        }
                    }
                }
                if (password_confirmed == true) && (passwordTextField.text != "") {
                    go_to_main_menu() //Add error message
                }
            }
            
            if touchedNode.name == "SkipRegistrationBtn" {
                go_to_main_menu()
            }
            
            if touchedNode.name == "LoginPageBtn" {
                let LoginSubmitBtn = childNode(withName: LoginSubmitBtnName) as! SKSpriteNode
                let SubmitBtn = childNode(withName: SubmitBtnName) as! SKSpriteNode
                let LoginPageBtn = childNode(withName: LoginPageBtnName) as! SKSpriteNode
                nameTextField.removeFromSuperview()
                passwordConfirmTextField.removeFromSuperview()
                usernameTextField.removeFromSuperview()
                SubmitBtn.removeFromParent()
                LoginPageBtn.removeFromParent()
                LoginSubmitBtn.isHidden = false
            }
            
            if touchedNode.name == "LoginSubmitBtn" {
                let headers = [
                    "Authorization":"Token token=4212c4baf755266c1657743cecd71eed",
                    ]
                
                let user_params: [String : AnyObject] = [
                    "email" : emailTextField.text as AnyObject,
                    "password_digest" : passwordTextField.text as AnyObject,
                ]
                
                let id = "1"
                
                Alamofire.request("http://localhost:3000/users/\(id))", parameters: user_params, headers: headers)
                    .validate(statusCode: 200..<600) // checks to see if it's valid JSON
                    .responseJSON() { response in
                        if (response.result.error == nil) {
                            debugPrint(response)
//                            let userData = JSON(data: response.data!)
//                            let username = userData["username"].string
//                            debugPrint(userData)
                            debugPrint("HTTP Response Body: \(response.data)")
                        } else {
                            debugPrint("HTTP Request failed: \(response.result.error)")
                        }
                    }
                
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


