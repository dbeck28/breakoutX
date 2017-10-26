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
        customize(textField: passwordTextField, placeholder: "Enter your password", isSecureTextEntry: true)
        
        view.addSubview(passwordTextField)
        
        passwordConfirmTextField = UITextField(frame: CGRect.init(x: 70, y: view.frame.size.height - 400, width: view.frame.size.width/1.5, height: 30))
        customize(textField: passwordConfirmTextField, placeholder: "Confirm your password", isSecureTextEntry: true)
        
        view.addSubview(passwordConfirmTextField)
        
//        let myBlue = SKColor(colorLiteralRed: 59/255, green: 89/255, blue: 153/255, alpha: 1)
//        signUpBtn = SKShapeNode(frame: CGRect.init(x: 70, y: view.frame.size.height - 400, width: view.frame.size.width/1.5, height: 30))
//        addChild(signUpBtn)
//        signUpButton.zPosition = 1
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view?.endEditing(true) //to make that keyboard disappear when u tap outside of textfield
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "SubmitBtn" {
                //when node clicked, perform duty
                
//                var name = nameTextField.text
//                let username = usernameTextField.text
//                let email = emailTextField.text
//                let password = passwordTextField.text
                // let passwordConfirmText = passwordConfirmTextField.text
                // save user data in four parts to be sent to api
                
                let headers = [
                    "Authorization":"Token token=629fc8b7dfcf38cb7c1348cf8159e406",
                    ]
                
                let user_params: [String : AnyObject] = [
                    "name" : nameTextField.text as AnyObject,
                    "username" : usernameTextField.text as AnyObject,
                    "email" : emailTextField.text as AnyObject,
                    "password_digest" : passwordTextField.text as AnyObject,
                    "password_confirmation" : passwordConfirmTextField.text as AnyObject
                ]
                
                Alamofire.request("http://localhost:3000/users", method: .post, parameters: user_params, encoding: JSONEncoding.default, headers: headers)
                    .validate(statusCode: 200..<600)
                    .responseJSON() { response in
                        if (response.result.error == nil) {
                            debugPrint(user_params)
                            debugPrint("HTTP Response Body: \(response.data)")
                            if let values = response.result.value {
                                // Use values to initialize DogPark instances
                            }
                        }
                        else {
                            debugPrint("HTTP Request failed: \(response.result.error)")
                        }
                        // *** End of If-Else statement *** 
                }
                
                let transition = SKTransition.reveal(with: .down, duration: 1.0)
                // Add logic to convert to JSON and Post to Rails API
                nameTextField.removeFromSuperview()
                emailTextField.removeFromSuperview()
                usernameTextField.removeFromSuperview()
                passwordTextField.removeFromSuperview()
                passwordConfirmTextField.removeFromSuperview()
                
// to test text capture
//                let TestLabelName = "testlabel"
//                let TestLabelCategory : UInt32 = 0x1 << 5
//                let testlabel = childNode(withName: TestLabelName) as! SKLabelNode
//                testlabel.text = xtext
                
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


