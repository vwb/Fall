//
//  FallGameOverScene.swift
//  Fall
//
//  Created by Vincent Budrovich on 8/9/15.
//  Copyright (c) 2015 Vincent Budrovich. All rights reserved.
//

import UIKit
import SpriteKit
import MediaPlayer

class FallGameOverScene: SKScene {
    
    var circleChart = PNCircleChart()
    let maxLevel = 11
    var songLevel = 0
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = UIColor.whiteColor()
        
        let songCompletion = self.userData?.objectForKey("Song Percentage") as! Int

        circleChart = PNCircleChart(frame: CGRectMake(view.bounds.midX - view.bounds.maxX * 0.28, view.bounds.midY / 6, view.bounds.width * 0.55, view.bounds.width * 0.55), total: 100, current: songCompletion, clockwise: true, shadow: false, shadowColor: nil, displayCountingLabel: true, overrideLineWidth: 3)
        circleChart.backgroundColor = UIColor.clearColor()
        circleChart.strokeColor = UIColor.blackColor()
        
        view.addSubview(circleChart)
        
        
        circleChart.strokeChart()
        
        if let songs = self.userData?.objectForKey("CurrentUserLevel") as? Int {
            songLevel = songs
            
            if currentLevel < maxLevel && currentLevel == songLevel && songCompletion > 78{
                currentLevel += 1
            }
        }
        
        var result1 = SKSpriteNode(imageNamed: "fadeOval")
        var result2 = SKSpriteNode(imageNamed: "fadeOval")
        var result3 = SKSpriteNode(imageNamed: "fadeOval")
        
        let resultSize = CGSize(width: result1.size.width * 0.8, height: result1.size.height * 0.8)
        
        if songCompletion > 78 && songCompletion < 90 {
            result1 = SKSpriteNode(imageNamed: "star")
            result1.alpha = 0
        }
        
        if songCompletion >= 90 && songCompletion < 98 {
            result1 = SKSpriteNode(imageNamed: "star")
            result1.alpha = 0
            result2 = SKSpriteNode(imageNamed: "star")
            result2.alpha = 0
        }
        
        if songCompletion >= 98 {
            result1 = SKSpriteNode(imageNamed: "star")
            result2 = SKSpriteNode(imageNamed: "star")
            result3 = SKSpriteNode(imageNamed: "star")
            result1.alpha = 0
            result2.alpha = 0
            result3.alpha = 0
        }
        
