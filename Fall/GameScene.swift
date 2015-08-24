//
//  GameScene.swift
//  Fall
//
//  Created by Vincent Budrovich on 7/28/15.
//  Copyright (c) 2015 Vincent Budrovich. All rights reserved.
//

import SpriteKit
import AVFoundation
import MediaPlayer

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Mark: GameScene Variables Declarations
    
    var chosenColor : String?
    
    var timer = 4
    var level = 0
    
    var leftOfWinningPosition = CGPoint(x: 0, y: 0)
    var rightOfWinningPosition = CGPoint(x: 0, y: 0)
    var blockWinningPosition = CGPoint(x: 0, y: 0)
    
    
    
    var myView : SKView?
    var clock : NSTimer?
    var mediaItem : MPMediaItem?
    var score : Int?
    var totalPossibleScore : Int?
    var missedCount : Int?

    
    var finishedGame = true
    
    
    //Song information
    var songLength = 0.0
    var songBPM = 0.0
    var duration = 0.0
    var fullSongLength = 0.0
    
    //Instantiating Classes
    var musicPlayer = AVAudioPlayer()
    var songs = MusicClass()
    var myChart = PNCircleChart()
    var mySecondChart = PNCircleChart()
    var artist = UIView()
    var logic = BlockLogic()
    var timerIsEnabled = true
    var utilArray = [SKNode]()
    
    //MARK: Gamescene setup, assign values to variables
    
    override func didMoveToView(view: SKView) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        
        myView = view
        setUpScene(myView!)
        
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var chosenSpeed : Int {
        get{ return defaults.objectForKey("User Speed Setting") as? Int ?? 3}
        set{ defaults.setObject(newValue, forKey: "User Speed Setting")}
    }
    
    func setUpScene(view: SKView){
        
        score = 0
        missedCount = 0
        
        timer = 4
        logic = BlockLogic(view: myView!)
        
        backgroundColor = UIColor.whiteColor()
        
        
        leftOfWinningPosition = CGPoint(x: logic.column1, y: view.bounds.minY - CGFloat(1))
        rightOfWinningPosition = CGPoint(x: logic.column3, y: view.bounds.minY - CGFloat(1))
        blockWinningPosition = CGPoint(x: logic.column2, y: view.bounds.minY - CGFloat(1))
        
        //Set up the appearance of the scene
        
        //add the winningSprite node to bottom of screen
        let winningSprite = logic.chosenBlock()
        winningSprite.size.width = view.bounds.width / 3
        winningSprite.size.height = winningSprite.size.height / 2
        winningSprite.position = CGPoint(x: view.bounds.midX, y: (view.bounds.minY + winningSprite.size.height / 2))
        winningSprite.zPosition = 1
        winningSprite.name = "goal"
        chosenColor = winningSprite.colorDesc
        addChild(winningSprite)
        
        //add white borders to bottom of screen
        let bottomSprite = SKSpriteNode(imageNamed: "whiteBlock")
        bottomSprite.size.width = view.bounds.width / 3
        bottomSprite.size.height = bottomSprite.size.height * 2
        bottomSprite.position = CGPoint(x: logic.column3, y: view.bounds.minY + bottomSprite.size.height / 2)
        bottomSprite.name = "null"
        bottomSprite.zPosition = 1
        addChild(bottomSprite)
        
        let bottomLeftSprite = SKSpriteNode(imageNamed: "whiteBlock")
        bottomLeftSprite.size = bottomSprite.size
        bottomLeftSprite.position = CGPoint(x: logic.column1, y: view.bounds.minY + bottomLeftSprite.size.height / 2)
        bottomLeftSprite.name = "null"
        bottomLeftSprite.zPosition = 1
        addChild(bottomLeftSprite)
        
        //add pause button sprite
        let pauseButtonSprite = SKSpriteNode(imageNamed: "pauseButton")
        pauseButtonSprite.position = CGPoint(x: logic.column3, y: view.bounds.minY + bottomLeftSprite.size.height / 2)
        pauseButtonSprite.name = "pause"
        pauseButtonSprite.zPosition = 2
        addChild(pauseButtonSprite)
        
        
        //Set up Song information and intro views
        if let variable = self.userData?.objectForKey("custom") as? Bool {
            
            mediaItem = self.userData?.objectForKey("song") as? MPMediaItem
            songBPM = self.userData?.objectForKey("songBPM") as! Double
            songLength = (mediaItem!.valueForProperty(MPMediaItemPropertyPlaybackDuration) as! Double)
            
//            println("This is the passed in songlength: \(songLength)")
            
            fullSongLength = songLength + 4
            duration = 60 / songBPM
            
            let customSong = Song(artist: mediaItem!.artist, title: mediaItem!.title)
            let filePath = mediaItem!.assetURL.absoluteString
            
            var error: NSError?
            musicPlayer = AVAudioPlayer(contentsOfURL: mediaItem!.assetURL, error: &error)
            
            artist = addArtistsInfo(view, song: customSong)

            
            
        } else {
            
            level = self.userData?.objectForKey("CurrentUserLevel") as! Int
            var song = songs.songSelector[level]
            songBPM = song!.bpm
            songLength = song!.length
            fullSongLength = songLength + 4
            duration = 60 / songBPM
            musicPlayer = setupAudioPlayerWithFile(NSString(string: song!.filePath), type: NSString(string: song!.type))
            
            artist = addArtistsInfo(view, song: song!)

            
            
        }
        
        artist.alpha = 0
        view.addSubview(self.artist)
        
        musicPlayer.prepareToPlay()
        
        let totalNumberOfBlocks = (songLength/60) * songBPM
//        println("the total number of blocks: \(totalNumberOfBlocks)")
        
        //var pointsPerBlock = Double(-(pow(songBPM, 2)) * 0.0003) - (Double(songBPM) * 0.0423) + 17.309
        
        var pointsPerBlock : Double?
        
        if chosenSpeed == 2 {
            pointsPerBlock = Double((pow(songBPM, 2)) * 0.0005) - (Double(songBPM) * 0.1945) + 24.2219
        }
        
        if chosenSpeed == 3 {
            pointsPerBlock = Double((pow(songBPM, 2)) * 0.0012) - (Double(songBPM) * 0.3897) + 41.2285
        }
        
        let finalPointsPerBlock = (pointsPerBlock)
        let finalTotalNumerOfBlocks = (totalNumberOfBlocks)
        
        let doubleTotalPossibleScore = (finalTotalNumerOfBlocks) * (finalPointsPerBlock!)
        
        totalPossibleScore = Int(doubleTotalPossibleScore)
        
        //add circle chart to represent opacity on bottom left of screen
        myChart = PNCircleChart(frame: CGRectMake(view.bounds.minX, view.bounds.maxY - bottomLeftSprite.size.height / 1.25, bottomLeftSprite.size.width, bottomLeftSprite.size.height / 1.5), total: totalPossibleScore!, current: score!, clockwise: true, shadow: false, shadowColor: UIColor.clearColor(), displayCountingLabel: false, overrideLineWidth: 2)
        
        myChart.backgroundColor = UIColor.clearColor()
        myChart.strokeColor = UIColor.grayColor()
        
        view.addSubview(myChart)
        myChart.strokeChart()
        
        
        mySecondChart = PNCircleChart(frame: CGRectMake(view.bounds.minX, view.bounds.maxY - bottomLeftSprite.size.height / 1.6, bottomLeftSprite.size.width, bottomLeftSprite.size.height / 3), total: 100, current: logic.blockAlpha*100, clockwise: true, shadow: false, shadowColor: UIColor.clearColor(), displayCountingLabel: false, overrideLineWidth: 1)
        
        mySecondChart.backgroundColor = UIColor.clearColor()
        mySecondChart.strokeColor = UIColor.lightGrayColor()
        
        view.addSubview(mySecondChart)
        view.bringSubviewToFront(mySecondChart)
        mySecondChart.strokeChart()
        
        UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.artist.alpha = 1
            }, completion: nil)

        //set up swiping
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        clock = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "countdown:", userInfo: nil, repeats: true)
    }
    
    
    func appResignActive(){
//        println("App is going to background")
        
        if scene!.view?.paused == false {
            pause()
        }
    }
    
    //Set up AudioPlayer for Music
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer {
        
        var path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        var url = NSURL.fileURLWithPath(path!)
        
        //2
        var error: NSError?
        
        //3
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        //4
        return audioPlayer!
    }
    
    //Setting up artist view
    
    func addArtistsInfo(view: SKView, song: Song) -> UIView {
        let containerView = UIView(frame: CGRectMake(view.bounds.minX + view.bounds.midX / 4, view.bounds.minY + view.bounds.midY / 4, view.bounds.width * 0.75, view.bounds.height * 0.5))
        
        var artistName = UILabel(frame: CGRectMake(containerView.bounds.minX, containerView.bounds.midY, containerView.bounds.width, containerView.bounds.height/4))
        
        var songTitle = UILabel(frame: CGRectMake(containerView.bounds.minX, containerView.bounds.midY - containerView.bounds.midY / 2, containerView.bounds.width, containerView.bounds.height/4))
        
        var by = UILabel(frame: CGRectMake(containerView.bounds.minX, containerView.bounds.midY - containerView.bounds.midY / 8, containerView.bounds.width, containerView.bounds.height/8))
        
        artistName.text = song.artist
        songTitle.text = song.title
        by.text = "by"
        
        artistName.textAlignment = NSTextAlignment.Center
        songTitle.textAlignment = NSTextAlignment.Center
        by.textAlignment = NSTextAlignment.Center
        
        containerView.addSubview(artistName)
        containerView.addSubview(songTitle)
        containerView.addSubview(by)
        
        artistName.font = UIFont(name: "OratorStd", size: 25)
        songTitle.font = UIFont(name: "OratorStd", size: 25)
        by.font = UIFont(name: "OratorStd", size: 15)
        
        return containerView
    }
    
    //Countdown timer that starts off the game and also counts down the songlength
    
    func countdown(clock: NSTimer){
        
        if timerIsEnabled {
            timer--
            fullSongLength--
        }
        
        if timer == 0 {
            startGame()
        }
        
        if timer == 1 {
            UIView.animateWithDuration(0.5, animations: {
                self.artist.alpha = 0
                }, completion: { finished in
                    self.artist.removeFromSuperview()
            })
        }
        
        if !finishedGame{
            endGame(false)
            clock.invalidate()
        } else if fullSongLength <= -2{
            endGame(true)
            clock.invalidate()
        } else if fullSongLength <= 0{
            finishedLevel()
        }
        
        
    }
    
    //StartGame
    
    func startGame(){
        
        musicPlayer.play()
        
        let action = SKAction.sequence([SKAction.runBlock(finalizedAddBlock), SKAction.waitForDuration(duration / 2)])
        runAction(SKAction.repeatActionForever(action), withKey: "addBlock")
        
    }
    
    //Function that is called if song is over or opacity dropped too low
    
    func endGame(finished: Bool){
        
        var value : Double?
        
        musicPlayer.stop()
        
        let previous = self.userData?.objectForKey("Previous Screen") as! String
        
//        println("The score at end of gameScene: \(score!)")
//        println("The totalPossible as the end of gamescene: \(totalPossibleScore!)")
//        println("The missed blocks total score: \(missedCount)")
        
        value = Double(score!) / Double(totalPossibleScore!)
        
        value = value! * 100
        
//        println("The value computed in GameScene: \(value)")
        
        value = min((value!), 100.0)

        myChart.removeFromSuperview()
        mySecondChart.removeFromSuperview()

            
            let gameOverScene = FallGameOverScene(size: myView!.bounds.size)
        
            gameOverScene.userData = NSMutableDictionary()
            gameOverScene.userData?.setObject(value!, forKey:"Song Percentage")
            
            if let custom = self.userData?.objectForKey("custom") as? Bool{
                gameOverScene.userData?.setObject(mediaItem!, forKey: "song")
                gameOverScene.userData?.setObject(true, forKey: "custom")
                gameOverScene.userData?.setObject(songBPM, forKey: "songBPM")
            } else {
                gameOverScene.userData?.setObject(level, forKey: "CurrentUserLevel")
            }
            
            gameOverScene.userData?.setObject(previous, forKey: "Previous Screen")
            
            gameOverScene.scaleMode = scaleMode
            let transition = SKTransition.crossFadeWithDuration(0.5)
            view?.presentScene(gameOverScene, transition: transition)

    }
    
    // clear actions when level is over to keep memory clear
    
    func finishedLevel(){
        removeActionForKey("addBlock")
    }
    
    //Hacky I know, but couldn't get the damn thing to work with physics bodies for some reason. 
    //So best solution I could come up with to handle missing/grabbing blocks successfully.
    
    override func didFinishUpdate() {
        
        if let node = nodeAtPoint(leftOfWinningPosition) as? Block{
            if node.colorDesc == logic.chosenColor {
                logic.blockAlpha -= CGFloat(0.014)
                missedCount!++
            }
        }
        if let node = nodeAtPoint(rightOfWinningPosition) as? Block{
            if node.colorDesc == logic.chosenColor {
                logic.blockAlpha -= CGFloat(0.014)
                missedCount!++
            }
        }
        if let node = nodeAtPoint(blockWinningPosition) as? Block {
            if node.colorDesc == logic.chosenColor && node.name == "block" {
                score!++
//                println("\(score)")
                if logic.blockAlpha < 1.0 {
                    logic.blockAlpha += CGFloat(0.007)
                }
            }
        }
        
        if logic.blockAlpha >= 0 {
            myChart.updateChartByCurrent(score!)
            mySecondChart.updateChartByCurrent(logic.blockAlpha*100)
        }
        if logic.blockAlpha < -0.15 {
            finishedGame = false
        }
    }
    
    //MARK: Gesture Handlers
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        if scene!.view?.paused == false {
            enumerateChildNodesWithName("block") { [unowned self] node, stop in
                let block = node as! Block
                
                let test = block.position.x
                switch test {
                case self.logic.column1:
                    let swipeAction = SKAction.moveToX(self.logic.column2, duration: 0.1)
                    block.runAction(swipeAction)
                case self.logic.column2:
                    let swipeAction = SKAction.moveToX(self.logic.column3, duration: 0.1)
                    block.runAction(swipeAction)
                case self.logic.column3:
                    let swipeAction = SKAction.moveToX(self.logic.column1, duration: 0.1)
                    block.runAction(swipeAction)
                default: break
                }
            }
        }

    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        if scene!.view?.paused == false {
            enumerateChildNodesWithName("block") { [unowned self] node, stop in
                let block = node as! Block
                
                switch block.position.x {
                case self.logic.column1:
                    let swipeAction = SKAction.moveToX(self.logic.column3, duration: 0.1)
                    block.runAction(swipeAction)
                case self.logic.column2:
                    let swipeAction = SKAction.moveToX(self.logic.column1, duration: 0.1)
                    block.runAction(swipeAction)
                case self.logic.column3:
                    let swipeAction = SKAction.moveToX(self.logic.column2, duration: 0.1)
                    block.runAction(swipeAction)
                default: break
                }
            }
        }

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode.name == "pause" && finishedGame && songLength != 0{
            
            if scene!.view?.paused == false {
                
                UIView.animateWithDuration(0.05, animations: {
                    self.artist.alpha = 0.03
                })
                pause()
                
            }
        }
        
        if touchedNode.name == "resume" {
            UIView.animateWithDuration(0.3, animations: {
                self.artist.alpha = 1
            })
            resume()
        }
        
        if touchedNode.name == "restart" {
            
            removeAllChildren()
            removeAllActions()
            myChart.removeFromSuperview()
            mySecondChart.removeFromSuperview()
            clock?.invalidate()
            clock = nil
            musicPlayer.stop()
            artist.removeFromSuperview()
            
            timerIsEnabled = true
            scene!.view?.paused = false
            setUpScene(myView!)
        }
        
        if touchedNode.name == "home" {
            
            myChart.removeFromSuperview()
            mySecondChart.removeFromSuperview()
            
            self.musicPlayer.stop()
            
            let newGameScene = FallStartGameScene(size: size)
            newGameScene.scaleMode = scaleMode
            
            let transitionType = SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 0.5)
            
            removeAllActions()
            removeAllChildren()
            scene!.view?.paused = false
            view?.presentScene(newGameScene, transition: transitionType)
            
            artist.removeFromSuperview()
        }
    }
    
    //MARK: Pause and Resume Functions
    
    func pause(){

        let pauseAction = SKAction.runBlock({
            
            self.scene!.view?.paused = true
            self.timerIsEnabled = false
            if self.musicPlayer.playing {
                self.musicPlayer.pause()
            }
        })
        
        
        let nodesAction = SKAction.runBlock(addPauseNodes)
        
        let action = SKAction.sequence([nodesAction, pauseAction])
        runAction(action)
        
    }
    
    func resume(){
        
        removeChildrenInArray(utilArray)
        
        if timer <= 0 {
            musicPlayer.play()
        }
        
        scene!.view?.paused = false
        timerIsEnabled = true
    }
    
    func addPauseNodes(){
        
        let pauseBackground = SKSpriteNode(imageNamed: "pause background")
        pauseBackground.position = CGPoint(x: view!.bounds.midX, y: view!.bounds.midY)
        pauseBackground.name = "null"
        pauseBackground.size = view!.bounds.size
        pauseBackground.zPosition = 2
        addChild(pauseBackground)
        
        let homeNode = SKSpriteNode(imageNamed: "homeIcon")
        homeNode.position = CGPoint(x: view!.bounds.midX, y: view!.bounds.midY + view!.bounds.midY / 2.5)
        homeNode.zPosition = 3
        homeNode.name = "home"
        addChild(homeNode)
        
        let restartNode = SKSpriteNode(imageNamed: "restartIcon")
        restartNode.position = CGPoint(x: view!.bounds.midX, y: view!.bounds.midY + view!.bounds.midY / 7.5)
        restartNode.zPosition = 3
        restartNode.name = "restart"
        addChild(restartNode)
        
        let resumeNode = SKSpriteNode(imageNamed: "play")
        resumeNode.position = CGPoint(x: view!.bounds.midX, y: view!.bounds.midY - view!.bounds.midY / 8)
        resumeNode.zPosition = 3
        resumeNode.name = "resume"
        addChild(resumeNode)
        
        view!.sendSubviewToBack(artist)
        
        utilArray = [pauseBackground, homeNode, restartNode, resumeNode]
    }
    
    //MARK: Adding Blocks to GameScene
    
    func finalizedAddBlock() {
        var blockArray = logic.finalizedAddBlock()
        let fallingBlockAction = SKAction.moveToY(0 - view!.bounds.maxX / 3, duration: duration * Double(chosenSpeed))
        let removeBlockAction = SKAction.removeFromParent()
        
        switch blockArray.count {
            
        case 1:
            
            let block = blockArray[0]
            addChild(block!)
            
            block!.runAction(SKAction.sequence([fallingBlockAction, removeBlockAction]))
            
        case 2:
            
            let block = blockArray[0]
            let block2 = blockArray[1]
            addChild(block!)
            addChild(block2!)
            
            block!.runAction(SKAction.sequence([fallingBlockAction, removeBlockAction]))
            block2!.runAction(SKAction.sequence([fallingBlockAction, removeBlockAction]))

        case 3:
            
            let block = blockArray[0]
            let block2 = blockArray[1]
            let block3 = blockArray[2]
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

