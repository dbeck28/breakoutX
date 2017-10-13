//
//  GameScene.swift
//  Bamboo Breakout
/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */ 

import SpriteKit
import GameplayKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let GameMessageName = "gameMessage"
let ScoreLabelName = "scorelabel"
let LifeLabelName = "lifelabel"
let GoldName = "gold"

let BallCategory   : UInt32 = 0x1 << 0
let BottomCategory : UInt32 = 0x1 << 1
let BlockCategory  : UInt32 = 0x1 << 2
let PaddleCategory : UInt32 = 0x1 << 3
let BorderCategory : UInt32 = 0x1 << 4
let ScoreLabelCategory : UInt32 = 0x1 << 5
let LifeLabelCategory : UInt32 = 0x1 << 6
let GoldCategory : UInt32 = 0x1 << 7

class GameScene: SKScene, SKPhysicsContactDelegate {
    var isFingerOnPaddle = false
    var score = 0
    var blockcount = 0
    var life = 50 //actually 3, but a hit counts as 2 lives one on the hit, one on the rebound
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        WaitingForTap(scene: self),
        Playing(scene: self),
        GameOver(scene: self)])
    
    func generateGold() {
        
    }
    
    func breakBlock(node: SKNode) {
        let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
        particles.position = node.position
        particles.zPosition = 3
        addChild(particles)
        particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                         SKAction.removeFromParent()]))
         if score % 150 == 0 {
            let gold = SKSpriteNode(imageNamed: "gold.png")
            gold.position = node.position
            gold.physicsBody = SKPhysicsBody(rectangleOf: gold.frame.size)
            gold.physicsBody!.allowsRotation = false
            gold.physicsBody!.friction = 0.0
            gold.physicsBody!.affectedByGravity = true
            gold.physicsBody!.isDynamic = false
            gold.name = GoldName
            gold.physicsBody!.categoryBitMask = GoldCategory
            gold.zPosition = 2
            gold.physicsBody!.applyImpulse(CGVector(dx: 0, dy: -30.0))
            addChild(gold)         }
        node.removeFromParent()
    }
    
    
    func goldContact (contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        // 2
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == PaddleCategory && secondBody.categoryBitMask == GoldCategory {
            killGold(node: secondBody.node!)
        }

    }
    
    // to add to score
    func updateScore() {
        let scorelabel = childNode(withName: ScoreLabelName) as! SKLabelNode
        score += 10
        scorelabel.text = String(score)
    }
    
    
    func killGold(node: SKNode) {
        node.removeFromParent()
        score += 90
        updateScore()
    }
    
    func updateLife() {
        let lifelabel = childNode(withName: LifeLabelName) as! SKLabelNode
        life -= 5
        lifelabel.text = "Life: " + String(life)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        // 2
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        // ball to bottom
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            if life > 5 {
                updateLife()
                } else {
                let lifelabel = childNode(withName: LifeLabelName) as! SKLabelNode
                lifelabel.text = "Game Over"
                gameState.enter(GameOver.self)
                }
            }
        
        // ball to block
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
            breakBlock(node: secondBody.node!)
            blockcount += 1
            updateScore()
            if blockcount == 16 {
                buildBlocks()
                blockcount = 0
            }//TODO: check if the game has been won
        
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == GoldCategory {
            killGold(node: secondBody.node!)
        }
        
    }
    
    
    // function to build 2 rows of blocks
    func buildBlocks() {
        let numberOfBlocks = 16
        let blockWidth = SKSpriteNode(imageNamed: "block").size.width
        let totalBlocksWidth = blockWidth * CGFloat(numberOfBlocks)/2
        // 2
        let xOffset = (frame.width - totalBlocksWidth) / 2
        // 3
        var blockLine = 0
        
        for i in 0..<numberOfBlocks {
            let block = SKSpriteNode(imageNamed: "block.png")
            blockLine = blockLine + 1
            if blockLine <= 8 {
                block.position = CGPoint(x: xOffset + CGFloat(CGFloat(i) + 0.5) * blockWidth, y: frame.height * 0.7)
            } else {
                block.position = CGPoint(x: xOffset + CGFloat(CGFloat(i) - 7.5) * blockWidth, y: frame.height * 0.55)
            }
            block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
            block.physicsBody!.allowsRotation = false
            block.physicsBody!.friction = 0.0
            block.physicsBody!.affectedByGravity = false
            block.physicsBody!.isDynamic = false
            block.name = BlockCategoryName
            block.physicsBody!.categoryBitMask = BlockCategory
            block.zPosition = 2
            addChild(block)
        }
    }
    
    
    func randomFloat(from: CGFloat, to: CGFloat) -> CGFloat {
        let rand: CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return (rand) * (to - from) + from
    }
    
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    // Create edge bassed body for scene
    let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    // Set the friction to zero to avoid the ball slowing down when coming in contact with the edge
    borderBody.friction = 0
    self.physicsBody = borderBody
    physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
    physicsWorld.contactDelegate = self
    
    // for a forever bouncing ball
    let ball = childNode(withName: BallCategoryName) as! SKSpriteNode
    let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
    let bottom = SKNode()
    bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
    addChild(bottom)
    let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
   
    bottom.physicsBody!.categoryBitMask = BottomCategory
    ball.physicsBody!.categoryBitMask = BallCategory
    paddle.physicsBody!.categoryBitMask = PaddleCategory
    borderBody.categoryBitMask = BorderCategory
    ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory | GoldCategory
    paddle.physicsBody!.contactTestBitMask = GoldCategory
    bottom.physicsBody!.contactTestBitMask = GoldCategory
  
    
    buildBlocks()
    
 
    // for tap to play button
    let gameMessage = SKSpriteNode(imageNamed: "TapToPlay")
    gameMessage.name = GameMessageName
    gameMessage.position = CGPoint(x: frame.midX, y: frame.midY)
    gameMessage.zPosition = 4
    gameMessage.setScale(0.0)
    addChild(gameMessage)
    gameState.enter(WaitingForTap.self)
  }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState.currentState {
        case is WaitingForTap:
            gameState.enter(Playing.self)
            isFingerOnPaddle = true
            
        case is Playing:
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            
            if let body = physicsWorld.body(at: touchLocation) {
                if body.node!.name == PaddleCategoryName {
                    isFingerOnPaddle = true
                }
            }
            
        default:
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1
        if isFingerOnPaddle {
            // 2
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            // 3
            let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
            // 4
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            // 5
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            // 6
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPaddle = false
    }

    override func update(_ currentTime: TimeInterval) {
        gameState.update(deltaTime: currentTime)
    }

  
}




