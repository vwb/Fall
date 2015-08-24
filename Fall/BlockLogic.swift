//
//  BlockLogic.swift
//  Fall
//
//  Created by Vincent Budrovich on 8/13/15.
//  Copyright (c) 2015 Vincent Budrovich. All rights reserved.
//

import Foundation
import SpriteKit

class BlockLogic {
    
    var column1 : CGFloat
    var column2 : CGFloat
    var column3 : CGFloat
    var columnArray = [CGFloat]()
    var myView : SKView
    var blockAlpha = CGFloat(0.5)
    var addWinningBlock = true
    var blockSize : CGSize?
    var previousWinningColumn : CGFloat?
    
    var blockList : [String]
    
    var chosenColor = String()
    
    init (view: SKView){
        
        column1 = (view.bounds.width / 3) / 2
        column2 = column1 + (view.bounds.width / 3)
        column3 = column2 + (view.bounds.width / 3)
        columnArray.append(column1)
        columnArray.append(column2)
        columnArray.append(column3)
        
        blockSize = CGSize(width: view.bounds.width / 3, height: view.bounds.width / 3)
        
        blockList = [BlockColor.greenBlock, BlockColor.redBlock, BlockColor.blueBlock, BlockColor.orangeBlock, BlockColor.tealBlock, BlockColor.purpleBlock]
        
        myView = view
        
    }
    
    init (view: SKView, opacity: CGFloat){
        
        column1 = (view.bounds.width / 3) / 2
        column2 = column1 + (view.bounds.width / 3)
        column3 = column2 + (view.bounds.width / 3)
        columnArray.append(column1)
        columnArray.append(column2)
        columnArray.append(column3)
        
        blockSize = CGSize(width: view.bounds.width / 3, height: view.bounds.width / 3)
        
        blockList = [BlockColor.greenBlock, BlockColor.redBlock, BlockColor.blueBlock, BlockColor.orangeBlock, BlockColor.tealBlock, BlockColor.purpleBlock]
        
        myView = view
        
        blockAlpha = opacity
        
    }
    
    init ()  {
        blockList = [String]()
        myView = SKView()
        column1 = CGFloat(0)
        column2 = CGFloat(0)
        column3 = CGFloat(0)
    }
    
    func finalizedAddBlock() -> [Block?] {
        
        var blockArray = [Block?]()
        let blockPositionHeight = CGFloat(myView.bounds.maxY + myView.bounds.maxX / 3)
        let numberOfBlocks = (arc4random() % 4)
        let winningBlockOdds = (arc4random() % 5)
        var block1 : Block?
        
        columnArray = [column1, column2, column3]
        
        var columnFirst = randomColumn(nil)

        
        if addWinningBlock {
            
            block1 = getWinningBlock()
            
            addWinningBlock = false
            
            var winningColumn = columnFirst
            
            if winningColumn == previousWinningColumn{
                
                winningColumn = randomColumn(previousWinningColumn)
                columnFirst = winningColumn
                columnArray = [column1, column2, column3]
                
            } else {
                
                previousWinningColumn = winningColumn
            }
            
            block1!.position = (CGPointMake(winningColumn, blockPositionHeight))
            
            
//            block1!.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: myView.bounds.width / 3.5, height: myView.bounds.width / 3.5))
//            block1!.physicsBody?.dynamic = true
//            block1!.physicsBody?.categoryBitMask = PhysicsCategory.fallingWinningBlock
//            block1!.physicsBody?.contactTestBitMask = PhysicsCategory.bouncers | PhysicsCategory.winningTest
//            block1!.physicsBody?.collisionBitMask = PhysicsCategory.None
//            block1!.physicsBody?.usesPreciseCollisionDetection = true
//            block1!.physicsBody?.affectedByGravity = false
            
        } else {
            
            block1 = chooseBlock()
            block1?.position = CGPointMake(columnFirst, blockPositionHeight)
            addWinningBlock = true
            
        }
        
        block1?.alpha = blockAlpha
        block1?.size = blockSize!
        
        switch numberOfBlocks{
        case 0:
            
            blockArray.append(block1)
            
        case 1:
            var block2 : Block?
    
            block2 = chooseBlock()
            
            let columnSecond = randomColumn(columnFirst)
            
            block2?.alpha = blockAlpha
            block2?.position = CGPointMake(columnSecond, blockPositionHeight)
            block2?.size = blockSize!
            blockArray.append(block1)
            blockArray.append(block2)
            
        case 2:
            
            var block2 : Block?
            var block3 : Block?

            block2 = chooseBlock()
            block3 = chooseBlock()
            
            let columnSecond = randomColumn(columnFirst)
            let columnThird = randomColumn(columnSecond)
            
            block2?.alpha = blockAlpha
            block2?.position = CGPointMake(columnSecond, blockPositionHeight)
            block2?.size = blockSize!
            
            block3?.alpha = blockAlpha
            block3?.position = CGPointMake(columnThird, blockPositionHeight)
            block3?.size = blockSize!
            
            blockArray.append(block1)
            blockArray.append(block2)
            blockArray.append(block3)
            
        case 3:
            
             blockArray.append(block1)
            
        default: break
            
        }
        
        return blockArray
    }

    
    //chooses the color sprite the player aims to find
    func chosenBlock() -> Block {
        let chosenBlockColor = randomBlockChooser()
        
        let i = find(blockList, chosenBlockColor as String)
        blockList.removeAtIndex(i!)
        BlockColor.blockNum = 5
        
        chosenColor = chosenBlockColor as String
        let block = Block(color: chosenBlockColor as String)
        return block
    }
    
    //chooses an arbitrary block color
    func chooseBlock() -> Block {
        let blockColor = randomBlockChooser()
        let block = Block(color: blockColor as String)
        return block
    }
    
    //return the winning block
    func getWinningBlock() -> Block {
        let block = Block(color: chosenColor)

        
        return block
    }
    
    struct BlockColor {
        static var greenBlock = "greenrectangle@1x"
        static var redBlock = "redrectangle@1x"
        static var blueBlock = "bluerectangle@1x"
        static var orangeBlock = "orangerectangle@1x"
        static var tealBlock = "tealrectangle@1x"
        static var purpleBlock = "purplerectangle2@1x"
        static var blockNum = 6
    }
    
    func randomBlockChooser() -> NSString {
        
        let num =  Int(arc4random() % UInt32(BlockColor.blockNum))
        return blockList[num]
        
    }
    
    func randomColumn(throwAwayValue: CGFloat?) -> CGFloat {
        
        if (throwAwayValue != nil) {
            
            let i = find(columnArray, throwAwayValue!)
            columnArray.removeAtIndex(i!)
            let num = Int(arc4random() % UInt32(columnArray.count))
            return columnArray[num]
            
        } else {
            
            let num = Int(arc4random() % 3)
            return columnArray[num]
            
        }
    }
    
}