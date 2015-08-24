//
//  GameViewController.swift
//  Fall
//
//  Created by Vincent Budrovich on 7/28/15.
//  Copyright (c) 2015 Vincent Budrovich. All rights reserved.
//

import UIKit
import SpriteKit
import MediaPlayer

class GameViewController: UIViewController, MPMediaPickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = FallStartGameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)        
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController!) {
        
        let customScene = CustomSongScene(size: view.bounds.size)
        let skView = view as! SKView
        customScene.scaleMode = .ResizeFill
        
        //println("The mediaPicker when cancelled from ViewController: \(mediaPicker)")

        skView.presentScene(customScene)

        mediaPicker.dismissViewControllerAnimated(true, completion: nil)


    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController!, didPickMediaItems mediaItemCollection: MPMediaItemCollection!) {
        
        var song : MPMediaItem?
        
        //println("The mediaPicker when song chosen from ViewController: \(mediaPicker)")
        
        if let test = mediaItemCollection.items[0] as? MPMediaItem {
            song = test
        }
        
        
        //println("I have grabbed a song: \(song)")
        
        let customScene2 = CustomSongScene(size: view.bounds.size)
        let skView = view as! SKView
        customScene2.scaleMode = .ResizeFill
        customScene2.userData = NSMutableDictionary()
        customScene2.userData?.setObject(song!, forKey: "song")
        
        skView.presentScene(customScene2)
        
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
        
        song = nil

    }
    

}
