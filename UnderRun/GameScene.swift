//
//  GameScene.swift
//  SemesterTwoFinalApp
//
//  Created by The Real Kaiser on 4/19/18.
//  Copyright © 2018 William Donnelly. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategories{
        static let None : UInt32 = 0
        static let Heart : UInt32 = 0x1  //1
        static let Damage : UInt32 = 0x10 //2
    }
    
    enum gameState{
        case preGame
        case midGame
        case endGame
    }
    
    static var startTime: Double?
    static var endTime: Double?

    let leftBlastStarted = SKSpriteNode(imageNamed: "Gaster Blaster Head")
    let midBlastStarted = SKSpriteNode(imageNamed: "Gaster Blaster Head")
    let rightBlastStarted = SKSpriteNode(imageNamed: "Gaster Blaster Head")
    let leftBlastFinished = SKSpriteNode(imageNamed: "Gaster Blaster Firing")
    let midBlastFinished = SKSpriteNode(imageNamed: "Gaster Blaster Firing")
    let rightBlastFinished = SKSpriteNode(imageNamed: "Gaster Blaster Firing")
    var leftLaser: SKShapeNode?
    var midLaser: SKShapeNode?
    var rightLaser: SKShapeNode?
    
    var leftTrackLarge: Bool?
    var midTrackLarge: Bool?
    var rightTrackLarge: Bool?
    
    var gameAudioPlayer: AVAudioPlayer!
    
    var currentState = gameState.preGame
    
    var timer: Timer?
    
    let tapToStartLabel = SKLabelNode(fontNamed: "Papyrus")
    
    var chosenBoss = ChoiceScene.boss
    
    var leftTrack = SKShapeNode()
    var midTrack = SKShapeNode()
    var rightTrack = SKShapeNode()
    
    var background = SKSpriteNode.init()
    var heart = SKSpriteNode()
    
    let leftWarn = SKSpriteNode(imageNamed: "warning-icon")
    let midWarn = SKSpriteNode(imageNamed: "warning-icon")
    let rightWarn = SKSpriteNode(imageNamed: "warning-icon")

    var hPos = "Middle"
    
    var swipeRightRec = UISwipeGestureRecognizer()
    var swipeLeftRec = UISwipeGestureRecognizer()
    
    let despawn = SKAction.removeFromParent()
    
    var count = 0
    
    override func didMove(to view: SKView) {
        //scaleMode = SKSceneScaleMode.aspectFit
        //print(frame.size.height)
        //print(frame.maxY)
        //print(frame.minY)
        self.physicsWorld.contactDelegate = self
        
        leftTrackLarge = false
        midTrackLarge = false
        rightTrackLarge = false
        
        swipeRightRec.addTarget(self, action: #selector(GameScene.swipedRight))
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
        

        swipeLeftRec.addTarget(self, action: #selector(GameScene.swipedLeft))
        swipeLeftRec.direction = .left
        self.view!.addGestureRecognizer(swipeLeftRec)
        
        //print(frame.size)
        
        createBackground()
        makeTracks()
        placeHeart()
        startSequence()
        makeLargeObstacles()
        makeWarnings()
    }
    
    func startMusic(){
        do{
            if(chosenBoss == "toriel"){
                try gameAudioPlayer = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Heartache", ofType: "mp3")!))
            }
            else if(chosenBoss == "papyrus"){
                try gameAudioPlayer = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Bonetrousle", ofType: "mp3")!))
            }
            else if(chosenBoss == "undyne"){
                try gameAudioPlayer = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Undyne", ofType: "mp3")!))
            }
            else if(chosenBoss == "muffet"){
                try gameAudioPlayer = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Spider", ofType: "mp3")!))
            }
            else if(chosenBoss == "asgore"){
                try gameAudioPlayer = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Asgore", ofType: "mp3")!))
            }
            else if(chosenBoss == "sans"){
                try gameAudioPlayer = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Megalovania", ofType: "mp3")!))
            }
            gameAudioPlayer.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
            
            /*do{
                try audioSession.setCategory(convertFromAVAudioSessionCategory(AVAudioSession.Category.playback))
            }
            catch{
                
            }*/
        }
        catch{
            print(error)
        }
        gameAudioPlayer.volume = 1.0
        gameAudioPlayer.numberOfLoops = 10000
        gameAudioPlayer.play()
    }    
    func createBackground(){
        if(chosenBoss == "toriel"){
            background = SKSpriteNode.init(imageNamed: "TorielBackground")
        }
        else if(chosenBoss == "papyrus"){
            background = SKSpriteNode.init(imageNamed: "PapyrusBackground")
        }
        else if(chosenBoss == "undyne"){
            background = SKSpriteNode.init(imageNamed: "UndyneBackground")
        }
        else if(chosenBoss == "muffet"){
            background = SKSpriteNode.init(imageNamed: "MuffetBackground")
        }
        else if(chosenBoss == "asgore"){
            background = SKSpriteNode.init(imageNamed: "AsgoreBackground")
        }
        else if(chosenBoss == "sans"){
            background = SKSpriteNode.init(imageNamed: "SansBackground")
        }
        background.size = frame.size
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        addChild(background)
    }
    
    func makeTracks(){
        //print(frame.maxX/3)
        leftTrack = SKShapeNode(rectOf: CGSize(width: 69, height: frame.size.height*2))
        midTrack = SKShapeNode(rectOf: CGSize(width: 69, height: frame.size.height*2))
        rightTrack = SKShapeNode(rectOf: CGSize(width: 69, height: frame.size.height*2))

        leftTrack.position = CGPoint(x: frame.midX - 192, y: frame.midY)
        leftTrack.strokeColor = UIColor.blue
        leftTrack.zPosition = 1
        
        midTrack.position = CGPoint(x: frame.midX, y: frame.midY)
        midTrack.strokeColor = UIColor.blue
        midTrack.zPosition = 1
        
        rightTrack.position = CGPoint(x: frame.midX + 192, y: frame.midY)
        rightTrack.strokeColor = UIColor.blue
        rightTrack.zPosition = 1
        
        addChild(leftTrack)
        addChild(midTrack)
        addChild(rightTrack)
        
    }
    
    func placeHeart(){
        if(chosenBoss == "toriel"){
            heart = SKSpriteNode.init(imageNamed: "Red Heart")
        }
        else if(chosenBoss == "papyrus"){
            heart = SKSpriteNode.init(imageNamed: "Light Blue Heart")
        }
        else if(chosenBoss == "undyne"){
            heart = SKSpriteNode.init(imageNamed: "Green Heart")
        }
        else if(chosenBoss == "muffet"){
            heart = SKSpriteNode.init(imageNamed: "Purple Heart")
        }
        else if(chosenBoss == "asgore"){
            heart = SKSpriteNode.init(imageNamed: "Orange Heart")
        }
        else if(chosenBoss == "sans"){
            heart = SKSpriteNode.init(imageNamed: "Blue Heart")
        }
        
        heart.position = CGPoint(x: frame.midX, y: frame.minY - 100)
        heart.zPosition = 2
        heart.physicsBody = SKPhysicsBody.init(rectangleOf: heart.size)
        heart.physicsBody?.affectedByGravity = false
        heart.physicsBody?.categoryBitMask = PhysicsCategories.Heart
        heart.physicsBody?.collisionBitMask = PhysicsCategories.None
        heart.physicsBody?.contactTestBitMask = PhysicsCategories.Damage
        
        addChild(heart)
    }
    
    func makeLargeObstacles(){
        leftLaser = SKShapeNode(rectOf: CGSize(width: 69, height: (frame.size.height)))
        leftBlastStarted.zPosition = 5
        leftBlastFinished.zPosition = 5
        leftLaser!.zPosition = 4
        leftLaser!.fillColor = UIColor.white
        leftLaser!.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 69, height: frame.size.height))
        leftLaser!.physicsBody?.affectedByGravity = false
        leftLaser!.physicsBody?.categoryBitMask = PhysicsCategories.Damage
        leftLaser!.physicsBody?.collisionBitMask = PhysicsCategories.None
        leftLaser!.physicsBody?.contactTestBitMask = PhysicsCategories.Heart
        
        leftBlastStarted.position = CGPoint(x: frame.midX - 192, y: (frame.size.height) + 100)
        leftBlastFinished.position = CGPoint(x: frame.midX - 192, y: (frame.size.height) + 100)
        leftLaser!.position = CGPoint(x: frame.midX - 192, y: frame.maxY*2)
        addChild(leftBlastStarted)
        addChild(leftBlastFinished)
        addChild(leftLaser!)
        
        midLaser = SKShapeNode(rectOf: CGSize(width: 69, height: frame.size.height))
        midBlastStarted.zPosition = 5
        midBlastFinished.zPosition = 5
        midLaser!.zPosition = 4
        midLaser!.fillColor = UIColor.white
        midLaser!.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 69, height: frame.size.height))
        midLaser!.physicsBody?.affectedByGravity = false
        midLaser!.physicsBody?.categoryBitMask = PhysicsCategories.Damage
        midLaser!.physicsBody?.collisionBitMask = PhysicsCategories.None
        midLaser!.physicsBody?.contactTestBitMask = PhysicsCategories.Heart
        
        midBlastStarted.position = CGPoint(x: frame.midX, y: (frame.size.height) + 100)
        midBlastFinished.position = CGPoint(x: frame.midX, y: (frame.size.height) + 100)
        print(frame.maxY*2)
        midLaser!.position = CGPoint(x: frame.midX, y: frame.maxY*2)
        addChild(midBlastStarted)
        addChild(midBlastFinished)
        addChild(midLaser!)
        
        rightLaser = SKShapeNode(rectOf: CGSize(width: 69, height: frame.size.height))
        rightBlastStarted.zPosition = 5
        rightBlastFinished.zPosition = 5
        rightLaser!.zPosition = 4
        rightLaser!.fillColor = UIColor.white
        rightLaser!.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 69, height: frame.size.height))
        rightLaser!.physicsBody?.affectedByGravity = false
        rightLaser!.physicsBody?.categoryBitMask = PhysicsCategories.Damage
        rightLaser!.physicsBody?.collisionBitMask = PhysicsCategories.None
        rightLaser!.physicsBody?.contactTestBitMask = PhysicsCategories.Heart
        
        rightBlastStarted.position = CGPoint(x: frame.midX + 192, y: (frame.size.height) + 100)
        rightBlastFinished.position = CGPoint(x: frame.midX + 192, y: (frame.size.height) + 100)
        rightLaser!.position = CGPoint(x: frame.midX + 192, y: frame.maxY*2)
        addChild(rightBlastStarted)
        addChild(rightBlastFinished)
        addChild(rightLaser!)
    }
    
    func makeWarnings(){
        leftWarn.alpha = 0
        leftWarn.zPosition = 3
        leftWarn.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(leftWarn)
        
        midWarn.alpha = 0
        midWarn.zPosition = 3
        midWarn.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(midWarn)
        
        rightWarn.alpha = 0
        rightWarn.zPosition = 3
        rightWarn.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(rightWarn)
    }
    
    @objc func swipedRight(){
        if(hPos != "Right"){
            if(hPos == "Left"){
                let moveToMid = SKAction.moveTo(x: frame.midX, duration: 0.2)
                heart.run(moveToMid)
                hPos = "Middle"
            }
            else if(hPos == "Middle"){
                let moveToRight = SKAction.moveTo(x: frame.midX + 192, duration: 0.2)
                heart.run(moveToRight)
                hPos = "Right"
            }
        }
    }
    
    @objc func swipedLeft(){
        if(hPos != "Left"){
            if(hPos == "Middle"){
                let moveToLeft = SKAction.moveTo(x: frame.midX-192, duration: 0.2)
                heart.run(moveToLeft)
                hPos = "Left"
            }
            else if(hPos == "Right"){
                let moveToMid = SKAction.moveTo(x: frame.midX, duration: 0.2)
                heart.run(moveToMid)
                hPos = "Middle"
            }
        }
    }
    
    func startSequence(){
        tapToStartLabel.text = "Tap to Begin"
        tapToStartLabel.fontSize = 50
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = 3
        tapToStartLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
    }
    
    func beginGame(){
        currentState = gameState.midGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveHeartAction = SKAction.moveTo(y: frame.minY + 100, duration: 0.6)
        heart.run(moveHeartAction)
        GameScene.startTime = CACurrentMediaTime()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(currentState == gameState.preGame){
            if(StartScene.musicEnabled == true){
                startMusic()
            }
            beginGame()
            currentState = gameState.midGame
            timer = Timer.scheduledTimer(timeInterval: StartScene.interval!, target: self, selector: #selector(GameScene.createObstacles), userInfo: nil, repeats: true)
        }
    }
    
    func smallObstacle(track: String){
        /*if(chosenBoss == "toriel"){
            
        }
        else if(chosenBoss == "papyrus"){
            
        }
        else if(chosenBoss == "undyne"){
            
        }
        else if(chosenBoss == "muffet"){
            
        }
        else if(chosenBoss == "asgore"){
            
        }
        else if(chosenBoss == "sans"){
 */
            let moveDown = SKAction.moveTo(y: -(frame.size.height/2) - 91, duration: 2)
            let deleteBone = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveDown, deleteBone])
            let rotate = SKAction.rotate(byAngle: 6.28, duration: 0.5)
            let rotateConstantly = SKAction.repeatForever(rotate)
        
            if(track == "Left"){
                let leftBone = SKSpriteNode(imageNamed: "Bone")
                leftBone.zPosition = 5
                leftBone.position = CGPoint(x: frame.midX - 192, y: (frame.size.height) + leftBone.size.height)
                leftBone.physicsBody = SKPhysicsBody(rectangleOf: leftBone.size)
                leftBone.physicsBody?.affectedByGravity = false
                leftBone.physicsBody?.categoryBitMask = PhysicsCategories.Damage
                leftBone.physicsBody?.collisionBitMask = PhysicsCategories.None
                leftBone.physicsBody?.contactTestBitMask = PhysicsCategories.Heart
                addChild(leftBone)
                
                leftBone.run(rotateConstantly)
                leftBone.run(sequence)
            }
            if(track == "Middle"){
                let midBone = SKSpriteNode(imageNamed: "Bone")
                midBone.zPosition = 5
                midBone.position = CGPoint(x: frame.midX, y: (frame.size.height) + midBone.size.height)
                midBone.physicsBody = SKPhysicsBody(rectangleOf: midBone.size)
                midBone.physicsBody?.affectedByGravity = false
                midBone.physicsBody?.categoryBitMask = PhysicsCategories.Damage
                midBone.physicsBody?.collisionBitMask = PhysicsCategories.None
                midBone.physicsBody?.contactTestBitMask = PhysicsCategories.Heart
                addChild(midBone)
                
                midBone.run(rotateConstantly)
                midBone.run(sequence)
            }
            if(track == "Right"){
                let rightBone = SKSpriteNode(imageNamed: "Bone")
                rightBone.zPosition = 5
                rightBone.position = CGPoint(x: frame.midX + 192, y: (frame.size.height) + rightBone.size.height)
                rightBone.physicsBody = SKPhysicsBody(rectangleOf: rightBone.size)
                rightBone.physicsBody?.affectedByGravity = false
                rightBone.physicsBody?.categoryBitMask = PhysicsCategories.Damage
                rightBone.physicsBody?.collisionBitMask = PhysicsCategories.None
                rightBone.physicsBody?.contactTestBitMask = PhysicsCategories.Heart
                addChild(rightBone)
                
                rightBone.run(rotateConstantly)
                rightBone.run(sequence)
            }
        //}
    }
    
    func largeObstacle(track: String){
        /*if(chosenBoss == "toriel"){
            
        }
        else if(chosenBoss == "papyrus"){
            
        }
        else if(chosenBoss == "undyne"){
            
        }
        else if(chosenBoss == "muffet"){
            
        }
        else if(chosenBoss == "asgore"){
            
        }
        else if(chosenBoss == "sans"){
 */
            
        let moveGasterToScreen = SKAction.moveTo(y: frame.maxY - 30, duration: 0.0)
        
        let blockAction = SKAction.run({() -> Void in self.timer = Timer.scheduledTimer(withTimeInterval: StartScene.interval!, repeats: false, block: ({_ in self.removeLargeObstacles(track: track)}))})

        let shootAction = SKAction.run({() -> Void in self.timer = Timer.scheduledTimer(withTimeInterval: StartScene.interval!*2, repeats: false, block: ({_ in self.removeLargeEndObstacles(track: track)}))})
        
        let sequence = SKAction.sequence([blockAction, shootAction])
            
        if(track == "Left"){
            leftTrackLarge = true
            createWarning(track: "Left")
            leftBlastStarted.run(moveGasterToScreen)
            self.run(sequence)
        }
        if(track == "Middle"){
            midTrackLarge = true
            createWarning(track: "Middle")
            midBlastStarted.run(moveGasterToScreen)
            self.run(sequence)
        }
        if(track == "Right"){
            rightTrackLarge = true
            createWarning(track: "Right")
            rightBlastStarted.run(moveGasterToScreen)
            self.run(sequence)
        }
    }
    
    @objc func removeLargeObstacles(track: String){
        let returnGasterHead = SKAction.moveTo(y: frame.maxY + 100, duration: 0.0)
        let fireGaster = SKAction.moveTo(y: frame.maxY - 30, duration: 0.0)
        
        var intervalCheck = 1.0
        if(StartScene.interval == 0.5){
            intervalCheck = 0.5
        }
        print(-frame.size.height)
        let fireLaser = SKAction.moveTo(y: -frame.size.height, duration: intervalCheck)
        if(track == "Left"){
            //print("FIRING LEFT laser and gaster")
            leftBlastStarted.run(returnGasterHead)
            leftBlastFinished.run(fireGaster)
            leftLaser!.run(fireLaser)
        }
        if(track == "Middle"){
            //print("FIRING MIDDLE laser and gaster")
            midBlastStarted.run(returnGasterHead)
            midBlastFinished.run(fireGaster)
            midLaser!.run(fireLaser)
        }
        if(track == "Right"){
            //print("FIRING RIGHT laser and gaster")
            rightBlastStarted.run(returnGasterHead)
            rightBlastFinished.run(fireGaster)
            rightLaser!.run(fireLaser)
        }
    }
    
    @objc func removeLargeEndObstacles(track: String){
        let returnGasterBlaster = SKAction.moveTo(y: frame.maxY + 100, duration: 0.0)
        let returnLaser = SKAction.moveTo(y: frame.maxY*2, duration: 0.0)
        
        if(track == "Left"){
            //print("REMOVING LEFT laser and gaster")
            leftBlastFinished.run(returnGasterBlaster)
            leftLaser!.run(returnLaser)
            leftTrackLarge = false
        }
        if(track == "Middle"){
            //print("REMOVING MIDDLE laser and gaster")
            midBlastFinished.run(returnGasterBlaster)
            midLaser!.run(returnLaser)
            midTrackLarge = false
        }
        if(track == "Right"){
            //print("REMOVING RIGHT laser and gaster")
            rightBlastFinished.run(returnGasterBlaster)
            rightLaser!.run(returnLaser)
            rightTrackLarge = false
        }
    }
    
    @objc func createObstacles(){
        //var currentLaserTrack = 0
        var invalidNumber:UInt32 = 0
        
        if(currentState == gameState.midGame){
            var tracksToAttack = arc4random_uniform(10) + 1
            if(tracksToAttack == 1 || tracksToAttack == 5 || tracksToAttack == 10){
                tracksToAttack = 1
                //print("Attacking 1 track")
            }
            else{
                tracksToAttack = 2
                //print("Attacking 2 tracks")
            }
            while(tracksToAttack > 0){
                let smallOrLarge = arc4random_uniform(15) + 1
                //print("Rolled 1-15 and got \(smallOrLarge)")
                if(smallOrLarge == 5 || smallOrLarge == 7){
                    var largeAttackTrack = arc4random_uniform(3) + 1
                    
                    if(largeAttackTrack == invalidNumber){
                        let midOrSide = arc4random_uniform(2) + 1
                        if(midOrSide == 1){
                            if(largeAttackTrack == 1){
                                largeAttackTrack = 3
                            }
                            else if(largeAttackTrack == 3){
                                largeAttackTrack = 1
                            }
                            else{
                                largeAttackTrack = 3
                            }
                        }
                        else{
                            if(largeAttackTrack == 1){
                                largeAttackTrack = 2
                            }
                            else if(largeAttackTrack == 3){
                                largeAttackTrack = 2
                            }
                            else{
                                largeAttackTrack = 1
                            }
                        }
                    }
                    
                    if(largeAttackTrack == 1){
                        largeObstacle(track: "Left")
                    }
                    else if(largeAttackTrack == 2){
                        largeObstacle(track: "Middle")
                    }
                    else{
                        largeObstacle(track: "Right")
                    }
                    invalidNumber = largeAttackTrack
                }
                else{
                    var smallAttackTrack = arc4random_uniform(3) + 1
                    
                    if(smallAttackTrack == invalidNumber){
                        let midOrSide = arc4random_uniform(2) + 1
                        if(midOrSide == 1){
                            if(smallAttackTrack == 1){
                                smallAttackTrack = 3
                            }
                            else if(smallAttackTrack == 3){
                                smallAttackTrack = 1
                            }
                            else{
                                smallAttackTrack = 3
                            }
                        }
                        else{
                            if(smallAttackTrack == 1){
                                smallAttackTrack = 2
                            }
                            else if(smallAttackTrack == 3){
                                smallAttackTrack = 2
                            }
                            else{
                                smallAttackTrack = 1
                            }
                        }
                    }
                    if(smallAttackTrack == 1){
                        smallObstacle(track: "Left")
                    }
                    else if(smallAttackTrack == 2){
                        smallObstacle(track: "Middle")
                    }
                    else{
                        smallObstacle(track: "Right")
                    }
                    invalidNumber = smallAttackTrack
                }
                tracksToAttack -= 1
            }
        }
    }
    
    func createWarning(track: String){
        let fadeWarnIn = SKAction.fadeIn(withDuration: StartScene.interval!/4)
        let fadeWarnOut = SKAction.fadeOut(withDuration: StartScene.interval!/4)
        let warnSequence = SKAction.sequence([fadeWarnIn, fadeWarnOut, fadeWarnIn, fadeWarnOut])
        
        if(track == "Left"){
            leftWarn.position = CGPoint(x: frame.midX - 192, y: frame.midY)
            leftWarn.run(warnSequence)
        }
        if(track == "Middle"){
            midWarn.position = CGPoint(x: frame.midX, y: frame.midY)
            midWarn.run(warnSequence)
        }
        if(track == "Right"){
            rightWarn.position = CGPoint(x: frame.midX + 192, y: frame.midY)
            rightWarn.run(warnSequence)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if(firstBody.categoryBitMask == PhysicsCategories.Heart && secondBody.categoryBitMask == PhysicsCategories.Damage){
            firstBody.node?.removeFromParent()
            currentState = gameState.endGame
            GameScene.endTime = CACurrentMediaTime()
            timer?.invalidate()
            timer = nil
            runEndGame()
        }
    }
    
    func runEndGame(){
        self.removeAllActions()
        if(StartScene.musicEnabled == true){
            self.gameAudioPlayer.stop()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 0.3)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: frame.size)
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
