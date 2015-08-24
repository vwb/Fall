//
//  FallStartGameScene.swift
//  Fall
//
//  Created by Vincent Budrovich on 8/7/15.
//  Copyright (c) 2015 Vincent Budrovich. All rights reserved.
//

import UIKit
import SpriteKit

class FallStartGameScene: SKScene {
    
    var logic : BlockLogic?
    
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.whiteColor()
        
        let backGroundImage = SKSpriteNode(imageNamed: "Intro Screen Copy@1x")
        backGroundImage.position = CGPointMake(view.center.x, view.center.y)
        backGroundImage.size = view.bounds.size
        addChild(backGroundImage)
        
        let startGameBtn = SKSpriteNode(imageNamed: "MusicIcon")
        startGameBtn.position = CGPointMake(view.bounds.midX, view.bounds.midY + view.bounds.midY / 8.5)
        startGameBtn.name = "custom"
        addChild(startGameBtn)
        
        logic = BlockLogic(view: view, opacity: 0.3)
        
        let selectBtn = SKSpriteNode(imageNamed: "LevelsIcon")
        selectBtn.position = CGPointMake(view.bounds.midX, view.bounds.midY - view.bounds.midY / 6.35)
        selectBtn.name = "select"
        addChild(selectBtn)
        
        let settingsButton = SKSpriteNode(imageNamed: "SettingsIcon")
        settingsButton.position = CGPointMake(view.bounds.midX, view.bounds.midY - view.bounds.midY / 2.35)
        settingsButton.name = "settings"
        addChild(settingsButton)
        
        let action = SKAction.sequence([SKAction.runBlock(finalizedAddBlock), SKAction.waitForDuration(1)])
        runAction(SKAction.repeatActionForever(action), withKey: "addWinning")
        
        let randomBlock = logic?.chosenBlock()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode.name == "select" {
            let newSelectScene = SelectScene(size:size)
            newSelectScene.scaleMode = scaleMode
            let level = currentLevel
            
            newSelectScene.userData = NSMutableDictionary()
            newSelectScene.userData?.setObject(level, forKey: User.level)
            
            removeAllActions()
            
            let transitionType = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
            view?.presentScene(newSelectScene, transition: transitionType)
        }
        
        if touchedNode.name == "custom" {
            
            
            let newCustomScene = CustomSongScene(size:size)
            let rootView = UIApplication.sharedApplication().keyWindow?.rootViewController
            
            
            
            removeAllActions()
            
            let transitionType = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
            view?.presentScene(newCustomScene, transition: transitionType)
            
            //rootView?.presentViewController(newCustomScene, animated: true, completion: nil)
            
        }
        
        if touchedNode.name == "settings" {
            let newSettingsScene = SettingsScene(size:size)
            newSettingsScene.scaleMode = scaleMode
            
            removeAllActions()
            
            let transitionType = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
            view?.presentScene(newSettingsScene, transition: transitionType)
        }
        
    }
    
    
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var currentLevel : Int {
        get{ return defaults.objectForKey(User.level) as? Int ?? 0}
        set{ defaults.setObject(newValue, forKey: User.level)}
    }
    
    
    struct User {
        static let level = "CurrentUserLevel"
    }
    
    
    
    func finalizedAddBlock() {
        var blockArray = logic!.finalizedAddBlock()
        let fallingBlockAction = SKAction.moveToY(0 - view!.bounds.maxX / 3, duration: 5)
        let removeBlockAction = SKAction.removeFromParent()
        
        switch blockArray.count {
            
        case 1:
            
            let block = blockArray[0]
            block?.zPosition = -1
            addChild(block!)
            
            block!.runAction(SKAction.sequence([fallingBlockAction, removeBlockAction]))
            
            
        case 2:
            
            let block = blockArray[0]
            let block2 = blockArray[1]
            block?.zPosition = -1
            block2?.zPosition = -1
            addChild(block!)
            addChild(block2!)
            
            block!.runAction(SKAction.sequence([fallingBlockAction, removeBlockAction]))
            block2!.runAction(SKAction.sequence([fallingBlockAction, removeBlockAction]))
            
            
        case 3:
            
            let block = blockArray[0]
            let block2 = blockArray[1]
            let block3 = blockArray[2]
            
            block?.zPosition = -1
            block2?.zPosition = -1
            block3?.zPosition = -1
            addChild(block!)
            addChild(block2!)
            addChild(block3!)
            
            block!.runAction(SKAction.sequence([fallingBlockAction, removeBlockAction]))
            block2!.runAction(SKAction.sequence([fallingBlockAction, removeBlockAction]))
            block3!.runAction(SKAction.sequence([fallingBlockAction, removeBlockAction]))
       
        default: break

        }
        
        
    }
   
}
