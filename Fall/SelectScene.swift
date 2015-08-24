//
//  SettingsScene.swift
//  Fall
//
//  Created by Vincent Budrovich on 8/11/15.
//  Copyright (c) 2015 Vincent Budrovich. All rights reserved.
//

import UIKit
import SpriteKit

class SelectScene: SKScene {
    
    var currentLevel = 0
    var spriteArray = [String]()
    
    var numberOfColumns = 3
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.whiteColor()
        
        for index in 0...11 {
            spriteArray.append("level\(index+1)")
        }
        
        currentLevel = self.userData?.objectForKey("CurrentUserLevel") as! Int
    
        println("The current level is: \(currentLevel)")
        
        let selectNode = SKSpriteNode(imageNamed: "select")
        selectNode.position = CGPointMake(view.bounds.midX - view.bounds.midX / 8, view.bounds.maxY - view.bounds.maxY / 10)
        addChild(selectNode)
        
        let backNode = SKSpriteNode(imageNamed: "back")
        backNode.position = CGPointMake(view.bounds.minX + view.bounds.maxX / 9, view.bounds.minY + view.bounds.maxY / 14)
        backNode.name = "back"
        addChild(backNode)
        
        var i = 0
        var j = 0
        var currentY = CGFloat(view.bounds.maxY - view.bounds.maxY / 3.5)
        var currentX = CGFloat(view.bounds.minX + view.bounds.maxX / 6)
            
        while i <= currentLevel {
                
            while j < numberOfColumns {
                    
                if i > currentLevel {
                    return
                }
                    
                let levelNode =  SKSpriteNode(imageNamed: spriteArray[i])
                levelNode.position = CGPointMake(currentX, currentY)
                levelNode.name = spriteArray[i]
                addChild(levelNode)
                
                currentX = currentX + view.bounds.maxX / 3
                
                j++
                i++
            }
                
            j = 0
                
            currentY = currentY - view.bounds.maxY / 6
            currentX = CGFloat(view.bounds.minX + view.bounds.maxX / 6)
        }
        
        //println("The current level is: \(currentLevel)")
        

        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode.name == "back" {
            let startGameScene = FallStartGameScene(size:size)
            startGameScene.scaleMode = scaleMode
            
            let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 0.5)
            view?.presentScene(startGameScene, transition: transitionType)
            
        } else if let myString = touchedNode.name{
            
            var myString = touchedNode.name!
            var endIndex = advance(myString.endIndex, -1)
            
            let textIndex = advance(touchedNode.name!.startIndex, 5)
            let testString = touchedNode.name!.substringToIndex(textIndex)
            
            if count(myString) == 7 {
                endIndex = advance(myString.endIndex, -2)
            }
            
            myString = myString.substringFromIndex(endIndex)
            
            var level = NSNumberFormatter().numberFromString(myString) as! Int
            level -= 1
            
            if testString == "level" {
                let newGameScene = GameScene(size:size)
                newGameScene.scaleMode = scaleMode
                
                newGameScene.userData = NSMutableDictionary()
                newGameScene.userData?.setObject(level, forKey: "CurrentUserLevel")
                newGameScene.userData?.setObject("select", forKey: "Previous Screen")
                
                println("The level being passed to newGameScene is: \(level)")
                
                let transitionType = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
                view?.presentScene(newGameScene, transition: transitionType)
            }
        }
        
        

    }
    
   
}
