//
//  TileView.swift
//  NanoChallengeGameOfLife
//
//  Created by Pedro Henrique Guedes Silveira on 01/11/19.
//  Copyright © 2019 Pedro Henrique Guedes Silveira. All rights reserved.
//

import Foundation
import SceneKit

public class TileView: GridElement {
    
    var tile: TileNode
    var body: SCNBox
    var position: SCNVector3
    var isAlive: Bool
    
    init(xPosition: Int, yPosition: Int, xPositionOnScene:Int, YpositionOnScene:Int) {
        
        self.body = SCNBox(width: 0.8, height: 0.8, length: 0, chamferRadius: 0)
        self.body.firstMaterial?.diffuse.contents = UIColor.magenta
        
        self.isAlive = false
        
        self.tile = TileNode()
        
        self.tile.geometry = body
        
        self.position = SCNVector3(xPositionOnScene, YpositionOnScene, 1)
        
        super.init(x: xPosition, y: yPosition)
        
        
        self.tile.tileView = self
        
        if isAlive == true {
            self.body.firstMaterial?.diffuse.contents = UIColor.magenta
        } else {
            self.body.firstMaterial?.diffuse.contents = UIColor.gray
        }
        
        self.tile.position = position
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeTileState(state: Bool) {
        
        let state = state
        if state == true {
            isAlive = true
            self.body.firstMaterial?.diffuse.contents = UIColor.magenta
        } else {
            isAlive = false
            self.body.firstMaterial?.diffuse.contents = UIColor.gray
        }
    }
}

