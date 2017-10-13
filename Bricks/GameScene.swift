
import SpriteKit
import GameplayKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let GameMessageName = "gameMessage"
let ScoreLabelName = "scorelabel"
let LifeLabelName = "lifelabel"
let GoldName = "gold"
let HeartName = "heart"

let BallCategory   : UInt32 = 0x1 << 0
let BottomCategory : UInt32 = 0x1 << 1
let BlockCategory  : UInt32 = 0x1 << 2
let PaddleCategory : UInt32 = 0x1 << 3
let BorderCategory : UInt32 = 0x1 << 4
let ScoreLabelCategory : UInt32 = 0x1 << 5
let LifeLabelCategory : UInt32 = 0x1 << 6
let GoldCategory : UInt32 = 0x1 << 7
let HeartCategory : UInt32 = 0x1 << 8

class GameScene: SKScene, SKPhysicsContactDelegate {
    var isFingerOnPaddle = false
    var score = 0
    var totalScore = 0.0
    var blockcount = 0
    var life = 100 //actually 3, but a hit counts as 2 lives one on the hit, one on the rebound
    var totalBlocksBroken = 0.0
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        WaitingForTap(scene: self),
        Playing(scene: self),
        GameOver(scene: self)])
    
    let blipSound = SKAction.playSoundFileNamed("pongblip", waitForCompletion: false)
    let blipPaddleSound = SKAction.playSoundFileNamed("paddleBlip", waitForCompletion: false)
    let bambooBreakSound = SKAction.playSoundFileNamed("BambooBreak", waitForCompletion: false)
    let gameWonSound = SKAction.playSoundFileNamed("game-won", waitForCompletion: false)
    let coinSound = SKAction.playSoundFileNamed("coins", waitForCompletion: false)
    let burpSound = SKAction.playSoundFileNamed("burp", waitForCompletion: false)
    
    func breakBlock(node: SKNode) {
        run(bambooBreakSound)
        let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
        particles.position = node.position
        particles.zPosition = 3
        addChild(particles)
        particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                         SKAction.removeFromParent()]))
        node.removeFromParent()
        // Gold Bonus on block break
         if (score > 10) && (score % 150 == 0) {
            let gold = SKSpriteNode(imageNamed: "gold.png")
            gold.position = node.position
            gold.physicsBody = SKPhysicsBody(rectangleOf: gold.frame.size)
            gold.physicsBody!.density = 1000
            gold.physicsBody!.isDynamic = true
            gold.name = GoldName
            gold.physicsBody!.categoryBitMask = GoldCategory
            gold.zPosition = 2
            // make gold move
            let actionMove = SKAction.move(to: CGPoint(x: node.position.x, y: -50.0), duration: TimeInterval(5))
            let killGold = SKAction.removeFromParent()
                gold.run(SKAction.sequence([actionMove, killGold]))
            addChild(gold)
        }
        
        if (score > 10) && (score % 250 == 0) {
            let heart = SKSpriteNode(imageNamed: "heart.png")
            heart.position = node.position
            heart.physicsBody = SKPhysicsBody(rectangleOf: heart.frame.size)
            heart.physicsBody!.density = 1000
            heart.physicsBody!.isDynamic = true
            heart.name = HeartName
            heart.physicsBody!.categoryBitMask = HeartCategory
            heart.zPosition = 2
            // Make Heart Move
            let actionMove = SKAction.move(to: CGPoint(x: node.position.x, y: -50.0), duration: TimeInterval(5))
            let killHeart = SKAction.removeFromParent()
            heart.run(SKAction.sequence([actionMove, killHeart]))
            addChild(heart)
        }
    }
    
    
    // to add to score
    func updateScore() {
        let scorelabel = childNode(withName: ScoreLabelName) as! SKLabelNode
        score += 10
        totalBlocksBroken += 1.0
        scorelabel.text = String(score) + " " + "Bonus: " + String(totalBlocksBroken * 0.1)
    }
    
    // to updateLife as the ball slowly dies
    func updateLife() {
        let lifelabel = childNode(withName: LifeLabelName) as! SKLabelNode
        life -= 5
        lifelabel.text = "Life: " + String(life)
    }
    
    // to update score as you catch gold
    func catchGold(node: SKNode) {
        run(coinSound)
        node.removeFromParent()
        score += 90
        updateScore()
    }
    
    func catchHeart(node: SKNode) {
        let lifelabel = childNode(withName: LifeLabelName) as! SKLabelNode
        run(burpSound)
        node.removeFromParent()
        life += 25
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
                totalScore += totalScore * (totalBlocksBroken * 0.1)
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
            }
        
        }
        // Paddle to Gold
        if firstBody.categoryBitMask == PaddleCategory && secondBody.categoryBitMask == GoldCategory {
            catchGold(node: secondBody.node!)
        }
        // Paddle to Heart
        if firstBody.categoryBitMask == PaddleCategory && secondBody.categoryBitMask == HeartCategory {
            catchHeart(node: secondBody.node!)
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BorderCategory {
            run(blipSound)
        }
        // 2
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == PaddleCategory {
            run(blipPaddleSound)
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
            let block = SKSpriteNode(imageNamed: "block-1.png")
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
    ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory | GoldCategory | BorderCategory
    paddle.physicsBody!.contactTestBitMask = GoldCategory | HeartCategory
    bottom.physicsBody!.contactTestBitMask = BallCategory
  
    
    buildBlocks()
    
    // ball sparks
    let trailNode = SKNode()
    trailNode.zPosition = 1
    addChild(trailNode)
    // 2
    let trail = SKEmitterNode(fileNamed: "BallTrail")!
    // 3
    trail.targetNode = trailNode
    // 4
    ball.addChild(trail)
    
 
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




