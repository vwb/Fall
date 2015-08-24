//
//  SettingsScene.swift
//  Fall
//
//  Created by Vincent Budrovich on 8/21/15.
//  Copyright (c) 2015 Vincent Budrovich. All rights reserved.
//

import UIKit
import SpriteKit

class SettingsScene: SKScene {
    
    var slowNode : SKSpriteNode?
    var fastNode : SKSpriteNode?
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.whiteColor()
        
        let settingsNode = SKSpriteNode(imageNamed: "SETTINGSSCR@1x")
        settingsNode.position = CGPointMake(view.bounds.midX - view.bounds.midX / 8, view.bounds.maxY - view.bounds.maxY / 10)
        addChild(settingsNode)
        
        slowNode = SKSpriteNode(imageNamed: "slow")
        slowNode!.name = "slow"
        slowNode!.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY + slowNode!.size.height / 2)
        addChild(slowNode!)
        
        fastNode = SKSpriteNode(imageNamed: "fast")
        fastNode!.name = "fast"
        fastNode!.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY - fastNode!.size.height)
        addChild(fastNode!)
        
        let backNode = SKSpriteNode(imageNamed: "back")
        backNode.name = "back"
        backNode.position = CGPointMake(view.bounds.minX + view.bounds.maxX / 9, view.bounds.minY + view.bounds.maxY / 14)
        addChild(backNode)
        
        let speedNode = SKSpriteNode(imageNamed: "speed")
        speedNode.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY + view.bounds.midY / 2)
        addChild(speedNode)
        
        let speed = chosenSpeed
        
        if speed == 3 {
            slowNode!.alpha = 1
            fastNode!.alpha = 0.25
        } else if speed == 2 {
            slowNode!.alpha = 0.25
            fastNode!.alpha = 1
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode.name == "slow" {
            
            chosenSpeed = 3
            
            let slowAction = SKAction.fadeAlphaTo(1, duration: 0.35)
            let fastAction = SKAction.fadeAlphaTo(0.15, duration: 0.35)
            
            slowNode?.runAction(slowAction)
            fastNode?.runAction(fastAction)
            
        }
        
        if touchedNode.name == "fast" {
            
            chosenSpeed = 2
            
            let slowAction = SKAction.fadeAlphaTo(0.15, duration: 0.35)
            let fastAction = SKAction.fadeAlphaTo(1, duration: 0.35)
            
            slowNode?.runAction(slowAction)
            fastNode?.runAction(fastAction)
            
        }
        
        if touchedNode.name == "back" {
            
            let homeGameScreen = FallStartGameScene(size: size)
            homeGameScreen.scaleMode = scaleMode
            
            let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 0.5)
            view?.presentScene(homeGameScreen, transition: transitionType)
        }
        
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var chosenSpeed : Int {
        get{ return defaults.objectForKey(Constants.UserSpeed) as? Int ?? 1}
        set{ defaults.setObject(newValue, forKey: Constants.UserSpeed)}
    }

    private struct Constants {
        static let UserSpeed = "User Speed Setting"
    }
   
}
