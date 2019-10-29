//
//  InfoScene.swift
//  SemesterTwoFinalApp
//
//  Created by The Real Kaiser on 5/22/18.
//  Copyright © 2018 William Donnelly. All rights reserved. 
//

import Foundation
import SpriteKit
import AVFoundation

class InfoScene: SKScene{
    var gameAudioPlayer: AVAudioPlayer!
    let mainMenuReturn = SKLabelNode(fontNamed: "Papyrus")
    
    override func didMove(to view: SKView) {
        if(StartScene.musicEnabled == true){
            startMusic()
        }
        
        let background = SKSpriteNode(imageNamed: "infoBackground")
        background.size = frame.size
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        addChild(background)
        
        let gameInfo = SKLabelNode(fontNamed: "Papyrus")
        gameInfo.text = "Instructions: You control the heart (your soul) at the bottom of the screen. Obstacles will spawn at you randomly and you must dodge them by swiping left or right to change the heart's position. Try and survive the onslaught for as long as you can!"
        gameInfo.fontSize = 30
        gameInfo.fontColor = UIColor.white
        gameInfo.numberOfLines = 0
        gameInfo.preferredMaxLayoutWidth = frame.size.width/1.25
        gameInfo.zPosition = 2
        gameInfo.position = CGPoint(x: frame.midX, y: frame.midY + 112)
        addChild(gameInfo)
        
        let devInfo = SKLabelNode(fontNamed: "Papyrus")
        devInfo.text = "Developer Stuff: This entire app was created by me (William Donnelly). The game's theme and soundtracks are all inspired by Toby Fox's game: Undertale. The game's background images were taken from websites like DeviantArt."
        devInfo.fontSize = 30
        devInfo.fontColor = UIColor.white
        devInfo.numberOfLines = 0
        devInfo.preferredMaxLayoutWidth = frame.size.width/1.25
        devInfo.zPosition = 2
        devInfo.position = CGPoint(x: frame.midX, y: frame.midY - 224)
        addChild(devInfo)
        
        mainMenuReturn.text = "Return to Menu"
        mainMenuReturn.fontSize = 40
        mainMenuReturn.fontColor = UIColor.white
        mainMenuReturn.zPosition = 2
        mainMenuReturn.position = CGPoint(x: frame.midX, y: -(frame.size.height/2) + 50)
        addChild(mainMenuReturn)
        
        let returnBox = SKSpriteNode(imageNamed: "Button Border")
        returnBox.size = CGSize(width: 300, height: 50)
        returnBox.zPosition = 2
        returnBox.position = CGPoint(x: frame.midX, y: -(frame.size.height/2) + 60)
        addChild(returnBox)
        
    }
    
    func startMusic(){
        do{
            try gameAudioPlayer = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Snowdin", ofType: "mp3")!))
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
            
            if(mainMenuReturn.contains(pointOfTouch)){
                if(StartScene.musicEnabled == true){
                    gameAudioPlayer.stop()
                }
                let sceneToMoveTo = StartScene(size: frame.size)
                let myTransition = SKTransition.doorsCloseVertical(withDuration: 1.0)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
