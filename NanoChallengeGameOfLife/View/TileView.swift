//
//  TileView.swift
//  NanoChallengeGameOfLife
//
//  Created by Pedro Henrique Guedes Silveira on 01/11/19.
//  Copyright © 2019 Pedro Henrique Guedes Silveira. All rights reserved.
//

import Foundation
import SceneKit

public class TileView: GridElement, NSCopying {

    var tile: TileNode
    var body: SCNBox
    var position: SCNVector3 {
        didSet {
            self.tile.position = self.position
        }
    }
    var isAlive: Bool
    var type: TileType
    
    init(xPosition: Int, yPosition: Int, xPositionOnScene:Int, YpositionOnScene:Int, type: TileType) {
        
        self.body = SCNBox(width: 0.8, height: 0.8, length: 0.8, chamferRadius: 0)
        self.body.firstMaterial?.diffuse.contents = UIColor.magenta
        
        self.type = type
        self.isAlive = type.isAlive
        
        self.tile = TileNode()
        
        self.tile.geometry = body
        
        self.position = SCNVector3(xPositionOnScene, YpositionOnScene, 1)
        
        super.init(x: xPosition, y: yPosition)
        
        
        self.tile.tileView = self
        
        if isAlive == true {
            self.body.firstMaterial?.diffuse.contents = UIColor.magenta
        } else {
            self.body.firstMaterial?.diffuse.contents = UIColor.cyan
        }
        
        self.tile.position = position
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeTileState(state: Bool) {
        
        if state {
            switch type {
            case .alive:
                self.type = .alive
                self.isAlive = type.isAlive
                self.body.firstMaterial?.diffuse.contents = UIColor.magenta
            case .demiAlive:
                self.type = .alive
                self.isAlive = type.isAlive
                self.body.firstMaterial?.diffuse.contents = UIColor.magenta
            case .dead:
                self.type = .alive
                self.isAlive = type.isAlive
                self.body.firstMaterial?.diffuse.contents = UIColor.magenta
            }
        } else {
            switch type {
            case .alive:
                self.type = .demiAlive
                self.isAlive = type.isAlive
                self.body.firstMaterial?.diffuse.contents = UIColor.systemPink
            case .demiAlive:
                self.type = .dead
                self.isAlive = type.isAlive
                self.body.firstMaterial?.diffuse.contents = UIColor.cyan
            case .dead:
                self.type = .dead
                self.isAlive = type.isAlive
                self.body.firstMaterial?.diffuse.contents = UIColor.cyan
            }
        }
    }
    
    func changeConstructTileState(state: Bool) {
        
            if state {
                isAlive = true
                self.body.firstMaterial?.diffuse.contents = UIColor.magenta
            } else {
                isAlive = false
                self.body.firstMaterial?.diffuse.contents = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = TileView(xPosition: x, yPosition: y, xPositionOnScene: Int(position.x), YpositionOnScene: Int(position.y), type: type)
        return copy
    }
}