        result1.position = CGPoint(x: view.bounds.midX - view.bounds.midX / 2.5, y: view.bounds.midY - view.bounds.midY / 3.5)
        result2.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY - view.bounds.midY / 3.5)
        result3.position = CGPoint(x: view.bounds.midX + view.bounds.midX / 2.5, y: view.bounds.midY - view.bounds.midY / 3.5)
        
        
        result1.size = resultSize
        result2.size = resultSize
        result3.size = resultSize
        
        addChild(result1)
        addChild(result2)
        addChild(result3)
        
        let action = SKAction.fadeAlphaTo(1, duration: 0.25)
        
        let actionSequence = SKAction.sequence([SKAction.runBlock({result1.runAction(action)}), SKAction.waitForDuration(0.2), SKAction.runBlock({result2.runAction(action)}), SKAction.waitForDuration(0.2), SKAction.runBlock({result3.runAction(action)})])
        
        runAction(actionSequence)
        
        let starHolder = SKSpriteNode(imageNamed: "starHolder")
        starHolder.position = CGPointMake(view.bounds.midX, view.bounds.midY - view.bounds.midY / 3.5)
        starHolder.alpha = 0.25
        starHolder.size.height = starHolder.size.height * 0.8
        starHolder.size.width = starHolder.size.width * 0.9
        addChild(starHolder)
        
        let retrybttn = SKSpriteNode(imageNamed: "resultRestart")
        retrybttn.position = CGPointMake(view.bounds.midX, view.bounds.minY + view.bounds.minY + view.bounds.maxY / 14)
        retrybttn.size.height = retrybttn.size.height * 0.8
        retrybttn.size.width = retrybttn.size.width * 0.8
        retrybttn.name = "restart"
        retrybttn.alpha = 0.75
        addChild(retrybttn)
        
        let backBttn = SKSpriteNode(imageNamed: "back")
        backBttn.position = CGPointMake(view.bounds.minX + view.bounds.maxX / 9, view.bounds.minY + view.bounds.maxY / 14)
        backBttn.name = "back"
        backBttn.size.height = backBttn.size.height * 0.8
        backBttn.size.width = backBttn.size.width * 0.8
        addChild(backBttn)
        
        let homeSprite = SKSpriteNode(imageNamed: "resultHome")
        homeSprite.position = CGPointMake(view.bounds.maxX - view.bounds.maxX / 9, view.bounds.minY + view.bounds.maxY / 14)
        homeSprite.name = "home"
        homeSprite.size.height = homeSprite.size.height * 0.8
        homeSprite.size.width = homeSprite.size.width * 0.8
        addChild(homeSprite)
        
        let completeSprite = SKSpriteNode(imageNamed:"complete@1x")
        completeSprite.position = CGPointMake(view.bounds.midX, view.bounds.midY + view.bounds.midY / 8)
        completeSprite.size.height = completeSprite.size.height * 0.75
        completeSprite.size.width = completeSprite.size.width * 0.75
        completeSprite.name = "complete"
        completeSprite.alpha = 0.4
        addChild(completeSprite)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode.name == "restart" {
            let newGameScene = GameScene(size: size)
            newGameScene.scaleMode = scaleMode
            newGameScene.userData = NSMutableDictionary()

            let previous = self.userData?.objectForKey("Previous Screen") as! String
            
            if previous == "custom" {
                
                if let song = self.userData?.objectForKey("song") as? MPMediaItem {
                    newGameScene.userData?.setObject(song, forKey: "song")
                    newGameScene.userData?.setObject(true, forKey: "custom")
                    let bpm = self.userData?.objectForKey("songBPM") as! Double
                    newGameScene.userData?.setObject(bpm, forKey: "songBPM")
                }
                
            } else {
                
                let level = self.userData?.objectForKey("CurrentUserLevel") as! Int
                newGameScene.userData?.setObject(level, forKey: User.level)
            }
            
            newGameScene.userData?.setObject((self.userData?.objectForKey("Previous Screen"))!, forKey: "Previous Screen")
            
            circleChart.removeFromSuperview()
            
            let transitionType = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
            view?.presentScene(newGameScene, transition: transitionType)
        }
        
        if touchedNode.name == "back" {
            var newScreen : SKScene?

            if let previousScene = self.userData?.objectForKey("Previous Screen") as? String {
                switch previousScene {
                case "select":
                    
                    newScreen = SelectScene(size:size)
                    newScreen!.userData = NSMutableDictionary()
                    newScreen?.userData?.setObject(currentLevel, forKey: User.level)
                    
                case "custom":
                    newScreen = CustomSongScene(size:size)
                    newScreen!.userData = NSMutableDictionary()

                    newScreen?.userData?.setObject((self.userData?.objectForKey("song"))!, forKey: "song")
                    newScreen?.userData?.setObject((self.userData?.objectForKey("songBPM"))!, forKey: "songBPM")
                    
                case "home": newScreen = FallStartGameScene(size:size)
                    
                default: newScreen = FallStartGameScene(size:size)
                }
            }
            
            newScreen?.scaleMode = scaleMode
            
            circleChart.removeFromSuperview()
            
            let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 0.5)
            view?.presentScene(newScreen, transition: transitionType)
        }
        
        if touchedNode.name == "home" {
            
            let homeScreen = FallStartGameScene(size:size)
            homeScreen.scaleMode = scaleMode
            
            circleChart.removeFromSuperview()
            
            let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 0.5)
            view?.presentScene(homeScreen, transition: transitionType)
            
        }
    }
    
    struct User {
        static let level = "CurrentUserLevel"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var currentLevel : Int {
        get{ return defaults.objectForKey(User.level) as? Int ?? 0}
        set{ defaults.setObject(newValue, forKey: User.level)}
    }
    
}

    

