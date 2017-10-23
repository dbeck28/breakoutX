//
//  RegistrationState.swift
//  Bricks
//
//  Created by Dayne Beck on 10/22/17.
//  Copyright © 2017 Dayne Beck. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit

class RegistrationState: GKState {
    unowned let scene: Registration
    
    
    init(scene: SKScene) {
        self.scene = scene as! Registration
        super.init()
    }
}
