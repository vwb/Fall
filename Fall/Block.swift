//
//  Block.swift
//  Fall
//
//  Created by Vincent Budrovich on 8/7/15.
//  Copyright (c) 2015 Vincent Budrovich. All rights reserved.
//

import UIKit
import SpriteKit

class Block: SKSpriteNode {
    
    var currentRow = 0
    var colorDesc : String?
    
    init (color: String) {
        let blockColor = SKTexture(imageNamed: color)
        super.init(texture: blockColor, color: SKColor.clearColor(), size: blockColor.size())
        self.name = "block"
        self.colorDesc = "\(color)"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
