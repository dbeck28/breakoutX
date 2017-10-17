//
//  MainMenu.swift
//  Bricks
//
//  Created by Dayne Beck on 10/17/17.
//  Copyright © 2017 Dayne Beck. All rights reserved.
//


import SpriteKit
import GameplayKit

class MainMenu: GKState {
    unowned let scene: GameScene //Error up blank until scene is made
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    
    override func didEnter(from previousState: GKState?) {
        let scale = SKAction.scale(to: 0.0, duration: 0.25)
        scene.childNode(withName: GameMessageName)!.run(scale)
        scene.childNode(withName: PaddleCategoryName)!.run(scale)
        scene.childNode(withName: ScoreLabelName)!.run(scale)
        scene.childNode(withName: LifeLabelName)!.run(scale)
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is Playing {
            let scale = SKAction.scale(to: 0, duration: 0.4)
            scene.childNode(withName: GameMessageName)!.run(scale)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }
    
}
