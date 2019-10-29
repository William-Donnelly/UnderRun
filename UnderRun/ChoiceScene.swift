//
//  ChoiceScene.swift
//  SemesterTwoFinalApp
//
//  Created by The Real Kaiser on 5/1/18.
//  Copyright © 2018 William Donnelly. All rights reserved.
//

import SpriteKit
import Foundation
import AVFoundation

class ChoiceScene: SKScene {
    
    static var boss: String?
    var gameAudioPlayer: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        if(StartScene.musicEnabled == true){
            startMusic()
        }
        
        let info = SKLabelNode(fontNamed: "Papyrus")
        info.text = "Choose Your Boss Fight"
        info.fontColor = UIColor.white
        info.numberOfLines = 1
        info.zPosition = 2
        info.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
        addChild(info)
        
        makeChoiceButtons()
    }
    
    func startMusic(){
        do{
            try gameAudioPlayer = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "sans", ofType: "mp3")!))
            gameAudioPlayer.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
            
            /*do{
                try audioSession.setCategory(convertFromAVAudioSessionCategory(AVAudioSession.Category.playback), mode: <#AVAudioSession.Mode#>)
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
    
    func makeChoiceButtons(){
        let toriel = SKSpriteNode(imageNamed: "Toriel")
        toriel.name = "Toriel"
        //print(frame.maxX/2)
        toriel.position = CGPoint(x: frame.midX - 192, y: frame.maxY - 160)
        toriel.zPosition = 0
        addChild(toriel)
        
        let papyrus = SKSpriteNode(imageNamed: "Papyrus")
        papyrus.name = "Papyrus"
        papyrus.position = CGPoint(x: frame.midX - 192, y: frame.midY)
        papyrus.zPosition = 0
        addChild(papyrus)
        
        let undyne = SKSpriteNode(imageNamed: "Undyne")
        undyne.name = "Undyne"
        undyne.position = CGPoint(x: frame.midX - 192, y: frame.minY + 150)
        undyne.zPosition = 0
        addChild(undyne)
        
        let muffet = SKSpriteNode(imageNamed: "Muffet")
        muffet.name = "Muffet"
        muffet.position = CGPoint(x: frame.midX + 192, y: frame.maxY - 150)
        muffet.zPosition = 0
        addChild(muffet)
        
        let asgore = SKSpriteNode(imageNamed: "Asgore")
        asgore.name = "Asgore"
        asgore.position = CGPoint(x: frame.midX + 192, y: frame.midY)
        asgore.zPosition = 0
        addChild(asgore)
        
        let sans = SKSpriteNode(imageNamed: "Sans")
        sans.name = "Sans"
        sans.position = CGPoint(x: frame.midX + 192, y: frame.minY + 150)
        sans.zPosition = 0
        addChild(sans)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            enumerateChildNodes(withName: "//*") { (node, stop) in
                if(node.name == "Toriel"){
                    if(node.contains(touch.location(in: self))){
                        self.gameAudioPlayer.stop()
                        ChoiceScene.boss = "toriel"
                        let gameScene = GameScene(fileNamed: "GameScene")
                        self.scene?.view?.presentScene(gameScene!, transition: SKTransition.crossFade(withDuration: 1))
                    }
                }
                else if(node.name == "Papyrus"){
                    if(node.contains(touch.location(in: self))){
                        self.gameAudioPlayer.stop()
                        ChoiceScene.boss = "papyrus"
                        let gameScene = GameScene(fileNamed: "GameScene")
                        self.scene?.view?.presentScene(gameScene!, transition: SKTransition.crossFade(withDuration: 1))
                    }
                }
                else if(node.name == "Undyne"){
                    if(node.contains(touch.location(in: self))){
                        self.gameAudioPlayer.stop()
                        ChoiceScene.boss = "undyne"
                        let gameScene = GameScene(fileNamed: "GameScene")
                        self.scene?.view?.presentScene(gameScene!, transition: SKTransition.crossFade(withDuration: 1))
                    }
                }
                else if(node.name == "Muffet"){
                    if(node.contains(touch.location(in: self))){
                        self.gameAudioPlayer.stop()
                        ChoiceScene.boss = "muffet"
                        let gameScene = GameScene(fileNamed: "GameScene")
                        self.scene?.view?.presentScene(gameScene!, transition: SKTransition.crossFade(withDuration: 1))
                    }
                }
                else if(node.name == "Asgore"){
                    if(node.contains(touch.location(in: self))){
                        self.gameAudioPlayer.stop()
                        ChoiceScene.boss = "asgore"
                        let gameScene = GameScene(fileNamed: "GameScene")
                        self.scene?.view?.presentScene(gameScene!, transition: SKTransition.crossFade(withDuration: 1))
                    }
                }
                else if(node.name == "Sans"){
                    if(node.contains(touch.location(in: self))){
                        if(StartScene.musicEnabled == true){
                            self.gameAudioPlayer.stop()
                        }
                        ChoiceScene.boss = "sans"
                        let gameScene = GameScene(fileNamed: "GameScene")
                        self.scene?.view?.presentScene(gameScene!, transition: SKTransition.crossFade(withDuration: 1))
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
