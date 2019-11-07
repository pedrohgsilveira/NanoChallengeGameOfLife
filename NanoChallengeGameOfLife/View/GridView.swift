//
//  GridView.swift
//  NanoChallengeGameOfLife
//
//  Created by Pedro Henrique Guedes Silveira on 01/11/19.
//  Copyright © 2019 Pedro Henrique Guedes Silveira. All rights reserved.
//

import Foundation
import SceneKit

class GridView {
    
    var tiles: [TileView] = []
    var grid: Grid
    var numberOfColums: Int
    var numberOfLines: Int
    
    init(rowSize: Int, numberOfElements: Int) {
        
        self.grid = Grid(rowSize: rowSize, numberOfElements: numberOfElements)
        self.numberOfLines = self.grid.calculateNumberOfLines()
        self.numberOfColums = rowSize
        createTiles()
    }
    
    func createTiles() {
        
        for x in 0..<numberOfColums {
            for y in 0..<numberOfLines {
                let tileNode = TileView(xPosition: x, yPosition: y, xPositionOnScene: x - (self.numberOfColums / 2), YpositionOnScene: y - (self.numberOfLines / 2), type: .dead)
//                tileNode.isAlive = false
                tiles.append(tileNode)
            }
        }
    }
    
    func findIfIsNeighbor(by x: Int, by y: Int) -> [TileView] {
        
        var neighborElements: [TileView] = []
        for xValue in -1...1{
            for yValue in -1...1{
                if !(xValue == 0 && yValue == 0) {
                    if let onRange = grid.findElementIndex(by: xValue + x, by: yValue + y) {
                        let neighbor = tiles[onRange]
                        neighborElements.append(neighbor)
                    }
                }
            }
        }
        
        return neighborElements
    }

    
        func aliveNeighbor(by xPosition: Int, by yPosition: Int) -> Int? {
        
        var aliveNeighbors: [TileView] = []
        let neighbor = findIfIsNeighbor(by: xPosition, by: yPosition)
            
            
        for i in neighbor {
            if i.isAlive == true {
                aliveNeighbors.append(i)
            }
        }
        
        return aliveNeighbors.count
    }

}


