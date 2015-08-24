//
//  CustomSongScene.swift
//  Fall
//
//  Created by Vincent Budrovich on 8/14/15.
//  Copyright (c) 2015 Vincent Budrovich. All rights reserved.
//

import UIKit
import SpriteKit
import MediaPlayer

class CustomSongScene: SKScene, UITextFieldDelegate {
    
    
    var textField : UITextField?
    var songTitle : UILabel?
    var backView : UIView?
    var rootView : UIViewController?
    var bpm : Double?
    var duration : Int?
    var leftBtnNode : SKSpriteNode?
    var rightBtnNode : SKSpriteNode?
    var midBtnNode : SKSpriteNode?
   
    override func didMoveToView(view: SKView) {
    
        let recordNode : SKSpriteNode?
        
        rootView = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        backView = UIView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))
        backView!.alpha = 0
        backView!.backgroundColor = UIColor.lightGrayColor()

        backgroundColor = UIColor.whiteColor()
        
        textField = UITextField(frame: CGRectMake(view.bounds.midX - view.bounds.midX * 0.25, view.bounds.midY - view.bounds.midY / 18, 80, 30))
        textField?.delegate = self
        textField?.borderStyle = UITextBorderStyle.RoundedRect
        textField?.keyboardType = UIKeyboardType.NumberPad
        textField?.alpha = 0.0
        textField?.textAlignment = NSTextAlignment.Center
        textField?.highlighted = true
        
        self.addDoneButtonOnKeyboard()
        
        songTitle = UILabel(frame: CGRectMake(view.bounds.minX + view.bounds.midX * 0.25, view.bounds.minY + view.bounds.midY / 3, view.bounds.maxX * 0.75, 30))
        songTitle?.font = UIFont(name: "OratorSTD", size: 15)
        songTitle?.textAlignment = NSTextAlignment.Center
        songTitle?.alpha = 0.0
        songTitle?.minimumScaleFactor = 0.25
        
        leftBtnNode = SKSpriteNode(imageNamed: "leftsegment")
        leftBtnNode!.position = CGPointMake(view.bounds.midX - leftBtnNode!.size.width, view.bounds.midY - view.bounds.midY / 3)
        leftBtnNode!.name = "left"
        leftBtnNode!.alpha = 0
        addChild(leftBtnNode!)
        
        midBtnNode = SKSpriteNode(imageNamed: "middlesegment")
        midBtnNode!.position = CGPointMake(view.bounds.midX, view.bounds.midY - view.bounds.midY / 3)
        midBtnNode!.name = "middle"
        midBtnNode!.alpha = 0
        addChild(midBtnNode!)
        
        rightBtnNode = SKSpriteNode(imageNamed: "rightsegment")
        rightBtnNode!.position = CGPointMake(view.bounds.midX + leftBtnNode!.size.width, view.bounds.midY - view.bounds.midY / 3)
        rightBtnNode!.name = "right"
        rightBtnNode?.alpha = 0
        addChild(rightBtnNode!)
        
        if let song: MPMediaItem = self.userData?.objectForKey("song") as? MPMediaItem {
            
            recordNode = SKSpriteNode(imageNamed: "RECORDgo")
            
            songTitle!.text = song.title
            
            if let beats = self.userData?.objectForKey("songBPM") as? Int {
                textField!.text = NSNumberFormatter().stringFromNumber(beats)
                bpm = Double(beats)
                showFall()
            }
            
            if (song.beatsPerMinute != 0) {
                
                textField!.text = NSNumberFormatter().stringFromNumber(song.beatsPerMinute)
                bpm = Double(song.beatsPerMinute)
                showFall()
            }
            
        } else {
            
            recordNode = SKSpriteNode(imageNamed: "RECORD")
            
            songTitle!.text = "[ touch record ]"
            textField!.placeholder = "0.0"
            
        }

        view.addSubview(textField!)
        view.addSubview(songTitle!)
        
        let chooseSongNode = SKSpriteNode(imageNamed: "CHOOSE")
        chooseSongNode.position = CGPoint(x: view.bounds.midX - view.bounds.midX / 8, y: view.bounds.maxY - view.bounds.maxY / 10)
        addChild(chooseSongNode)
        
        let backNode = SKSpriteNode(imageNamed: "back")
        backNode.position = CGPointMake(view.bounds.minX + view.bounds.maxX / 9, view.bounds.minY + view.bounds.maxY / 14)
        backNode.name = "back"
        addChild(backNode)
        
        recordNode?.name = "record"
        recordNode?.position = CGPointMake(view.bounds.midX, view.bounds.midY + view.bounds.midY / 2.5)
        addChild(recordNode!)
        
        let bpmNode = SKSpriteNode(imageNamed: "beats per minute")
        bpmNode.position = CGPointMake(view.bounds.midX, view.bounds.midY + view.bounds.midY / 8)
        addChild(bpmNode)
        
        UIView.animateWithDuration(0.7, animations: {
            self.textField?.alpha = 1.0
            self.songTitle?.alpha = 1.0
        })
        
        let action = SKAction.rotateByAngle(CGFloat(-M_PI), duration: 8)
        let runningAction = SKAction.runBlock({
            recordNode!.runAction(SKAction.repeatActionForever(action), withKey: "spinningRecord")
        })
        runAction(runningAction, withKey: "spinningRecord")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode.name == "back" {
            let startGameScene = FallStartGameScene(size:size)
            startGameScene.scaleMode = scaleMode
            
            self.textField?.removeFromSuperview()
            self.songTitle?.removeFromSuperview()
            let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 0.5)
            view?.presentScene(startGameScene, transition: transitionType)
        }
        
        if touchedNode.name == "left" || touchedNode.name == "right" || touchedNode.name == "middle" {
            let newGameScene = GameScene(size:size)
            newGameScene.scaleMode = scaleMode
            newGameScene.userData = NSMutableDictionary()
            newGameScene.userData?.setObject(true, forKey: "custom")
            
            let fallAction = SKAction.moveToY(0 - leftBtnNode!.size.height / 2, duration: 0.5)
            let removeBlockAction = SKAction.removeFromParent()
            
            let transitionType = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
            
            let action = SKAction.sequence([fallAction, removeBlockAction])
            
            let finalAction = SKAction.sequence([SKAction.runBlock({self.leftBtnNode!.runAction(action)}), SKAction.waitForDuration(0.3), SKAction.runBlock({self.midBtnNode!.runAction(action)}), SKAction.waitForDuration(0.3), SKAction.runBlock({self.rightBtnNode?.runAction(action)}), SKAction.waitForDuration(0.7)])
            
            if self.userData?.objectForKey("song") != nil && bpm != nil {
                
                newGameScene.userData?.setObject(bpm!, forKey: "songBPM")

                newGameScene.userData?.setObject((self.userData?.objectForKey("song"))!, forKey: "song")
                
                newGameScene.userData?.setObject("custom", forKey: "Previous Screen")
                
                runAction(finalAction, completion: {
                    self.textField?.removeFromSuperview()
                    self.songTitle?.removeFromSuperview()

                    self.view?.presentScene(newGameScene, transition: transitionType)
                })
            }
        }
        
        if touchedNode.name == "record" {
            
            //send message to view controller to show MPMediaPicker
            removeActionForKey("spinningRecord")
            
            view?.addSubview(backView!)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.backView!.alpha = 0.5
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            })
            
            
            var picker = MPMediaPickerController(mediaTypes: .Music)
            
            picker.allowsPickingMultipleItems = false
            picker.showsCloudItems = false
            picker.delegate = rootView as! MPMediaPickerControllerDelegate
            picker.prompt = "To Prevent Lag Avoid Using Search Bar"
            
            rootView?.presentViewController(picker, animated: true, completion: {
                
//                println("The delegate is: \(picker.delegate)")
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.songTitle?.removeFromSuperview()
                    self.textField?.removeFromSuperview()
                    self.backView?.removeFromSuperview()
                    self.view?.presentScene(nil)
                    
                }
            })
        }
    }
    
    func showFall() {
        leftBtnNode?.alpha = 1
        rightBtnNode?.alpha = 1
        midBtnNode?.alpha = 1
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let beats = NSNumberFormatter().numberFromString(textField.text) as? Double {
            bpm = beats
            if bpm != 0{
                if let song = self.userData?.objectForKey("song") as? MPMediaItem {
                    showFall()
                }
            }

        }
    }
    
    func addDoneButtonOnKeyboard() {
        
        var doneToolBar : UIToolbar = UIToolbar(frame: CGRectMake(0,0,320,50))
        doneToolBar.barStyle = UIBarStyle.Black
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        
        done.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        
        var items = NSMutableArray()
        items.addObject(flexSpace)
        items.addObject(done)
        items.addObject(flexSpace)
        
        doneToolBar.items = items as [AnyObject]
        doneToolBar.sizeToFit()
        
        self.textField!.inputAccessoryView = doneToolBar
    }
    
    func doneButtonAction(){
        self.textField?.resignFirstResponder()
    }
}
