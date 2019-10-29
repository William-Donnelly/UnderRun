//
//  GameOverScene.swift
//  SemesterTwoFinalApp
//
//  Created by The Real Kaiser on 5/21/18.
//  Copyright © 2018 William Donnelly. All rights reserved. 
//

import Foundation
import SpriteKit
import AVFoundation

class GameOverScene: SKScene{
    var gameAudioPlayer: AVAudioPlayer!
    
    let restartLabel = SKLabelNode(fontNamed: "ComicNeueSansID")
    let mainMenuLabel = SKLabelNode(fontNamed: "ComicNeueSansID")
    let totalTime = (Int)(GameScene.endTime! - GameScene.startTime!)
    static var highscore: Int?
    
    override func didMove(to view: SKView) {
        print(frame.size)
        if(StartScene.musicEnabled == true){
            startMusic()
        }
        
        //print(frame.size)
        //print(frame.maxX/3)
        let background = SKSpriteNode(imageNamed: "Game Over")
        background.size = frame.size
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = 0
        self.addChild(background)
        
        let highScore = SKLabelNode(fontNamed: "ComicNeueSansID")
        if(GameOverScene.highscore == nil){
            GameOverScene.highscore = 0
        }
        if(GameOverScene.highscore! < totalTime){
            GameOverScene.highscore = totalTime
            highScore.text = "New Highscore: \(GameOverScene.highscore ?? 0) seconds!!!"
        }
        else{
            highScore.text = "Highscore: \(GameOverScene.highscore ?? 0) seconds"
        }
        highScore.fontSize = 50
        highScore.fontColor = SKColor.white
        highScore.position = CGPoint(x: frame.midX, y: frame.maxY - 200)
        highScore.zPosition = 1
        self.addChild(highScore)
        
        let timeLabel = SKLabelNode(fontNamed: "ComicNeueSansID")
        timeLabel.text = "Time: \(totalTime) seconds"
        timeLabel.numberOfLines = 2
        timeLabel.fontSize = 50
        timeLabel.fontColor = SKColor.white
        timeLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 275)
        timeLabel.zPosition = 1
        self.addChild(timeLabel)
        
        let gameOverLabel = SKLabelNode(fontNamed: "ComicNeueSansID")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let restartBorder = SKSpriteNode(imageNamed: "Button Border")
        restartBorder.position = CGPoint(x: frame.midX - 200, y: frame.minY + 70)
        restartBorder.zPosition = 2
        self.addChild(restartBorder)
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 50
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: frame.midX - 200, y: frame.minY + 50)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
        let mainMenuBorder = SKSpriteNode(imageNamed: "Button Border")
        mainMenuBorder.position = CGPoint(x: frame.midX + 200, y: frame.minY + 70)
        mainMenuBorder.zPosition = 2
        self.addChild(mainMenuBorder)
        
        mainMenuLabel.text = "Give Up"
        mainMenuLabel.fontSize = 50
        mainMenuLabel.fontColor = SKColor.white
        mainMenuLabel.position = CGPoint(x: frame.midX + 200, y: frame.minY + 50)
        mainMenuLabel.zPosition = 1
        self.addChild(mainMenuLabel)
    }
    
    func startMusic(){
        do{
            try gameAudioPlayer = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Determination", ofType: "mp3")!))
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if(restartLabel.contains(pointOfTouch)){
                if(StartScene.musicEnabled == true){
                    self.gameAudioPlayer.stop()
                }
                let sceneToMoveTo = GameScene(size: frame.size)
                sceneToMoveTo.scaleMode = SKSceneScaleMode.resizeFill
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            else if(mainMenuLabel.contains(pointOfTouch)){
                if(StartScene.musicEnabled == true){
                    self.gameAudioPlayer.stop()
                }
                let sceneToMoveTo = StartScene(size: frame.size)
                let myTransition = SKTransition.doorsCloseHorizontal(withDuration: 1.0)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
