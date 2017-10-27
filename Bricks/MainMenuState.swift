//
//  MainMenuState.swift
//  Bricks
//
//  Created by Dayne Beck on 10/18/17.
//  Copyright © 2017 Dayne Beck. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuState: GKState {
    unowned let scene: MainMenuScene
    
    
    init(scene: SKScene) {
        self.scene = scene as! MainMenuScene
        super.init()
    }
}
