//
//  MainMenu.swift
//  Bricks
//
//  Created by Dayne Beck on 10/17/17.
//  Copyright © 2017 Dayne Beck. All rights reserved.
//


import SpriteKit
import GameplayKit


class MainMenuScene: SKScene {
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        MainMenuState(scene: self)])
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        gameState.enter(MainMenuState.self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "FreePlayBtn" { //when node clicked, perform duty
                let transition = SKTransition.reveal(with: .down, duration: 1.0)
                
                let nextScene = GameScene(fileNamed: "GameScene")
                if let scene = GameScene(fileNamed:"GameScene") {
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
    
//    override func didEnter(from previousState: GKState?) {
//        let scale = SKAction.scale(to: 0.0, duration: 0.25)
//        scene.childNode(withName: GameMessageName)!.run(scale)
//        scene.childNode(withName: PaddleCategoryName)!.run(scale)
//        scene.childNode(withName: ScoreLabelName)!.run(scale)
//        scene.childNode(withName: LifeLabelName)!.run(scale)
//    }
//    
//    override func willExit(to nextState: GKState) {
//        if nextState is Playing {
//            let scale = SKAction.scale(to: 0, duration: 0.4)
//            scene.childNode(withName: GameMessageName)!.run(scale)
//        }
//    }
//    
//    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
//        return stateClass is Playing.Type
//    }
    override func update(_ currentTime: TimeInterval) {
        gameState.update(deltaTime: currentTime)
    }

    
}
