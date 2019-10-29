//
//  StartScene.swift
//  SemesterTwoFinalApp
//
//  Created by The Real Kaiser on 4/30/18.
//  Copyright © 2018 William Donnelly. All rights reserved.
//

import SpriteKit
import Foundation
import AVFoundation

class StartScene: SKScene {
    static var musicEnabled: Bool?
    static var interval: Double?
    var gameAudioPlayer: AVAudioPlayer!
    var memeAudioPlayer: AVAudioPlayer!
    
    let musicOn = SKSpriteNode(imageNamed: "Music On")
    let musicOff = SKSpriteNode(imageNamed: "Music Off")
    let dog = SKSpriteNode(imageNamed: "Dog")
    let boneDog = SKSpriteNode(imageNamed: "Bone Dog")
    
    let easyBox = SKSpriteNode(imageNamed: "Button Border")
    let medBox = SKSpriteNode(imageNamed: "Button Border")
    let hardBox = SKSpriteNode(imageNamed: "Button Border")
    
    override func didMove(to view: SKView) {
        if(StartScene.interval == nil){
            StartScene.interval = 1.0
        }
        
        StartScene.musicEnabled = true
        startMusic()
        
        let background = SKSpriteNode(imageNamed: "StartBackground")
        background.size = frame.size
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        addChild(background)
        
        makeButtons()
        makeDifficulties()
        
        do{
            try memeAudioPlayer = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Doggo", ofType: "mp3")!))
            memeAudioPlayer.prepareToPlay()
            
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
        memeAudioPlayer.volume = 1.0
        memeAudioPlayer.numberOfLoops = 10000
    }
    
    func startMusic(){
        do{
            try gameAudioPlayer = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Core", ofType: "mp3")!))
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
    
    
    func makeButtons(){
        let start = SKSpriteNode(imageNamed: "Fight")
        start.name = "StartGame"
        start.size = CGSize.init(width: 192, height: 50)
        start.position = CGPoint(x: frame.midX + 20, y: frame.midY + 73)
        start.zPosition = 0
        addChild(start)
        
        let act = SKSpriteNode(imageNamed: "Act")
        act.name = "ShowInfo"
        act.size = CGSize.init(width: 192, height: 50)
        act.position = CGPoint(x: frame.midX + 20, y: frame.midY - 123)
        act.zPosition = 0
        addChild(act)
        
        musicOn.name = "MuteButton"
        musicOn.position = CGPoint(x: frame.minX + 50, y: frame.minY + 50)
        musicOn.zPosition = 1
        self.addChild(musicOn)
        
        musicOff.position = CGPoint(x: frame.minX + 50, y: frame.minY + 50)
        musicOff.zPosition = 2
        musicOff.alpha = 0
        self.addChild(musicOff)
        
        dog.name = "Doggo"
        dog.position = CGPoint(x: frame.maxX - 50, y: frame.minY + 25)
        dog.zPosition = 1
        self.addChild(dog)
        
        boneDog.position = CGPoint(x: frame.maxX - 50, y: frame.minY + 25)
        boneDog.zPosition = 2
        boneDog.alpha = 0
        self.addChild(boneDog)
    }
    
    func makeDifficulties(){
        let difficulty = SKLabelNode(fontNamed: "Papyrus")
        difficulty.text = "Choose a Difficulty"
        difficulty.fontSize = 50
        difficulty.fontColor = SKColor.white
        difficulty.position = CGPoint(x: frame.midX, y: frame.minY + 200)
        difficulty.zPosition = 1
        addChild(difficulty)
        
        let easy = SKLabelNode(fontNamed: "Papyrus")
        easy.text = "Easy"
        easy.name = "Easy"
        easy.fontSize = 30
        easy.fontColor = SKColor.white
        easy.position = CGPoint(x: frame.midX - 150, y: frame.minY + 100)
        easy.zPosition = 1
        addChild(easy)
        
        easyBox.size = CGSize(width: 120, height: 50)
        easyBox.position = CGPoint(x: frame.midX - 150, y: frame.minY + 110)
        easyBox.zPosition = 2
        easyBox.alpha = 0
        if(StartScene.interval == 2.0){
            easyBox.alpha = 1
        }
        addChild(easyBox)
        
        let medium = SKLabelNode(fontNamed: "Papyrus")
        medium.text = "Medium"
        medium.name = "Medium"
        medium.fontSize = 30
        medium.fontColor = SKColor.white
        medium.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        medium.zPosition = 1
        addChild(medium)
        
        medBox.size = CGSize(width: 120, height: 50)
        medBox.position = CGPoint(x: frame.midX, y: frame.minY + 110)
        medBox.zPosition = 2
        medBox.alpha = 0
        if(StartScene.interval == 1.0){
            medBox.alpha = 1
        }
        addChild(medBox)
        
        let hard = SKLabelNode(fontNamed: "Papyrus")
        hard.text = "Hard"
        hard.name = "Hard"
        hard.fontSize = 30
        hard.fontColor = SKColor.white
        hard.position = CGPoint(x: frame.midX + 150, y: frame.minY + 100)
        hard.zPosition = 1
        addChild(hard)
        
        hardBox.size = CGSize(width: 120, height: 50)
        hardBox.position = CGPoint(x: frame.midX + 150, y: frame.minY + 110)
        hardBox.zPosition = 2
        hardBox.alpha = 0
        if(StartScene.interval == 0.5){
            hardBox.alpha = 1
        }
        addChild(hardBox)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            enumerateChildNodes(withName: "//*") { (node, stop) in
                if(node.name == "StartGame"){
                    if(node.contains(touch.location(in: self))){
                        self.gameAudioPlayer.stop()
                        self.memeAudioPlayer.stop()
                        let choiceScene = GameScene(fileNamed: "ChoiceScene")
                        self.scene?.view?.presentScene(choiceScene!, transition: SKTransition.crossFade(withDuration: 1.0))
                    }
                }
                else if(node.name == "ShowInfo"){
                    if(node.contains(touch.location(in: self))){
                        self.gameAudioPlayer.stop()
                        self.memeAudioPlayer.stop()
                        let infoScene = GameScene(fileNamed: "InfoScene")
                        self.scene?.view?.presentScene(infoScene!, transition: SKTransition.crossFade(withDuration: 1.0))
                    }
                }
                else if(node.name == "Easy"){
                    if(node.contains(touch.location(in: self))){
                        StartScene.interval = 2.0
                        self.easyBox.alpha = 1
                        self.medBox.alpha = 0
                        self.hardBox.alpha = 0
                    }
                }
                else if(node.name == "Medium"){
                    if(node.contains(touch.location(in: self))){
                        StartScene.interval = 1.0
                        self.easyBox.alpha = 0
                        self.medBox.alpha = 1
                        self.hardBox.alpha = 0
                    }
                }
                else if(node.name == "Hard"){
                    if(node.contains(touch.location(in: self))){
                        StartScene.interval = 0.5
                        self.easyBox.alpha = 0
                        self.medBox.alpha = 0
                        self.hardBox.alpha = 1
                    }
                }
                else if(node.name == "MuteButton"){
                    if(node.contains(touch.location(in: self))){
                        if(StartScene.musicEnabled == true){
                            self.gameAudioPlayer.stop()
                            self.memeAudioPlayer.stop()
                            StartScene.musicEnabled = false
                            self.musicOff.alpha = 1
                        }
                        else{
                            self.gameAudioPlayer.play()
                            StartScene.musicEnabled = true
                            self.musicOff.alpha = 0
                        }
                    }
                }
                else if(node.name == "Doggo"){
                    if(node.contains(touch.location(in: self))){
                        if(self.dog.alpha == 1){
                            self.dog.alpha = 0
                            self.boneDog.alpha = 1
                            if(StartScene.musicEnabled == true){
                                self.gameAudioPlayer.stop()
                                self.memeAudioPlayer.play()
                            }
                        }
                        else{
                            self.boneDog.alpha = 0
                            self.dog.alpha = 1
                            if(StartScene.musicEnabled == true){
                                self.memeAudioPlayer.stop()
                                self.gameAudioPlayer.play()
                            }
                        }
                    }
                }
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
